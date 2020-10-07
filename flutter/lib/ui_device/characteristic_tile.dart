import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:bt_sense_hat/bluetooth_constants.dart';

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
            StreamBuilder<List<int>>(
              stream: characteristic.value,
              initialData: const [],
              builder: (context, snapshot) {
                final data = Int8List.fromList(snapshot.data.toList());
                if (characteristic.uuid == temperatureCharacteristic) {
                  if (data.length == 2) {
                    final t =
                        ByteData.view(data.buffer).getInt16(0, Endian.little) /
                            100;
                    return Text('${t}C');
                  } else {
                    debugPrint('data = $data');
                    return Text('data: ${data.toString()}');
                  }
                } else if (characteristic.uuid == humidityCharacteristic) {
                  if (data.length == 2) {
                    final h =
                        ByteData.view(data.buffer).getUint16(0, Endian.little) /
                            100;
                    return Text('$h%');
                  } else {
                    debugPrint('data = $data');
                    return Text('data: ${data.toString()}');
                  }
                } else if (characteristic.uuid == pressureCharacteristic) {
                  if (data.length == 4) {
                    final p =
                        ByteData.view(data.buffer).getUint32(0, Endian.little) /
                            1000;
                    return Text('$p hPa');
                  } else {
                    debugPrint('data = $data');
                    return Text('data: ${data.toString()}');
                  }
                }
                return Text('Unknown characteristic: ${characteristic.uuid}');
              },
            ),
          ],
        ),
      );
}
