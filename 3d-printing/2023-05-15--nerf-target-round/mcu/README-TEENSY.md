# Teensy 3.2

## Adding Teensy to Arduino

1. File > Preferences > Additional Boards Manager URLs:
     add https://www.pjrc.com/teensy/package_teensy_index.json

2. Tools > Boards Manager
     - Search for Teensy, locate Teensy by Paul Stoffregen, Install

## Add USB support

```
sudo -s
cd /etc/udev/rules.d/
wget https://www.pjrc.com/teensy/00-teensy.rules
```

Re-plug your Teensy. Syslog should show lines like:
```
usb 1-1: new full-speed USB device number 19 using xhci_hcd
usb 1-1: New USB device found, idVendor=16c0, idProduct=0483, bcdDevice= 2.75
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: USB Serial
usb 1-1: Manufacturer: Teensyduino
usb 1-1: SerialNumber: 1302700
cdc_acm 1-1:1.0: ttyACM3: USB ACM device
```

## Upload sketch

Have a sketch, for instance:
```
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  for (int i=0; i<3; ++i) {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(100);
    digitalWrite(LED_BUILTIN, LOW);
    delay(100);
  }
  delay(800);
}
```

1. Tools > Board > Teensyduino > Teensy 3.2/3.1
     - or any desired Teensy version

2. Tools > Port > Teensy Ports > /dev/ttyACM3 Serial (Teensy 3.2)
      - Do -not- select *Serial ports* group, but *Teensy Ports* group!
      - or any ttyACM*n* shown

3. If the Teensy is in HID mode or similar (otherwise you can skip
   this step), press the button on the Teensy (top side, edge opposite
   to USB) to make it ready to be flashed over USB.

4. Click Upload

## Pinout

See https://www.pjrc.com/teensy/card7a_rev3_web.pdf.
