include <definitions.scad>
use <tower.scad>
use <servos_123.scad>

difference() {
    union() {
        support_mid();
        cube_lower();
    }

    n = 1;
    if ($preview)
        rotate([0, 0, 45*n])
        translate([0, -250, 0]) cube(500);  // cross-cut
}


%servos();
