import 'package:flutter_blue/flutter_blue.dart';

// Service constants
final environmentSensorService = Guid('0000181A-0000-1000-8000-00805F9B34FB');

// Characteristic constants
final temperatureCharacteristic = Guid('00002A6E-0000-1000-8000-00805F9B34FB');
final humidityCharacteristic = Guid('00002A6F-0000-1000-8000-00805F9B34FB');
final pressureCharacteristic = Guid('00002A6D-0000-1000-8000-00805F9B34FB');
