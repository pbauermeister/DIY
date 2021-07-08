/* Sweep
 by BARRAGAN <http://barraganstudio.com>
 This example code is in the public domain.

 modified 8 Nov 2013
 by Scott Fitzgerald
 http://www.arduino.cc/en/Tutorial/Sweep
*/

#include <Servo.h>

Servo myservo;  // create servo object to control a servo
// twelve servo objects can be created on most boards


const int P1 =  0; //35;
const int P2 = 58; //95;
const int P3 = 119; //151;
const int P4 = 176;

#define SHAKE  8
#define DELAY  20
#define DELAY2 1000

void turn(int from, int to) {
  from -= P1;
  to -= P1;
  
  if (from == to) {
  }
  if (from < to) {
    for (int pos=from; pos<=to; pos++) {
      myservo.write(pos);
      delay(DELAY);
    }
  }
  else {
    for (int pos=from; pos>=to; pos--) {
      myservo.write(pos);
      delay(DELAY);
    }
  }

  // final shake
  for (int amp=SHAKE; amp; amp=amp/2) {
    myservo.write(to + amp);
    delay(DELAY/2*amp);
    myservo.write(to - amp);
    delay(DELAY/2*amp);
  }
  myservo.write(to);
  
  delay(DELAY2);
}

void setup() {
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object
  myservo.write(0);
  delay(1000);
  turn(0, 10);
  turn(10, P1);
  delay(1000); // give opportunity to start upload w/o servo consumption
}


void loop() {
  turn(P1, P2);
  turn(P2, P3);
  turn(P3, P4);

  turn(P4, P3);
  turn(P3, P2);
  turn(P2, P1);  
  return;
  turn(P1, P1);
  turn(P1, P2);
  turn(P2, P3);
//  turn(P3, P4);
  
//  turn(P4, P3);
  turn(P3, P2);
  turn(P2, P1);
}
