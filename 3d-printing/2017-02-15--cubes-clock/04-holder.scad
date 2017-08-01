//TODO : - Design 2nd plate: 90° snappers crown, cross attached to pinion to transmit to crown with lotta play, crown-cross: axial guidance, vertical locking, pionon to plate with 4x shafts to next module

include <definitions.scad>
include <lib/wheel-lib.scad>
include <gears.scad>
include <servo.scad>

use <02-primary-plate.scad>

HOLDER_HEIGHT_EXTRA = PLAY+TOLERANCE;
HOLDER_HEIGHT = PLATE_THICKNESS + HOLDER_HEIGHT_EXTRA + PLATE2_HEIGHT;
HOLDER_HOLES_RADIUS = 1;
HOLDER_HOLES_SPACING = 8;
HOLDER_HOLES_HOFFSET = 3;

echo("height =", HOLDER_HEIGHT);

module one_holder(height) {
    translate([0, 0, -PLATE2_HEIGHT])
    difference() {
        scale([1, 1, height])
        difference() {
            // pizza slice
            extra_angle = -10;
            rotate([0, 0, 45*3+extra_angle])
            intersection() {
                cylinder(r=HOLDER_RADIUS);
                cube(HOLDER_RADIUS);
                rotate([0, 0, 45-extra_angle]) cube(HOLDER_RADIUS);    
            }
            // remove servo
            make_servo_hull(z=SERVO_THICKNESS/2);
            // remove main plate
            cylinder(r=PLATE_DIAMETER/2+TOLERANCE);
            // file dlat
            translate([-PLATE_DIAMETER*1.5 - HOLDER_SPINE_THICKNESS, -PLATE_DIAMETER/2, 0])
            cube([PLATE_DIAMETER, PLATE_DIAMETER, PLATE2_HEIGHT+PLATE_THICKNESS]);
        }
        
        // holes
        n = ceil((PLATE_THICKNESS/2 + PLATE2_HEIGHT - HOLDER_HOLES_HOFFSET) / HOLDER_HOLES_SPACING);
        for (i=[0:n-1])
            for (j=[0:1])
                translate([0, -j*HOLDER_HOLES_SPACING, i * HOLDER_HOLES_SPACING + HOLDER_HOLES_HOFFSET])
                translate([0, -HOLDER_HOLES_SPACING/2, HOLDER_HOLES_SPACING/2])
                scale([HOLDER_RADIUS, 1, 1])
                rotate([0, -90, 0])
                cylinder(r=HOLDER_HOLES_RADIUS);     
    }

    // servo cover
    z = WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS + SERVO_THICKNESS/2;
    h = PLATE_THICKNESS - z -TOLERANCE;
    translate([SERVO_X_POSITION, 0, z+TOLERANCE])
    servo_cover(h);    
}

module holder() {
    n = 3;
    n = 1;
    for (i=[0:n-1])
        translate([0, 0, HOLDER_HEIGHT*i])
        one_holder(HOLDER_HEIGHT - (i==2||n==1 ? HOLDER_HEIGHT_EXTRA : 0));
}

rotate([0, -90, 0])
holder();