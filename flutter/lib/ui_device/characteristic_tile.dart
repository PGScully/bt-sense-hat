import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;

  const CharacteristicTile({
    Key key,
    this.characteristic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(characteristic.uuid.toString()),
          ],
        ),
      );
}
