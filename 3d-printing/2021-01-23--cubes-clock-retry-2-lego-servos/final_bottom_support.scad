include <definitions.scad>
use <tower.scad>
use <servos_123.scad>

difference() {
    support_bottom();

    if (1)
    translate([0, 0, -CUBE_RAISE]) 
    adhesion();
}

%servo1();