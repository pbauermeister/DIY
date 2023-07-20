include <defs.scad>

/*
19
27
35
*/

HOLES_SPANS         = [19, 27, 35];
HOLES_DIAMETER      = 2;

HOLE_DIAMETER       = 4;
HOLE_HEAD_HOLLOWING = 8;

RING_THICKNESS      = 3;

$fn = 30;

module opposite_arm() {
    difference() {
        union() {
            hull() for (i=[-1, 1]) {
                translate([i*(SERVO_ARM_SPAN/2-SERVO_ARM_WIDTH/2), 0, 0])
                cylinder(d=SERVO_ARM_WIDTH, h=SERVO_ARM_THICKNESS);
            }
            cylinder(d=SERVO_ARM_WIDTH, h=RING_THICKNESS+SERVO_ARM_THICKNESS);
        }
        
        for (d=HOLES_SPANS) {
            for (i=[-1, 1]) {
                translate([d/2*i, 0, 0])
                cylinder(d=HOLES_DIAMETER, h=SERVO_ARM_THICKNESS*3, center=true);
            }
        }
        
        cylinder(d=HOLE_DIAMETER, h=(SERVO_ARM_THICKNESS+RING_THICKNESS)*3, center=true);

        dh = 1;
        hull() {
            translate([0, 0, dh])
            scale([dh, 1, .5])
            sphere(d=HOLE_HEAD_HOLLOWING);
            translate([0, 0, -ATOM])
            cylinder(d=HOLE_HEAD_HOLLOWING, h=ATOM);
        }
    }
}

module plate() {
    cube([48, BOARD_WIDTH - TOLERANCE, 4]);
}


opposite_arm();

translate([-24, BOARD_WIDTH, 0]) plate();