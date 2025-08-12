#include <Servo.h>

const int P1 = 0;    // 35;
const int P2 = 58;   // 95;
const int P3 = 119;  // 151;
const int P4 = 176;
const int offset = 0;

#define SHAKE 4
#define DELAY 20
#define DELAY2 1000

void toggle_led() {
  static int state = -1;
  if (state == -1)
    pinMode(LED_BUILTIN, OUTPUT);
  state = !state;
  digitalWrite(LED_BUILTIN, state ? HIGH : LOW);
}

class GeekServo {
public:
  GeekServo(int pin, int offset = 0);
  void turn(int from, int to);
  void turn(int from, int to, int final_delay);

private:
  void write(int pos);
  Servo servo;
  int offset;
};

GeekServo::GeekServo(int pin, int offset = 0) {
  this->offset = offset;
  servo.attach(pin);

  const int final_delay = 5;
  const int p1 = P3;  // neutral position
  const int p2 = p1 + 5;

  // shake
  turn(p1, p2, final_delay);
  turn(p2, p1, final_delay);
  turn(p1, p2, final_delay);
  turn(p2, p1, final_delay);
}

void GeekServo::write(int pos) {
  toggle_led();
  servo.write(pos + offset);
}

void GeekServo::turn(int from, int to) {
  turn(from, to, DELAY2);
}

void GeekServo::turn(int from, int to, int final_delay) {
  from -= P1;
  to -= P1;
  from += offset;
  to += offset;

  if (from == to) {
  } else if (from < to) {
    for (int pos = from; pos <= to; pos++) {
      Serial.println("GeekServo::turn inc");
      write(pos);
      delay(DELAY);
    }
  } else {
    for (int pos = from; pos >= to; pos--) {
      Serial.println("GeekServo::turn dec");
      write(pos);
      delay(DELAY);
    }
  }

  // final shake
  for (int amp = SHAKE; amp; amp = amp / 2) {
    write(to + amp);
    delay(DELAY / 2 * amp);
    write(to - amp);
    delay(DELAY / 2 * amp);
  }
  write(to);

  delay(final_delay);  // wait for a while before next move
}

GeekServo *gs1;
GeekServo *gs2;

void setup() {
  for (int i = 0; i < 20; ++i) {
    toggle_led();
    delay(100);
  }
  gs1 = new GeekServo(9, 5);
  gs2 = new GeekServo(10, 1);
  delay(2000);  // give opportunity to start upload w/o servo consumption
}

void loop() {
  const int pause = 45;

  gs1->turn(P1, P2);
  gs2->turn(P4, P3);
  delay(pause);

  gs1->turn(P2, P3);
  gs2->turn(P3, P2);
  delay(pause);

  gs1->turn(P3, P4);
  gs2->turn(P2, P1);
  delay(pause);

  gs1->turn(P4, P3);
  gs2->turn(P1, P2);
  delay(pause);

  gs1->turn(P3, P2);
  gs2->turn(P2, P3);
  delay(pause);

  gs1->turn(P2, P1);
  gs2->turn(P3, P4);
  delay(pause);
}
