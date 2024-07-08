include <defs.scad>


SERVO_ARM_THICKNESS  =  3+2      + 2;

HOLES_SPANS         = [19, 27, 35];
HOLES_DIAMETER      = 2;

HOLE_DIAMETER       = 4;
HOLE_HEAD_HOLLOWING = 8;

RING_THICKNESS      = 3-2        + .5;

FRAME_BAR_DIAMETER  = 3.2        + .2; 
FRAME_MARGIN        = 3.5;

SHAFT_DIAMETER      = 6;
AXIS_H_CONTACT      = 3.5;
AXIS_H              = 1.5;

$fn = 30;

module arm_0(extra_h=0, has_shaft=false) {
    thickness = SERVO_ARM_THICKNESS + extra_h;
    difference() {
        union() {
            hull() {
                    for (i=[-1, 1]) {
                    translate([i*(SERVO_ARM_SPAN/2-SERVO_ARM_WIDTH/2), 0, 0])
                    cylinder(d=SERVO_ARM_WIDTH, h=thickness);
                }
                bar_fixture(w=ATOM, extra_h=extra_h);
            }
            cylinder(d=SERVO_ARM_WIDTH, h=RING_THICKNESS+thickness);
        }
        
        // arm holes
        for (d=HOLES_SPANS) {
            for (i=[-1, 1]) {
                translate([d/2*i, 0, 0])
                cylinder(d=HOLES_DIAMETER, h=thickness*3, center=true);
            }
        }
        
        if (has_shaft) {
            l = SHAFT_DIAMETER / sqrt(2);
            h = SERVO_ARM_THICKNESS + RING_THICKNESS + extra_h - AXIS_H_CONTACT + ATOM;
            translate([0, 0, h])
            for (a=[0:90/6:90]) {
                rotate([0, 0, a])
                translate([-l/2, -l/2, 0])
                cube([l, l, AXIS_H_CONTACT]);
            }
        }

        // central hole
        cylinder(d=HOLE_DIAMETER, h=(thickness+RING_THICKNESS)*3, center=true);

        // screw chamfer
        /*
        dh = 1;
        if (0) hull() {
            translate([0, 0, dh])
            scale([dh, 1, .5])
            sphere(d=HOLE_HEAD_HOLLOWING);
            translate([0, 0, -ATOM])
            cylinder(d=HOLE_HEAD_HOLLOWING, h=ATOM);
        }
        */
        h = SERVO_ARM_THICKNESS + RING_THICKNESS + extra_h - AXIS_H_CONTACT - (has_shaft ? AXIS_H : 0);
        translate([0, 0, -ATOM])
        cylinder(d=HOLE_HEAD_HOLLOWING, h=h);
        
    }
}

module bar_fixture(w=FRAME_BAR_DIAMETER + FRAME_MARGIN, extra_h=0) {
    l = SERVO_ARM_SPAN;

    difference() {
        translate([0, w/2+SERVO_ARM_WIDTH/2, SERVO_ARM_THICKNESS/2+extra_h/2])
        cube([l, w, SERVO_ARM_THICKNESS+extra_h], center=true);
        
        hull() {
            translate([0, SERVO_ARM_WIDTH/2+FRAME_BAR_DIAMETER/2, SERVO_ARM_THICKNESS-FRAME_BAR_DIAMETER/2-1])
            rotate([0, 90, 0])
            cylinder(d=FRAME_BAR_DIAMETER, h=l*2, center=true);

            if (extra_h) {
            translate([0, SERVO_ARM_WIDTH/2+FRAME_BAR_DIAMETER/2, SERVO_ARM_THICKNESS-FRAME_BAR_DIAMETER/2+extra_h])
            rotate([0, 90, 0])
            cylinder(d=FRAME_BAR_DIAMETER, h=l*2, center=true);
            }

            translate([0, SERVO_ARM_WIDTH/2+FRAME_BAR_DIAMETER/2, SERVO_ARM_THICKNESS+extra_h])
            rotate([0, 90, 0])
            cylinder(d=FRAME_BAR_DIAMETER-.5, h=l*2, center=true);
        }
    }
}

module passive_arm() {
    arm_0(has_shaft=false);
    bar_fixture();
}

module servo_arm() {
    arm_0(extra_h=FRAME_BAR_DIAMETER, has_shaft=true);
    bar_fixture(extra_h=FRAME_BAR_DIAMETER);
}


module cut() {
    intersection() {
        children();
        cube(1000);
    }
}

rotate([0, 90, 0])
//cut()
passive_arm();

translate([0, -20, 0])
//cut()
rotate([0, 90, 0])
servo_arm();