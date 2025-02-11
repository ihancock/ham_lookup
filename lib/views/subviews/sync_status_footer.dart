import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:ham_lookup/controllers/ffc_database_controller.dart';
import 'package:ham_lookup/model_provider/model_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:ham_lookup/models/fcc_database.dart';

class SyncStatusFooter extends StatefulWidget {
  const SyncStatusFooter({super.key});

  @override
  State<SyncStatusFooter> createState() => _SyncStatusFooterState();
}

class _SyncStatusFooterState
    extends ModelState<SyncStatusFooter, FccDatabaseController> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool connected = false;

  _SyncStatusFooterState() : super(controller: FccDatabaseController());

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      final previousConnectionStatus = _connectionStatus;
      _connectionStatus = result;
      connected = !_connectionStatus.contains(ConnectivityResult.none);
      if (connected &&
          previousConnectionStatus.contains(ConnectivityResult.none)) {
        //  controller.downloadDatabase(connected);
      }
      controller.downloadDatabase(connected);
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  @override
  Widget build(BuildContext context) {
    Widget syncWidget = SizedBox.shrink();
    switch (controller.model.syncStatus) {
      case SyncStatus.none:
        syncWidget = const Text(
          'FCC Database out of date',
          style: TextStyle(color: Colors.red),
        );
        break;
      case SyncStatus.amFile:
        syncWidget = const Text(
          'Syncing Amateur File',
          style: TextStyle(color: Colors.black38),
        );
        break;
      case SyncStatus.coFile:
        syncWidget = const Text(
          'Syncing Comments File',
          style: TextStyle(color: Colors.black38),
        );
        break;
      case SyncStatus.downloading:
        syncWidget = const Text(
          'Downloading',
          style: TextStyle(color: Colors.black38),
        );
        break;
      case SyncStatus.enFile:
        syncWidget = const Text(
          'Syncing Entity File',
          style: TextStyle(color: Colors.black38),
        );
        break;
      case SyncStatus.hdFile:
        syncWidget = const Text(
          'Syncing Header File',
          style: TextStyle(color: Colors.black38),
        );
        break;
      case SyncStatus.hsFile:
        syncWidget = const Text(
          'Syncing History File',
          style: TextStyle(color: Colors.black38),
        );
        break;
      case SyncStatus.syncing:
        syncWidget = const Text(
          'Syncing',
          style: TextStyle(color: Colors.black38),
        );
        break;
      case SyncStatus.complete:
        syncWidget = Text(
          'Synced  ${controller.model.enRecords.length} records',
          style: TextStyle(color: Colors.green),
        );
        break;
    }
    return Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white54,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            connected
                ? Icon(
                    Icons.power,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.power_off,
                    color: Colors.red,
                  ),
            Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: syncWidget),
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: IconButton(
                icon: const Icon(Icons.sync),
                onPressed: () async {
                  await controller.downloadDatabase(connected);
                },
              ),
            ),
          ],
        ));
  }
}
