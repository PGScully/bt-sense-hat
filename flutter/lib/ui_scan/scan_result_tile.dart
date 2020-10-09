import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:bt_sense_hat/ui_device/device_screen.dart';

class ScanResultTile extends StatelessWidget {
  final ScanResult result;

  const ScanResultTile({
    Key key,
    this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(result.device.name),
        subtitle: Text(result.device.id.toString()),
        trailing: RaisedButton(
          onPressed: () {
            debugPrint('Device.connect started.');
            result.device
                .connect()
                .then<void>((_) => debugPrint('Device.connect finished.'));
            Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                  builder: (context) => DeviceScreen(device: result.device)),
            );
          },
          child: const Text('CONNECT'),
        ),
      );
}
