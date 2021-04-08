import 'package:flutter/material.dart';

import 'package:flutter_blue/flutter_blue.dart';

class BluetoothOffScreen extends StatelessWidget {
  final BluetoothState? state;

  const BluetoothOffScreen({
    Key? key,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Bluetooth Status"),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.bluetooth_disabled,
                size: 200.0,
                color: Colors.white54,
              ),
              Text(
                'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
                style: Theme.of(context).primaryTextTheme.subtitle1,
                // .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      );
}
