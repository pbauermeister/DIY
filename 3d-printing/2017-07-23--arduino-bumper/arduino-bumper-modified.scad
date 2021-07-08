// Based on https://www.thingiverse.com/thing:26237
// adding grips

import("Arduino_Bumper_0006.stl");

module grip(x, y, d=5) {
  translate([x, y, 4.6])
  hull() {
    translate([0, -d/2, 0])
    sphere(r=0.5, $fn=16);
    translate([0, d/2, 0])
    sphere(r=0.5, $fn=16);
  }
}

color("red") {
    grip(34.45, -5.2, 30);
    grip(-34.45, -4.45, 15);
}
