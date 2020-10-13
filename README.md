# Flutter Sense Hat Environment Display

Make the Sense Hat Temperature, Humidity and Pressure available vie Bluetooth, and display it in a Flutter app on a phone.

See Bluetooth.md for the Bluetooth GATT UUIDs currently implemented.

The Raspberry Pi Bluetooth server is forked from [Douglas6/cputemp](https://github.com/Douglas6/cputemp).  
My changes are to:

- Use temperature, humidity and pressure data from a Sense Hat,
- Use the official UUIDS for Environmental Sensing Service and Characteristics, and
- Encode the data as the expected list of bytes, instead of as strings.

## TODO

See the GitHub issues.

