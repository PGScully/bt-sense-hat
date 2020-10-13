# Bluetooth UUIDS

This project uses the assigned Environmental Sensing numbers.

## Currently Implemented

Service: 
- 0x181A Environmental Sensing

Characteristics:
- 0x2A6E Temperature
- 0x2A6F Humidity
- 0x2A6D Pressure

In future, units and update intervals may be implemented.

## Standard UUIDs

From: https://specificationrefs.bluetooth.com/assigned-values/16-bit%20UUID%20Numbers%20Document.pdf

### Service

- GATT Service 0x181A Environmental Sensing

### Characteristics

- GATT Characteristic and Object Type 0x2A6E Temperature
- GATT Characteristic and Object Type 0x2A1C Temperature Measurement
- GATT Characteristic and Object Type 0x2A1D Temperature Type
- GATT Characteristic and Object Type 0x2A21 Measurement Interval
- GATT Characteristic and Object Type 0x2A1E Intermediate Temperature

- GATT Characteristic and Object Type 0x2A6F Humidity

- GATT Characteristic and Object Type 0x2A6D Pressure
- GATT Characteristic and Object Type 0x2AA3 Barometric Pressure Trend

### Units

- GATT Unit                           0x272F Celsius temperature (degree Celsius)
- GATT Unit                           0x27AC thermodynamic temperature (degree Fahrenheit)
- GATT Unit                           0x2705 thermodynamic temperature (kelvin)

- GATT Unit                           0x2724 pressure (pascal)
- GATT Unit                           0x2780 pressure (bar)
- GATT Unit                           0x2781 pressure (millimetre of mercury)
- GATT Unit                           0x27A5 pressure (pound-force per square inch)
