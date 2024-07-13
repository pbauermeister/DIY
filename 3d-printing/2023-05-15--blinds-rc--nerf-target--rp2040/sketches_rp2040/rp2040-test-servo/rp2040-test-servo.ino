// Using Raspberry Pi Pico in Arduino:
//  https://randomnerdtutorials.com/programming-raspberry-pi-pico-w-arduino-ide/
//
// Using it:
//   Tools > Board > Raspberry Pi RP2040 Boards > Raspberry Pi Pico
//

#include <Servo.h>

#define SERVO_PIN 0

// Tuning to compensate mount angle of servo arm on shaft:
const int SERVO_ZERO_OFFSET = -5;  // from servo topview: pos->cw, neg->ccw

// Max angle (either side), not counting overshoot
const int MAX_ANGLE = 12;

// Resolution
const int SERVO_STEP_ANGLE = 1;

// Overshoot
const int OVERSHOOT_DIVIDER = 2;  // the bigger, the less overshoot

// Travel timings
const int SERVO_STEP_DELAY = 12;
const int SERVO_REST_DELAY = 100;

// Minimum and maximum pulse width (in µs) to go from 0° to 180°:
const int SERVO_PULSE_WIDTH_MIN = 400;
const int SERVO_PULSE_WIDTH_MAX = 2600;

// Switching positions (either side)
const int ANGLE = (MAX_ANGLE * 2) / 3;

////////////////////////////////////////////////////////////////////////////////
// Built-in LED

bool led_on = false;

void led_toggle() {
  led_on = !led_on;
  digitalWrite(LED_BUILTIN, led_on ? HIGH : LOW);
}

void blip(int duration) {
  led_toggle();
  delay(duration);
  led_toggle();
}

////////////////////////////////////////////////////////////////////////////////
// Servo

class MyServo {
 private:
  int pin;
  Servo servo;

  void attach() {
    servo.attach(pin, SERVO_PULSE_WIDTH_MIN, SERVO_PULSE_WIDTH_MAX);
  }

  void detach() { servo.detach(); }

 public:
  MyServo(int pin) { this->pin = pin; }

  void sweep(int from, int to, bool tach) {
    led_toggle;
    if (tach) attach();
    if (from < to) {
      for (int a = from; a <= to; a += SERVO_STEP_ANGLE) {
        set_pos(a);
        delay(SERVO_STEP_DELAY);
      }
    } else {
      for (int a = from; a >= to; a -= SERVO_STEP_ANGLE) {
        set_pos(a);
        delay(SERVO_STEP_DELAY);
      }
    }
    set_pos(to);
    delay(SERVO_REST_DELAY);
    if (tach) detach();

    // led_on = !led_on;
    // digitalWrite(LED_BUILTIN, led_on ? HIGH : LOW);
  }

  void set_pos(int angle) { servo.write(angle + 90 + SERVO_ZERO_OFFSET); }

  void go_to(int from, int to, bool oscillate) {
    if (!oscillate) {
      sweep(from, to, true);
    }

    else {
      attach();
      do {
        int overshoot = (to - from) / OVERSHOOT_DIVIDER;
        int dest = to + overshoot;
        sweep(from, dest, false);
        from = dest;
      } while (from != to);
      detach();
    }
  }
};
////////////////////////////////////////////////////////////////////////////////
// Application

MyServo servo(SERVO_PIN);  // create servo object to control a servo

void setup() { pinMode(LED_BUILTIN, OUTPUT); }

void loop() {
  servo.set_pos(0);

  blip(1200);

  servo.go_to(0, ANGLE, false);
  blip(300);
  servo.go_to(ANGLE, 0, true);
  blip(1200);

  servo.go_to(0, -ANGLE, false);
  blip(300);
  servo.go_to(-ANGLE, 0, true);
}
