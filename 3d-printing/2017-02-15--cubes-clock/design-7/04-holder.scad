//TODO: slits for zip ties

include <definitions.scad>
include <lib/wheel-lib.scad>
include <gears.scad>
include <servo.scad>
use <02-primary-plate.scad>

HOLDER_HEIGHT_EXTRA = PLAY*4; // <== ADJUST
HOLDER_HEIGHT = PLATE_THICKNESS + PLATE2_HEIGHT + HOLDER_HEIGHT_EXTRA;

echo("height =", HOLDER_HEIGHT);

module one_holder_spine_cover(height, is_last_holder) {
    translate([0, 0, -PLATE2_HEIGHT])
    scale([1, 1, height])
    difference() {
        // pizza slice            
//        angle_trimming_1 = 11.6 + 2+2;
//        angle_trimming_2 = 4 -10;
        angle_trimming_1 = 45/2  +6;
        angle_trimming_2 = -45/2 +6;

        rotate([0, 0, 45*3-angle_trimming_1])
        intersection() {
            cylinder(r=HOLDER_RADIUS);
            cube(HOLDER_RADIUS);
            rotate([0, 0, 45+angle_trimming_1+angle_trimming_2]) cube(HOLDER_RADIUS);    
        }
        // remove main plate
        cylinder(r=PLATE_DIAMETER/2+TOLERANCE);
        // remove servo
        make_servo_hull(z=0);
    }

    // servo cover
    h = servo_cover_height();
    z = height - h*2 + PLAY + TOLERANCE;
    intersection() {
        translate([SERVO_X_POSITION, 0, z])
        difference() {
            union() {
                servo_cover(h);
                servo_cover_clip(h);
            }
            servo_cover_screw_holes(false);
        }
        cylinder(r=HOLDER_RADIUS, h=PLATE_THICKNESS*1.5);
    }
}

module one_holder(height, is_last_holder) {
    difference() {
        // holder
        one_holder_spine_cover(height, is_last_holder);
        
        // Hole for servo cables
        make_servo_cable_clearance();

        // file flat
        translate([0, 0, -PLATE2_HEIGHT])
        scale([1, 1, height])
        translate([-PLATE_DIAMETER*1.5 - HOLDER_SPINE_THICKNESS, -PLATE_DIAMETER/2, 0])
        cube([PLATE_DIAMETER, PLATE_DIAMETER, PLATE2_HEIGHT+PLATE_THICKNESS]);
    }

    %translate([0, 0, HOLDER_HEIGHT_EXTRA])
    make_servo_hull();    
}

module make_servo_hull(with_clearances=false,
                       z=WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS) {
    translate([SERVO_X_POSITION, 0, z])
    servo_hull(with_clearances);
}

module make_servo_cable_clearance(z=WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS) {
    translate([SERVO_X_POSITION, 0, z+HOLDER_HEIGHT_EXTRA])
    servo_cable_clearance(4);
}

module holder() {
    n = 3;
//    n = 1;
    translate([0, 0, -HOLDER_HEIGHT_EXTRA])
    for (i=[0:n-1])
        translate([0, 0, HOLDER_HEIGHT*i])
        one_holder(HOLDER_HEIGHT, i==2);
}

rotate([0, -90, 0])
holder();