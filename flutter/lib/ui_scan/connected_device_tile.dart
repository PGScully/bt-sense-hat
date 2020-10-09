import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:bt_sense_hat/ui_device/device_screen.dart';

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
              return MaterialButton(
                onPressed: () => Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder: (context) => DeviceScreen(device: device)),
                ),
                color: Theme.of(context).buttonTheme.colorScheme.background,
                child: const Text('OPEN'),
              );
            }
            return Text(snapshot.data.toString());
          },
        ),
      );
}
