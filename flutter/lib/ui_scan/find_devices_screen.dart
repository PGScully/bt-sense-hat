import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:bt_sense_hat/ui_scan/connected_device_tile.dart';
import 'package:bt_sense_hat/ui_scan/scan_result_tile.dart';

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Devices"),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (_, snapshot) {
            if (snapshot.data) {
              return FloatingActionButton(
                onPressed: () => FlutterBlue.instance.stopScan(),
                backgroundColor: Colors.red,
                child: const Icon(Icons.stop),
              );
            } else {
              return FloatingActionButton(
                onPressed: () => FlutterBlue.instance
                    .startScan(timeout: const Duration(seconds: 4)),
                child: const Icon(Icons.search),
              );
            }
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: const <Widget>[
              // ConnectedDevices(),
              ScanResults(),
            ],
          ),
        ),
      );
}

class ConnectedDevices extends StatelessWidget {
  const ConnectedDevices({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<BluetoothDevice>>(
        stream: Stream<void>.periodic(const Duration(seconds: 2))
            .asyncMap((_) => FlutterBlue.instance.connectedDevices),
        initialData: const [],
        builder: (_, snapshot) => Column(
          children: snapshot.data
              .map((device) => ConnectedDeviceTile(device: device))
              .toList(),
        ),
      );
}

class ScanResults extends StatelessWidget {
  const ScanResults({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<ScanResult>>(
        stream: FlutterBlue.instance.scanResults,
        initialData: const [],
        builder: (_, snapshot) => Column(
          children: snapshot.data
              .where(
                  (element) => element.device.name == "Sense Hat Environment")
              .map((r) => ScanResultTile(result: r))
              .toList(),
        ),
      );
}
