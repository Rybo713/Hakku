#!/bin/bash
sudo kextunload -b com.apple.iokit.BroadcomBluetooth20703USBTransport
sudo kextunload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport
sudo kextload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport
sudo kextload -b com.apple.iokit.BroadcomBluetooth20703USBTransport
