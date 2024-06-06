// Using Raspberry Pi Pico in Arduino:
//  https://randomnerdtutorials.com/programming-raspberry-pi-pico-w-arduino-ide/
//
// Using it:
//   Tools > Board > Raspberry Pi RP2040 Boards > Raspberry Pi Pico
//

// LED_BUILTIN in connected to pin 25 of the RP2040 chip.
// It controls the on board LED, at the top-left corner.

int led = LED_BUILTIN;         // the PWM pin the LED is attached to
int brightness = 120;  // how bright the LED is
int fadeAmount = 1;  // how many points to fade the LED by

void setup() {
  pinMode(led, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  analogWrite(led, min(254, max(brightness, 10))/1 +1);

  brightness = brightness + fadeAmount;

  if (brightness <= 0 || brightness >= 255+30) {
    fadeAmount = -fadeAmount;
    delay(1000);
  }
  delay(4);
}
