include <constants.scad>

$fn=100;

module washer() {
    difference() {
        cylinder(d=LID_BEZEL_L0_PILLAR_D, h=2.5);
        cylinder(d=3.5, h=2.5*3, center=true);
    }
}

for (i=[0:3]) translate([i*15, 0, 0]) washer();