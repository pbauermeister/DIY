//TODO: slits for zip ties

include <definitions.scad>
include <lib/wheel-lib.scad>
include <gears.scad>
include <servo.scad>
use <02-primary-plate.scad>

HOLDER_HEIGHT_EXTRA = PLAY*4;
HOLDER_HEIGHT = PLATE_THICKNESS + PLATE2_HEIGHT + HOLDER_HEIGHT_EXTRA;
//HOLDER_HOLES_RADIUS = 1;
//HOLDER_HOLES_SPACING = 8;
//HOLDER_HOLES_HOFFSET = 3;

echo("height =", HOLDER_HEIGHT);

module one_holder(height, is_last_holder) {
    translate([0, 0, -PLATE2_HEIGHT])
    difference() {
        scale([1, 1, height])
        difference() {
            // pizza slice
            
            angle_trimming_1 = 10;
            angle_trimming_2 = 4;
            rotate([0, 0, 45*3-angle_trimming_1])
            intersection() {
                cylinder(r=HOLDER_RADIUS);
                cube(HOLDER_RADIUS);
                rotate([0, 0, 45+angle_trimming_1+angle_trimming_2]) cube(HOLDER_RADIUS);    
            }
//            // remove servo
//            make_servo_hull(z=SERVO_THICKNESS/2);
            // remove main plate
            cylinder(r=PLATE_DIAMETER/2+TOLERANCE);
            // file flat
            translate([-PLATE_DIAMETER*1.5 - HOLDER_SPINE_THICKNESS, -PLATE_DIAMETER/2, 0])
            cube([PLATE_DIAMETER, PLATE_DIAMETER, PLATE2_HEIGHT+PLATE_THICKNESS]);
        }
        
//        // holes
//        n = ceil((PLATE_THICKNESS/2 + PLATE2_HEIGHT - HOLDER_HOLES_HOFFSET) / HOLDER_HOLES_SPACING);
//        for (i=[0:n-1])
//            for (j=[0:1])
//                translate([0, -j*HOLDER_HOLES_SPACING, i * HOLDER_HOLES_SPACING + HOLDER_HOLES_HOFFSET])
//                translate([0, -HOLDER_HOLES_SPACING/2, HOLDER_HOLES_SPACING/2])
//                scale([HOLDER_RADIUS, 1, 1])
//                rotate([0, -90, 0])
//                cylinder(r=HOLDER_HOLES_RADIUS);     
    }

    // servo cover
    difference() {
        hh = WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS + SERVO_THICKNESS/2;
        h = PLATE_THICKNESS - hh -TOLERANCE;
        z = height - h*2 + PLAY + TOLERANCE;
        translate([SERVO_X_POSITION, 0, z])
        servo_cover(h);

        // carve main plate
        cylinder(r=PLATE_DIAMETER/2+TOLERANCE);
        // file flat
        translate([-PLATE_DIAMETER*1.5 - HOLDER_SPINE_THICKNESS, -PLATE_DIAMETER/2, 0])
        cube([PLATE_DIAMETER, PLATE_DIAMETER, PLATE2_HEIGHT+PLATE_THICKNESS]);
    }

//    // pivot "nipple"
//    PIVOT_RADIUS = 0.75;
//    if (!is_last_holder)
//        translate([-0.5, 0, height-PLATE2_HEIGHT]) // -PIVOT_RADIUS+PLAY*3])    
//        sphere(r=PIVOT_RADIUS);
}

module make_servo_hull(with_clearances=false,
                       z=WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS) {
    translate([SERVO_X_POSITION, 0, z])
    servo_hull(with_clearances);
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