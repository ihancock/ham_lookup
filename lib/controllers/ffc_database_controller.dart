import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ham_lookup/models/sort_details.dart';
import 'package:ham_lookup/string_extensions.dart';
import 'package:ham_lookup/types/am_record.dart';
import 'package:ham_lookup/types/applicant_type.dart';
import 'package:ham_lookup/types/entity_type.dart';
import 'package:ham_lookup/types/ham.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:ham_lookup/models/fcc_database.dart';
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
      print(lastSyncString);
      DateTime? lastSync = DateTime.tryParse(lastSyncString ?? '');
      try {
        if ((lastSync == null || now.difference(lastSync).inDays > 7) &&
            online) {
          print('Performing full sync');
          final response = await http.get(Uri.parse(
              'https://data.fcc.gov/download/pub/uls/complete/l_amat.zip'));
          await preferences!.setString('lastSync', now.toIso8601String());
          await _archiveResponse(response, suffix: 'complete');
        }
        if (model.hams.isEmpty) {
          await _processArchive(suffix: 'complete');
        }
        print('Count after complete sync: ${model.hams.length}');
        if (lastSync == null || now.difference(lastSync).inMinutes > 59) {
          lastSync = now;
          print('Performing daily sync');
          final days = calculateDaysFileSuffixes(lastSync);
          for (final day in days) {
            try {
              if (online) {
                final response = await http.get(Uri.parse(
                    'https://data.fcc.gov/download/pub/uls/daily/l_am_${day}.zip'));
                print('Processing response for $day');
                await _archiveResponse(response, suffix: '$day');
              }
              await _processArchive(suffix: '$day');
              print('Count after day $day sync: ${model.hams.length}');
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
    final Directory tempDir = await getTemporaryDirectory();
    final Directory directory = Directory('${tempDir.path}/$suffix');
    final enDataFile = File('${directory.path}/EN.dat');
    await enDataFile
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .forEach((line) async {
      final fields = line.split('|');
      model.hams.add(Ham(
          fccId: fields[1],
          ulsFileNumber: fields[2],
          ebfNumber: fields[3],
          callSign: fields[4],
          entityType: EntityType.values
              .firstWhereOrNull((e) => e.name.toUpperCase() == fields[5]),
          licenseId: fields[6],
          entityName: fields[7],
          firstName: fields[8],
          middleInitial: fields[9],
          lastName: fields[10],
          suffix: fields[11],
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
          attentionLine: fields[20],
          sgin: fields[21],
          frn: fields[22],
          applicantType: ApplicantType.values
              .firstWhereOrNull((e) => e.name.toUpperCase() == fields[23]),
          applicantTypeOther: fields[24],
          statusCode: StatusCode.values
              .firstWhereOrNull((e) => e.name.toUpperCase() == fields[25]),
          statusDate: fields[26]));
    });
    final amDataFile = File('${directory.path}/AM.dat');
    await amDataFile
        .openRead()
        .transform(utf8.decoder)
        .transform(LineSplitter())
        .forEach((line) async {
      final fields = line.split('|');
      final amRecord = AmRecord(
          fccId: fields[1],
          callSign: fields[4],
          operatorClass: fields[5],
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
          trusteeName: fields[17]);
      if (fields.contains('WM5Q') || fields.contains('KC5NTL')) {
        print(amRecord);
      }

      // model.hams.where((ham) => ham.fccId == amRecord.fccId && ham.callSign)
    });
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

  List<Ham> searchByCallSign(String callSign) {
    return model.hams
        .where((e) => e.callSign.startsWith(callSign.toUpperCase()))
        .toList();
  }

  List<Ham> searchByName(String name) {
    print('searching for $name');
    var results = model.hams
        .where(
            (e) => (e.entityName).toUpperCase().startsWith(name.toUpperCase()))
        .toList();
    results.sort((a, b) => (a.entityName).compareTo(b.entityName));
    return results;
  }

  List<Ham> searchByCity(String city) {
    var results = model.hams
        .where((e) => e.city.startsWith(city.captitalizeFirstLetters()) == true)
        .toList();
    results.sort((a, b) => (a.entityName).compareTo(b.entityName));
    return results;
  }

  List<Ham> searchByAddress(String address) {
    var results = model.hams
        .where((e) =>
            e.streetAddress.toLowerCase().contains(address.toLowerCase()) ==
            true)
        .toList();
    results.sort((a, b) => (a.entityName).compareTo(b.entityName));
    return results;
  }

  List<Ham> searchByState(String state) {
    var results = model.hams
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

  List<Ham> sortedList(int column, SortDirection direction) {
    List<Ham> results = [];
    print('Tab is ${model.tab.name}');
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
          results.sort(
              (a, b) => (int.parse(a.fccId)).compareTo(int.parse(b.fccId)));
        } else {
          results.sort(
              (b, a) => (int.parse(a.fccId)).compareTo(int.parse(b.fccId)));
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
}
