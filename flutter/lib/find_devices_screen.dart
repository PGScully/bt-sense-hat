import 'package:flutter/material.dart';

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Devices"),
        ),
        body: Container(
          color: Theme.of(context).backgroundColor,
        ),
      );
}
