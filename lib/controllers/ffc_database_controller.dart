import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ham_lookup/models/sort_details.dart';
import 'package:ham_lookup/string_extensions.dart';
import 'package:ham_lookup/types/am_record.dart';
import 'package:ham_lookup/types/applicant_type.dart';
import 'package:ham_lookup/types/co_record.dart';
import 'package:ham_lookup/types/en_record.dart';
import 'package:ham_lookup/types/entity_type.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:ham_lookup/models/fcc_database.dart';
import 'package:ham_lookup/types/ham.dart';
import 'package:ham_lookup/types/hd_record.dart';
import 'package:ham_lookup/types/operator_class.dart';
import 'package:ham_lookup/types/status_code.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FccDatabaseController extends ModelController<FccDatabase> {
  static final FccDatabaseController _instance = FccDatabaseController._();

  FccDatabaseController._() : super(modelCreator: () => FccDatabase());

  factory FccDatabaseController() => _instance;

  SharedPreferences? preferences;
  final List<String> _syncDays = [
    'mon',
    'tue',
    'wed',
    'thu',
    'fri',
    'sat',
  ];

  bool syncInProgress = false;

  Future<void> downloadDatabase(bool online) async {
    if (!syncInProgress) {
      syncInProgress = true;

      updateModel(() {
        model.syncStatus = SyncStatus.inProgress;
      });
      preferences ??= await SharedPreferences.getInstance();
      final now = DateTime.now();
      final lastSyncString = preferences?.getString('lastSync');
      DateTime? lastSync = DateTime.tryParse(lastSyncString ?? '');
      try {
        if ((lastSync == null || now.difference(lastSync).inDays > 7) &&
            online) {
          final response = await http.get(Uri.parse(
              'https://data.fcc.gov/download/pub/uls/complete/l_amat.zip'));
          await preferences!.setString('lastSync', now.toIso8601String());
          await _archiveResponse(response, suffix: 'complete');
        }
        if (model.enRecords.isEmpty) {
          await _processArchive(suffix: 'complete');
        }
        if (lastSync == null || now.difference(lastSync).inMinutes > 59) {
          lastSync = now;
          final days = calculateDaysFileSuffixes(lastSync);
          for (final day in days) {
            try {
              if (online) {
                final response = await http.get(Uri.parse(
                    'https://data.fcc.gov/download/pub/uls/daily/l_am_${day}.zip'));
                await _archiveResponse(response, suffix: '$day');
              }
              await _processArchive(suffix: '$day');
            } catch (e) {
              debugPrint(e.toString());
            }
          }
        }
        await preferences!.setString('lastSync', now.toIso8601String());
      } catch (e) {
        debugPrint(e.toString());
      }

      updateModel(() {
        model.syncStatus = SyncStatus.complete;
      });
      syncInProgress = false;
    }
  }

  Future<void> _archiveResponse(http.Response response,
      {required String suffix}) async {
    final Directory tempDir = await getTemporaryDirectory();
    final Directory directory = Directory('${tempDir.path}/$suffix');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final archive =
        ZipDecoder().decodeStream(InputMemoryStream(response.bodyBytes));
    await extractArchiveToDisk(archive, directory.path);
  }

  Future<void> _processArchive({required String suffix}) async {
    List<Future> tasks = [];

    final Directory tempDir = await getTemporaryDirectory();
    final Directory directory = Directory('${tempDir.path}/$suffix');
    final enDataFile = File('${directory.path}/EN.dat');
    tasks.add(enDataFile
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .forEach((line) async {
      final fields = line.split('|');
      model.enRecords.add(EnRecord(
          fccId: int.parse(fields[1]),
          ulsFileNumber: fields[2],
          ebfNumber: fields[3],
          callSign: fields[4],
          entityType: EntityType.values
              .firstWhereOrNull((e) => e.name.toUpperCase() == fields[5]),
          licenseId: fields[6],
          entityName: fields[7].captitalizeFirstLetters().trim(),
          firstName: fields[8].captitalizeFirstLetters().trim(),
          middleInitial: fields[9],
          lastName: fields[10].captitalizeFirstLetters().trim(),
          suffix: fields[11].captitalizeFirstLetters().trim(),
          phone: fields[12],
          fax: fields[13],
          email: fields[14],
          streetAddress: fields[15].isNotEmpty
              ? fields[15].captitalizeFirstLetters().trim()
              : 'PO Box ${fields[19]}',
          city: fields[16].captitalizeFirstLetters().trim(),
          state: fields[17],
          zip: fields[18],
          poBox: fields[19],
          attentionLine: fields[20].captitalizeFirstLetters().trim(),
          sgin: fields[21],
          frn: fields[22],
          applicantType: ApplicantType.values
              .firstWhereOrNull((e) => e.name.toUpperCase() == fields[23]),
          applicantTypeOther: fields[24],
          statusCode: StatusCode.values
              .firstWhereOrNull((e) => e.name.toUpperCase() == fields[25]),
          statusDate: fields[26]));
    }));
    final amDataFile = File('${directory.path}/AM.dat');
    tasks.add(amDataFile
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .forEach((line) async {
      final fields = line.split('|');
      model.amRecords.add(AmRecord(
          fccId: int.parse(fields[1]),
          callSign: fields[4],
          operatorClass: OperatorClass.values
              .firstWhereOrNull((e) => e.name.toUpperCase() == fields[5]),
          groupCode: fields[6],
          regionCode: fields[7],
          trusteeCallSign: fields[8],
          trusteeIndicator: fields[9],
          physicianCertification: fields[10],
          veSignature: fields[11],
          systemicCallSignChange: fields[12],
          vanityCallSignChange: fields[13],
          vanityRelationShip: fields[14],
          previousCallSign: fields[15],
          previousOperatorClass: fields[16],
          trusteeName: fields[17]));
    }));
    final hdDataFile = File('${directory.path}/HD.dat');
    tasks.add(hdDataFile
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .forEach((line) async {
      final fields = line.split('|');
      model.hdRecords.add(HdRecord(
          fccId: int.parse(fields[1]),
          ulsFileNumber: fields[2],
          ebfNumber: fields[3],
          callSign: fields[4],
          licenseStatus: fields[5],
          radioServiceCode: fields[6],
          grantDate: fields[7],
          expiredDate: fields[8],
          cancellationDate: fields[9],
          eligibilityRuleNum: fields[10],
          alien: fields[12],
          alienGovernment: fields[13],
          alienCorporation: fields[14],
          alienOfficer: fields[15],
          alienControl: fields[16],
          revoked: fields[17],
          convicted: fields[18],
          adjudged: fields[19],
          commonCarrier: fields[21],
          nonCommonCarrier: fields[22],
          privateComm: fields[23],
          fixed: fields[24],
          mobile: fields[25],
          radioLocation: fields[26],
          satellite: fields[27],
          developmentalOrStaOrDemonstration: fields[28],
          interconnectedService: fields[29],
          certifierFirstName: fields[30],
          certifierMi: fields[31],
          certifierLastName: fields[32],
          certifierSuffix: fields[33],
          certifierTitle: fields[34],
          female: fields[35],
          blackOrAfricanAmerican: fields[36],
          nativeAmerican: fields[37],
          hawaiian: fields[38],
          asian: fields[39],
          white: fields[40],
          hispanic: fields[41],
          effectiveDate: fields[42],
          lastActionDate: fields[43],
          auctionId: fields[44],
          broadcastServicesRegulatoryStatus: fields[45],
          bandManagerRegulatoryStatus: fields[46],
          broadcastServicesTypeOfRadioService: fields[47],
          alienRuling: fields[48],
          licenseeNameChange: fields[49],
          whitespaceIndicator: fields[50],
          operationPerformanceRequirementChoice: fields[51],
          operationPerformanceRequirementAnswer: fields[52],
          discontinuationOfService: fields[53],
          regulatoryCompliance: fields[54],
          freq900MhzEligibilityCertification: fields[55],
          freq900MhzTransitionPlanCertification: fields[56],
          freq900MhzReturnSpectrumCertification: fields[57],
          freq900MhzPaymentCertification: fields[58]));
    }));
    final coDataFile = File('${directory.path}/CO.dat');
    bool deferred = false;
    String deferredLine = '';
    tasks.add(coDataFile
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .forEach((line) async {
      var fields = line.split('|');

      if (fields.length != 8 && !deferred) {
        deferred = true;
        deferredLine = line;
      } else if (deferred) {
        deferredLine += line;
        if (deferredLine.split('|').length == 8) {
          deferred = false;
          fields = deferredLine.split('|');
          deferredLine = '';
        }
      }
      if (!deferred) {
        model.coRecords.add(CoRecord(
            fccId: int.parse(fields[1]),
            ulsFileNumber: fields[2],
            callSign: fields[3],
            commentDate: fields[4],
            description: fields[5],
            statusCode: StatusCode.values
                .firstWhereOrNull((e) => e.name.toUpperCase() == fields[6]),
            statusDate: fields[7]));
      }
    }));
    await Future.wait(tasks);
  }

  List<String> calculateDaysFileSuffixes(DateTime lastSync) {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    final daysSinceLastSync = now.difference(lastSync).inDays;
    if (daysSinceLastSync > 7) {
      return _syncDays;
    } else {
      return _syncDays.sublist(0, dayOfWeek - 1);
    }
  }

  List<EnRecord> searchByCallSign(String callSign) {
    return model.enRecords
        .where((e) => e.callSign.startsWith(callSign.toUpperCase()))
        .toList();
  }

  List<EnRecord> searchByName(String name) {
    var results = model.enRecords
        .where((e) => (e.entityName).toUpperCase().contains(name.toUpperCase()))
        .toList();
    results.sort((a, b) => (a.entityName).compareTo(b.entityName));
    return results;
  }

  List<EnRecord> searchByCity(String city) {
    var results = model.enRecords
        .where((e) => e.city.startsWith(city.captitalizeFirstLetters()) == true)
        .toList();
    results.sort((a, b) => (a.entityName).compareTo(b.entityName));
    return results;
  }

  List<EnRecord> searchByAddress(String address) {
    var results = model.enRecords
        .where((e) =>
            e.streetAddress.toLowerCase().contains(address.toLowerCase()) ==
            true)
        .toList();
    results.sort((a, b) => (a.entityName).compareTo(b.entityName));
    return results;
  }

  List<EnRecord> searchByState(String state) {
    var results = model.enRecords
        .where((e) => e.state.startsWith(state.toUpperCase()) == true)
        .toList();
    results.sort((a, b) => (a.entityName).compareTo(b.entityName));
    return results;
  }

  void setTabAndSearchTerm({required SearchTab tab, String? searchTerm}) {
    updateModel(() {
      model.tab = tab;
      model.searchTerm = searchTerm;
    });
  }

  List<EnRecord> sortedList(int column, SortDirection direction) {
    List<EnRecord> results = [];
    if (model.tab == SearchTab.callSign) {
      results = searchByCallSign(model.searchTerm ?? '--');
    } else if (model.tab == SearchTab.name) {
      results = searchByName(model.searchTerm ?? '--');
    } else if (model.tab == SearchTab.address) {
      results = searchByAddress(model.searchTerm ?? '--');
    } else if (model.tab == SearchTab.city) {
      results = searchByCity(model.searchTerm ?? '--');
    } else if (model.tab == SearchTab.city) {
      results = searchByState(model.searchTerm ?? '--');
    }

    switch (column) {
      case 0:
        if (direction == SortDirection.asc) {
          results.sort((a, b) => a.fccId.compareTo(b.fccId));
        } else {
          results.sort((b, a) => a.fccId.compareTo(b.fccId));
        }
        break;
      case 1:
        if (direction == SortDirection.asc) {
          results.sort((a, b) => (a.callSign).compareTo(b.callSign));
        } else {
          results.sort((b, a) => (a.callSign).compareTo(b.callSign));
        }
        break;
      case 2:
        if (direction == SortDirection.asc) {
          results.sort((a, b) => (a.entityName).compareTo(b.entityName));
        } else {
          results.sort((b, a) => (a.entityName).compareTo(b.entityName));
        }
        break;
      case 3:
        if (direction == SortDirection.asc) {
          results.sort((a, b) => (a.streetAddress).compareTo(b.streetAddress));
        } else {
          results.sort((b, a) => (a.streetAddress).compareTo(b.streetAddress));
        }
        break;
      case 4:
        if (direction == SortDirection.asc) {
          results.sort((a, b) => (a.city).compareTo(b.city));
        } else {
          results.sort((b, a) => (a.city).compareTo(b.city));
        }
        break;
      case 5:
        if (direction == SortDirection.asc) {
          results.sort((a, b) => (a.state).compareTo(b.state));
        } else {
          results.sort((b, a) => (a.state).compareTo(b.state));
        }
        break;
      case 6:
        if (direction == SortDirection.asc) {
          results.sort((a, b) =>
              (int.tryParse(a.zip) ?? 0).compareTo(int.tryParse(b.zip) ?? 0));
        } else {
          results.sort((b, a) =>
              (int.tryParse(a.zip) ?? 0).compareTo(int.tryParse(b.zip) ?? 0));
        }
        break;
      default:
    }
    return results;
  }

  Ham hamFromEnRecord(EnRecord enRecord) {
    return Ham(
        enRecord: enRecord,
        amRecord: model.amRecords.firstWhere((e) => e.fccId == enRecord.fccId),
        hdRecord: model.hdRecords.firstWhere((e) => e.fccId == enRecord.fccId),
        coRecords:
            model.coRecords.where((e) => e.fccId == enRecord.fccId).toList(),
        relatedRecords: getRelatedRecords(enRecord));
  }

  List<EnRecord> getRelatedRecords(EnRecord enRecord) {
    return model.enRecords
        .where((e) => e.frn == enRecord.frn && e.fccId != enRecord.fccId)
        .toList();
  }
}
