include <definitions.scad>
use <tower.scad>

difference() {
    support_bottom();

    if (1)
    translate([0, 0, -CUBE_RAISE]) 
    adhesion();
}

%servo1();