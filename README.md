# Flutter Sense Hat Environment Display

Make the Sense Hat Temperature, Humidity and Pressure available vie Bluetooth, and display it in a Flutter app on a phone.

See Bluetooth.md for the Bluetooth GATT UUIDs currently implemented.

The Raspberry Pi Bluetooth server is forked from [Douglas6/cputemp](https://github.com/Douglas6/cputemp), and largely unmodified.

## TODO

### Bluetooth / Raspberry Pi

Fixes:

 - Get sensor names from characteristic descriptors

Further coding and experimantation:

 - Put sensor values in the advertisement
 - Reimplement the server in Go or Rust

### Flutter

See README.md in the flutter directory
