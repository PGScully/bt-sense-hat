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
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder: (context) {
              // TODO: Why does this take forever to connect?
              result.device
                  .connect()
                  .then<void>((_) => debugPrint('Device.connect finished.'));
              return DeviceScreen(device: result.device);
            },
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          // TODO: Make it look good - see connected device tile.
          child: Text(result.toString()),
        ),
      );
}
