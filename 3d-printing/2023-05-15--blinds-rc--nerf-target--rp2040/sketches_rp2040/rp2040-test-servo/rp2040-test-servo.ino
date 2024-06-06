// Using Raspberry Pi Pico in Arduino:
//  https://randomnerdtutorials.com/programming-raspberry-pi-pico-w-arduino-ide/
//
// Using it:
//   Tools > Board > Raspberry Pi RP2040 Boards > Raspberry Pi Pico
//

#include <Servo.h>

#define SERVO_PIN 0

const int MAX_ANGLE         =  45;

const int SERVO_ZERO_OFFSET =  -6;
const int SERVO_STEP        =   1;
const int SERVO_STEP_DELAY  =  12;
const int SERVO_AFTER_DELAY = 100;

class MyServo {
  private:

    int pin;
    Servo servo;
  
    void attach() {
      this->servo.attach(this->pin, 400, 2600); // Minimum and maximum pulse width (in µs) to go from 0° to 180°.
    }
  
    void detach() {
      this->servo.detach();
    }
  
  public:
  
    MyServo(int pin) {
      this->pin = pin;
    }
  
    void sweep(int from, int to) {
      this->attach();
      if (from < to) {
        for (int a = from; a <= to; a += SERVO_STEP) {
          this->pos(a);
          delay(SERVO_STEP_DELAY);
        }
      }
      else {
        for (int a = from; a >= to; a -= SERVO_STEP) {
          this->pos(a);
          delay(SERVO_STEP_DELAY);
        }
      }
      this->pos(to);
      delay(SERVO_AFTER_DELAY);
      this->detach();
    }
  
    void pos(int angle) {
      this->servo.write(angle + 90 + SERVO_ZERO_OFFSET);
    }
};

MyServo servo(SERVO_PIN); // create servo object to control a servo

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

void blip(int duration) {
  digitalWrite(LED_BUILTIN, HIGH); 
  delay(duration);
  digitalWrite(LED_BUILTIN, LOW); 
}

////////// Here we go

void loop() {
  servo.pos(0);

  blip(1000);

  servo.sweep(0, MAX_ANGLE);
  blip(100);
  servo.sweep(MAX_ANGLE, 0);
  blip(1000);

  servo.sweep(0, -MAX_ANGLE);
  blip(100);
  servo.sweep(-MAX_ANGLE, 0);
}
