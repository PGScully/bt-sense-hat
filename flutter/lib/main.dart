import 'package:flutter/material.dart';

void main() {
  runApp(BtSenseHatApp());
}

class BtSenseHatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Sense Hat Sensors',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Sense Hat Sensors"),
          ),
          body: const Text("Body"),
        ),
      );
}
