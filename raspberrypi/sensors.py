#!/usr/bin/python3

"""Copyright (c) 2019, Douglas Otwell

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

import dbus

from advertisement import Advertisement
from service import Application, Service, Characteristic, Descriptor
from sense_hat import SenseHat

GATT_CHRC_IFACE = "org.bluez.GattCharacteristic1"
NOTIFY_TIMEOUT = 5000


class SensorsAdvertisement(Advertisement):
    def __init__(self, index):
        Advertisement.__init__(self, index, "peripheral")
        self.add_local_name("Sense Hat Environment")
        self.include_tx_power = True


class SensorsService(Service):
    SENSORS_SERVICE_UUID = "181A"

    def __init__(self, index):

        Service.__init__(self, index, self.SENSORS_SERVICE_UUID, True)
        self.add_characteristic(TemperatureCharacteristic(self))
        self.add_characteristic(HumidityCharacteristic(self))
        self.add_characteristic(PressureCharacteristic(self))


class TemperatureCharacteristic(Characteristic):
    TEMPERATURE_CHARACTERISTIC_UUID = "2A6E"

    def __init__(self, service):
        self.notifying = False

        Characteristic.__init__(
            self, self.TEMPERATURE_CHARACTERISTIC_UUID,
            ["notify", "read"], service)
        self.add_descriptor(TemperatureDescriptor(self))

    def get_temperature(self):
        value = []

        temperature = sense.temperature
        # ! Multiply bo 100 for two decimal digits of accuracy.
        for byte in int(temperature * 100).to_bytes(2, byteorder='little', signed=True):
            value.append(dbus.Byte(byte))

        return value

    def set_temperature_callback(self):
        if self.notifying:
            value = self.get_temperature()
            self.PropertiesChanged(GATT_CHRC_IFACE, {"Value": value}, [])

        return self.notifying

    def StartNotify(self):
        if self.notifying:
            return

        self.notifying = True

        value = self.get_temperature()
        self.PropertiesChanged(GATT_CHRC_IFACE, {"Value": value}, [])
        self.add_timeout(NOTIFY_TIMEOUT, self.set_temperature_callback)

    def StopNotify(self):
        self.notifying = False

    def ReadValue(self, options):
        value = self.get_temperature()

        return value


class TemperatureDescriptor(Descriptor):
    TEMPERATURE_DESCRIPTOR_UUID = "2901"
    TEMPERATURE_DESCRIPTOR_VALUE = "Temperature"

    def __init__(self, characteristic):
        Descriptor.__init__(
            self, self.TEMPERATURE_DESCRIPTOR_UUID,
            ["read"],
            characteristic)

    def ReadValue(self, options):
        value = []
        desc = self.TEMPERATURE_DESCRIPTOR_VALUE

        for c in desc:
            value.append(dbus.Byte(c.encode()))

        return value


class HumidityCharacteristic(Characteristic):
    HUMIDITY_CHARACTERISTCI_UUID = "2A6F"

    def __init__(self, service):
        self.notifying = False

        Characteristic.__init__(
            self, self.HUMIDITY_CHARACTERISTCI_UUID,
            ["notify", "read"], service)
        self.add_descriptor(HumidityDescriptor(self))

    def get_humidity(self):
        value = []

        humidity = sense.humidity
        # ! Multiply by 100 for two decimal digits of accuracy.
        for byte in int(humidity * 100).to_bytes(2, byteorder='little', signed=False):
            value.append(dbus.Byte(byte))

        return value

    def set_humidity_callback(self):
        if self.notifying:
            value = self.get_humidity()
            self.PropertiesChanged(GATT_CHRC_IFACE, {"Value": value}, [])

        return self.notifying

    def StartNotify(self):
        if self.notifying:
            return

        self.notifying = True

        value = self.get_humidity()
        self.PropertiesChanged(GATT_CHRC_IFACE, {"Value": value}, [])
        self.add_timeout(NOTIFY_TIMEOUT, self.set_humidity_callback)

    def StopNotify(self):
        self.notifying = False

    def ReadValue(self, options):
        value = self.get_humidity()

        return value


class HumidityDescriptor(Descriptor):
    HUMIDITY_DESCRIPTOR_UUID = "2901"
    HUMIDITY_DESCRIPTOR_VALUE = "Humidity"

    def __init__(self, characteristic):
        Descriptor.__init__(
            self, self.HUMIDITY_DESCRIPTOR_UUID,
            ["read"],
            characteristic)

    def ReadValue(self, options):
        value = []
        desc = self.HUMIDITY_DESCRIPTOR_VALUE

        for c in desc:
            value.append(dbus.Byte(c.encode()))

        return value


class PressureCharacteristic(Characteristic):
    PRESSURE_CHARACTERISTCI_UUID = "2A6D"

    def __init__(self, service):
        self.notifying = False

        Characteristic.__init__(
            self, self.PRESSURE_CHARACTERISTCI_UUID,
            ["notify", "read"], service)
        self.add_descriptor(PressureDescriptor(self))

    def get_pressure(self):
        value = []

        pressure = sense.pressure
        # ! Multiply by 10 to for one decimal digit of accuracy.
        # ! Multiply by 100 to convert from hPa to Pa.
        for byte in int(pressure * 10 * 100).to_bytes(4, byteorder='little', signed=False):
            value.append(dbus.Byte(byte))

        return value

    def set_pressure_callback(self):
        if self.notifying:
            value = self.get_pressure()
            self.PropertiesChanged(GATT_CHRC_IFACE, {"Value": value}, [])

        return self.notifying

    def StartNotify(self):
        if self.notifying:
            return

        self.notifying = True

        value = self.get_pressure()
        self.PropertiesChanged(GATT_CHRC_IFACE, {"Value": value}, [])
        self.add_timeout(NOTIFY_TIMEOUT, self.set_pressure_callback)

    def StopNotify(self):
        self.notifying = False

    def ReadValue(self, options):
        value = self.get_pressure()

        return value


class PressureDescriptor(Descriptor):
    PRESSURE_DESCRIPTOR_UUID = "2901"
    PRESSURE_DESCRIPTOR_VALUE = "Pressure"

    def __init__(self, characteristic):
        Descriptor.__init__(
            self, self.PRESSURE_DESCRIPTOR_UUID,
            ["read"],
            characteristic)

    def ReadValue(self, options):
        value = []
        desc = self.PRESSURE_DESCRIPTOR_VALUE

        for c in desc:
            value.append(dbus.Byte(c.encode()))

        return value


sense = SenseHat()

app = Application()
app.add_service(SensorsService(0))
app.register()

adv = SensorsAdvertisement(0)
adv.register()

try:
    app.run()
except KeyboardInterrupt:
    app.quit()
