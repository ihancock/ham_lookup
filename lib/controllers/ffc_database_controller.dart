import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:ham_lookup/string_extensions.dart';
import 'package:ham_lookup/types/ham.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:ham_lookup/models/fcc_database.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ham_lookup/list_extensions.dart';

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

  Future<void> downloadDatabase() async {
    updateModel(() {
      model.syncStatus = SyncStatus.inProgress;
    });
    preferences ??= await SharedPreferences.getInstance();
    final now = DateTime.now();
    final lastSyncString = preferences?.getString('lastSync');
    print(lastSyncString);
    DateTime? lastSync =
        lastSyncString != null ? DateTime.tryParse(lastSyncString) : null;
    try {
      if (lastSync == null || now.difference(lastSync).inDays > 7) {
        print('Performing full sync');
        final response = await http.get(Uri.parse(
            'https://data.fcc.gov/download/pub/uls/complete/l_amat.zip'));
        await preferences!.setString('lastSync', now.toIso8601String());
        await _archiveResponse(response, suffix: 'complete');
      }
      await _processArchive(suffix: 'complete');
      print('Count after complete sync: ${model.hams.length}');
      lastSync = now;
      print('Performing daily sync');
      final days = calculateDaysFileSuffixes(lastSync);
      for (final day in days) {
        try {
          final response = await http.get(Uri.parse(
              'https://data.fcc.gov/download/pub/uls/daily/l_am_${day}.zip'));
          print('Processing response for $day');
          await _archiveResponse(response, suffix: '$day');
          await _processArchive(suffix: '$day');
          print('Count after day $day sync: ${model.hams.length}');
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      await preferences!.setString('lastSync', now.toIso8601String());
    } catch (e) {
      debugPrint(e.toString());
    }

    updateModel(() {
      model.syncStatus = SyncStatus.complete;
    });
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

  Future<void> _processArchive(
      {required String suffix}) async {
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
          callSign: fields[4],
          fccId: fields[1],
          fullName: fields[7].captitalizeFirstLetters().trim(),
          address1: fields[15].isNotEmpty
              ? fields[15].captitalizeFirstLetters().trim()
              : 'PO Box ${fields[19]}',
          city: fields[16].captitalizeFirstLetters().trim(),
          state: fields[17],
          zip: fields[18]));
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

  List<Ham> searchByCity(String city) {
    var results = model.hams
        .where(
            (e) => e.city?.startsWith(city.captitalizeFirstLetters()) == true)
        .toList();
    results.sort((a, b) => (a.fullName ?? '').compareTo(b.fullName ?? ''));
    return results;
  }

  List<Ham> searchByAddress(String address) {
    var results = model.hams
        .where((e) =>
            e.address1?.toLowerCase().contains(address.toLowerCase()) == true)
        .toList();
    results.sort((a, b) => (a.fullName ?? '').compareTo(b.fullName ?? ''));
    return results;
  }

  List<Ham> searchByState(String state) {
    var results = model.hams
        .where((e) => e.state?.startsWith(state.toUpperCase()) == true)
        .toList();
    results.sort((a, b) => (a.fullName ?? '').compareTo(b.fullName ?? ''));
    return results;
  }

  void setTabAndSearchTerm({required SearchTab tab, String? searchTerm}) {
    updateModel(() {
      model.tab = tab;
      model.searchTerm = searchTerm;
    });
  }
}
