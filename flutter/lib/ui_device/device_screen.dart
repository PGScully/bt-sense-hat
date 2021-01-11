import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:bt_sense_hat/bluetooth_constants.dart';
import 'package:bt_sense_hat/device_constants.dart';
import 'package:bt_sense_hat/ui_device/characteristic_tile.dart';

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
        backgroundColor: Theme.of(context).backgroundColor,
        body: StreamBuilder<BluetoothDeviceState>(
          stream: device.state,
          initialData: BluetoothDeviceState.connecting,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case BluetoothDeviceState.disconnected:
                {
                  // TODO: Why does this display instead of Connecting?
                  return const Center(child: Text('Disconnected'));
                }
              case BluetoothDeviceState.connecting:
                {
                  // TODO: Loading indicator/spinner/...
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

  Future<void> startNotifying(BluetoothCharacteristic c) async {
    debugPrint('startNotifying: uuid = ${c.uuid}, notifying = ${c.isNotifying}');
    if (!c.isNotifying) {
      final val = await bluetoothLock.synchronized(
        () => c.setNotifyValue(true).then<bool>((bool v) {
          debugPrint('Notify on ${c.uuid} set to $v');
          return v;
        }).catchError((dynamic err) {
          debugPrint('Error setting notify on ${c.uuid}');
          debugPrint('err = $err');
          return false;
        }),
      );
      debugPrint('val = $val');
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<BluetoothService>>(
        stream: device.services,
        initialData: const [],
        builder: (_, snapshot) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...snapshot.data
                .where((s) => s.uuid == environmentSensorService)
                .map((s) => s.characteristics.map((c) {
                      startNotifying(c);
                      return CharacteristicTile(characteristic: c);
                    }).toList())
                .expand((element) => element)
                .toList(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        device.disconnect();
                        Navigator.of(context).pop();
                      },
                      color: Theme.of(context).buttonTheme.colorScheme.primary,
                      child: const Text('DISCONNECT'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
