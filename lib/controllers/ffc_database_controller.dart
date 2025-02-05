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

class FccDatabaseController extends ModelController<FccDatabase> {
  static final FccDatabaseController _instance = FccDatabaseController._();

  FccDatabaseController._() : super(modelCreator: () => FccDatabase());

  factory FccDatabaseController() => _instance;

  @override
  Future<void> initialize(BuildContext context) async {
    super.initialize(context);
  }

  Future<void> fullSync() async {
    isLoading = true;
    try {
      final Directory tempDir = await getTemporaryDirectory();
      // final response = await http.get(Uri.parse(
      //     'https://data.fcc.gov/download/pub/uls/complete/l_amat.zip'));
      // final archive = ZipDecoder().decodeStream(
      //     InputMemoryStream(response.bodyBytes));
      //
      final enDataFile = File('${tempDir.path}/EN.dat');
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
        // batch.insert('en', {
        //   'fccid': fields[1],
        //   'callsign': fields[4],
        //   'full_name': fields[7],
        //   'first': fields[8],
        //   'middle': fields[9],
        //   'last': fields[10],
        //   'address1': fields[15],
        //   'city': fields[16],
        //   'state': fields[17],
        //   'zip': fields[18],
        // }, conflictAlgorithm: ConflictAlgorithm.replace);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading = false;
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
