/* 3 pads for any fidget of height 4.5 mm. */

use <lib.scad>

GAP               = 1;
BASE              = 1.25;
SHIFT             = 2;
HEIGHT            = 4.5;
DIAMETER          = 150;
RADIUS_MAX        = DIAMETER / 2;
RADIUS_MIN        = 1;
FILLED_CENTER     = true;
$fn               = 200;

color("blue") {
    d = 20;
    h = HEIGHT * 2;
    for (i = [0:2]) {
        rotate([ 0, 0, i * 120 ])
        translate([ 0, d * .7, 0 ])

        intersection() {
            translate([ 0, -RADIUS_MAX, 0 ])
            difference() {
                // cylinder
                rotate([ 0, 0, 90 ])
                translate([ RADIUS_MAX, 0, 0 ])
                cylinder(d = d, h = h);

                // fidget envelope
                hull() translate([ 0, 0, -0.01 ])
                fidget(RADIUS_MIN, RADIUS_MAX, BASE, HEIGHT, SHIFT, GAP, FILLED_CENTER, true);
            }

            // pad envelope
            resize([ d, d, h ]) sphere(d = 1);
        }
    }
}
