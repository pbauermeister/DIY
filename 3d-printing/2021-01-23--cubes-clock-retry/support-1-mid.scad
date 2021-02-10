include <definitions.scad>
use <tower.scad>

difference() {
    union() {
        support_mid();
        cube_lower();
    }

    n = 0;
    if (n)
        rotate([0, 0, 45*n])
        translate([0, -250, 0]) cube(500);  // cross-cut
}


%servo1();
%servo2();
%servo3();