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
  Widget build(BuildContext context) => Expanded(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            // title: FutureBuilder<List<int>>(
            //     future: characteristic.descriptors.first.read(),
            //     initialData: const [],
            //     builder: (context, snapshot) {
            //       if (snapshot.data == null || snapshot.data.isEmpty) {
            //         return const Text('Loading...');
            //       } else {
            //         return Text(
            //             ByteData.view(Int8List.fromList(snapshot.data).buffer)
            //                 .toString());
            //       }
            //     }),
            title: Text(characteristic.uuid.toString()),
            subtitle: StreamBuilder<List<int>>(
              stream: characteristic.value,
              // TODO: Can I replace this with a fetch of the current reading?
              // ? characteristic.lastValue ?
              initialData: const [],
              // initialData: characteristic.lastValue,
              builder: (context, snapshot) {
                if (characteristic.uuid == temperatureCharacteristic) {
                  final t = temperatureFromData(snapshot.data);
                  return Text(
                    t.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.right,
                  );
                } else if (characteristic.uuid == humidityCharacteristic) {
                  final h = humidityFromData(snapshot.data);
                  return Text(
                    h.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.right,
                  );
                } else if (characteristic.uuid == pressureCharacteristic) {
                  final p = pressureFromData(snapshot.data);
                  return Text(
                    p.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.right,
                  );
                }
                return Text('Unknown characteristic: ${characteristic.uuid}');
              },
            ),
            trailing: Builder(builder: (context) {
              if (characteristic.uuid == temperatureCharacteristic) {
                return Text(
                  '℃',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                );
              } else if (characteristic.uuid == humidityCharacteristic) {
                return Text(
                  '%',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                );
              } else if (characteristic.uuid == pressureCharacteristic) {
                return Text(
                  'hPa',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                );
              } else {
                return const Text('?');
              }
            }),
          ),
        ),
      );

  double temperatureFromData(List<int> data) {
    if (data.isEmpty || data.length != 2) {
      debugPrint('Temperature data.length = ${data.length}, should be 2.');
      return -999.0;
    } else {
      return ByteData.view(Int8List.fromList(data).buffer)
              .getInt16(0, Endian.little) /
          100.0;
    }
  }

  double humidityFromData(List<int> data) {
    if (data.isEmpty || data.length != 2) {
      debugPrint('Humidity data.length = ${data.length}, should be 2.');
      return -999.0;
    } else {
      return ByteData.view(Int8List.fromList(data).buffer)
              .getUint16(0, Endian.little) /
          100.0;
    }
  }

  double pressureFromData(List<int> data) {
    if (data.isEmpty || data.length != 4) {
      debugPrint('Pressure data.length = ${data.length}, should be 4.');
      return -999.0;
    } else {
      return ByteData.view(Int8List.fromList(data).buffer)
              .getUint32(0, Endian.little) /
          1000.0;
    }
  }
}
