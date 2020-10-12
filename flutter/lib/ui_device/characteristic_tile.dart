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
          child: Card(
            color: colorFromGuid(guid: characteristic.uuid),
            child: ListTile(
              // TODO: Use a FutureBuilder and filter on descriptor UUID == 2901
              // FutureBuilder<List<int>>(future: bluetoothLock.synchronized(
              //  () => characteristic.descriptors.first.read()),
              //  initialData: const []
              // if (snapshot.data == null || snapshot.data.isEmpty) {
              // return const Text('Loading...');} else {
              //  String.fromCharCodes(snapshot.data),
              title: Text(
                sensorNameFromGuid(guid: characteristic.uuid),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.black87),
              ),
              subtitle: StreamBuilder<List<int>>(
                stream: characteristic.value,
                // TODO: Can I replace this with a fetch of the current reading?
                // ? or characteristic.lastValue ?
                // initialData: const [],
                initialData: characteristic.lastValue,
                builder: (context, snapshot) {
                  if (characteristic.uuid == temperatureCharacteristic) {
                    final t = temperatureFromData(snapshot.data);
                    return Text(
                      t.toStringAsFixed(1),
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.black87),
                      textAlign: TextAlign.right,
                    );
                  } else if (characteristic.uuid == humidityCharacteristic) {
                    final h = humidityFromData(snapshot.data);
                    return Text(
                      h.toStringAsFixed(1),
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.black87),
                      textAlign: TextAlign.right,
                    );
                  } else if (characteristic.uuid == pressureCharacteristic) {
                    final p = pressureFromData(snapshot.data);
                    return Text(
                      p.toStringAsFixed(1),
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: Colors.black87),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.black87),
                    textAlign: TextAlign.left,
                  );
                } else if (characteristic.uuid == humidityCharacteristic) {
                  return Text(
                    '%',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.black87),
                    textAlign: TextAlign.left,
                  );
                } else if (characteristic.uuid == pressureCharacteristic) {
                  return Text(
                    'hPa',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.black87),
                    textAlign: TextAlign.left,
                  );
                } else {
                  return const Text('?');
                }
              }),
            ),
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

  Color colorFromGuid({Guid guid}) {
    if (guid == temperatureCharacteristic) {
      return Colors.red[400];
    } else if (guid == humidityCharacteristic) {
      return Colors.yellow[400];
    } else if (guid == pressureCharacteristic) {
      return Colors.blue[400];
    }
    return Colors.grey[400];
  }

  String sensorNameFromGuid({Guid guid}) {
    if (guid == temperatureCharacteristic) {
      return 'Temperature';
    } else if (guid == humidityCharacteristic) {
      return 'Humidity';
    } else if (guid == pressureCharacteristic) {
      return 'Pressure';
    }
    return 'Unknown';
  }
}
