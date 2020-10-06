import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceScreen extends StatelessWidget {
  final BluetoothDevice device;

  const DeviceScreen({
    Key key,
    this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sense Hat'),
        ),
        body: StreamBuilder<BluetoothDeviceState>(
          stream: device.state,
          initialData: BluetoothDeviceState.connecting,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case BluetoothDeviceState.disconnected:
                {
                  return const Center(child: Text('Disconnected'));
                }
              case BluetoothDeviceState.connecting:
                {
                  return const Center(child: Text('Connecting'));
                }
              case BluetoothDeviceState.connected:
                {
                  device.discoverServices();
                  return DeviceReadings(device: device);
                }
              case BluetoothDeviceState.disconnecting:
                {
                  return const Center(child: Text('Disconnecting'));
                }
            }
            return const Text('Unknown State!');
          },
        ),
      );
}

class DeviceReadings extends StatelessWidget {
  final BluetoothDevice device;

  const DeviceReadings({
    Key key,
    this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<BluetoothService>>(
        stream: device.services,
        initialData: const [],
        builder: (_, snapshot) => SingleChildScrollView(
          child: Column(
            children: snapshot.data
                .map((s) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(s.toString()),
                    ))
                .toList(),
          ),
        ),
      );
}
