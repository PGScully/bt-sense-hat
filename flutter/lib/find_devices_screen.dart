import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:bt_sense_hat/device_screen.dart';

class ConnectedDeviceTile extends StatelessWidget {
  final BluetoothDevice device;

  const ConnectedDeviceTile({
    Key key,
    this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(device.name),
        subtitle: Text(device.id.toString()),
        trailing: StreamBuilder<BluetoothDeviceState>(
          stream: device.state,
          initialData: BluetoothDeviceState.disconnected,
          builder: (c, snapshot) {
            if (snapshot.data == BluetoothDeviceState.connected) {
              return RaisedButton(
                onPressed: () => Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder: (context) => DeviceScreen(device: device)),
                ),
                child: const Text('OPEN'),
              );
            }
            return Text(snapshot.data.toString());
          },
        ),
      );
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Devices"),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          children: <Widget>[
            // Connected Devices
            StreamBuilder<List<BluetoothDevice>>(
              stream:
                  Stream<void>.periodic(const Duration(seconds: 2)).asyncMap(
                (void _) => FlutterBlue.instance.connectedDevices,
              ),
              initialData: const [],
              builder: (_, snapshot) => Column(
                children: snapshot.data
                    .map((device) => ConnectedDeviceTile(device: device))
                    .toList(),
              ),
            ),
            // Scan results
          ],
        ),
      );
}
