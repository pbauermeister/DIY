include <definitions.scad>
use <tower.scad>
use <servos_123.scad>
use <servo_horn_adjuster.scad>


difference() {
    support_bottom();

    if (0)
    translate([0, 0, -CUBE_RAISE]) 
    adhesion();
}

%servos();
