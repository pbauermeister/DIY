/* Experimental sketch that detects hit on the target.
 *
 * Polls pin 2 which must be connected to the ground via the target
 * switch. Upon impact, blinks 10 times.
 *
 * TODO: instead of polling the pin, connect an interrupt to it, which
 * would set a flag; the flag would be read by loop periodically at a
 * lower rate.
 */

#define BUTTON_PIN 2

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
}

void loop() {
  int buttonState = digitalRead(BUTTON_PIN);
  if (buttonState == HIGH) {
    // turn LED on:
    digitalWrite(LED_BUILTIN, HIGH);
  } else {
    // blink and stay off:
    blink();
  }
  return;
}

void blink() {
  for (int i=0; i<10; ++i) {
    digitalWrite(LED_BUILTIN, HIGH);
    delay(100);
    digitalWrite(LED_BUILTIN, LOW);
    delay(100);
  }
}
