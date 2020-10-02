import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:bt_sense_hat/bluetooth_off_screen.dart';
import 'package:bt_sense_hat/find_devices_screen.dart';

void main() {
  runApp(BtSenseHatApp());
}

class BtSenseHatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Sense Hat Sensors',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (_, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(state: state);
          },
        ),
      );
}
