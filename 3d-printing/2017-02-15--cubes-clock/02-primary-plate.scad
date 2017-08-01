//TODO : - Design 2nd plate: 90° snappers crown, cross attached to pinion to transmit to crown with lotta play, crown-cross: axial guidance, vertical locking, pionon to plate with 4x shafts to next module

include <lib/wheel-lib.scad>
include <servo.scad>
include <definitions.scad>
include <gears.scad>

//
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 10%
//

SERVO_X_ADJUSTMENT = 0.5;

SERVO_X_POSITION = WHEEL_THICKNESS - SCREW_PLATE_THICKNESS + SERVO_X_ADJUSTMENT;

//
// PARTS
//

module make_plate_base(thickness) {
    scale([1, 1, PLATE_THICKNESS])
    difference() {
        // cheese base
        cylinder(r=PLATE_DIAMETER/2);

        // slot for servo wheel
        slot_thickness = WHEEL_THICKNESS + WHEEL_PLATE_THICKNESS + PLAY*2 + 0.5;
        slot_length = WHEEL_EXTERNAL_DIAMETER  + PLAY*2;
        correction = -0.25; // -0.5;
        translate([slot_thickness/2 + GEAR_HUB_CUBE_HEIGHT/2 +correction - PLAY*0, 0, 0.5])
        cube([slot_thickness, slot_length, 2], true  );
    }
}

module make_center_screw_cavity(diameter) {
    translate([0, 0, -ATOM])
    scale([1, 1, PLATE_THICKNESS+ATOM*2])
        cylinder(r=diameter/2, true);
}

module make_snap_cavities() {
    translate([0, 0, -ATOM])
    scale([1, 1, PLATE_THICKNESS+ATOM*2])
    alignment_columns(TOLERANCE);
}

module make_snap_pins() {
    translate([0, 0, PLATE_THICKNESS-3])
    scale([1, 1, 3+2])
    alignment_columns(-TOLERANCE);

    translate([0, 0, PLATE_THICKNESS-3])
    scale([1, 1, 3])
    alignment_columns(+TOLERANCE);
}

module make_servo_extraction_cavity() {
    translate([0, 0, -ATOM])
    scale([1, 1, PLATE_THICKNESS+ATOM*2]) {
        r = PLATE_DIAMETER/2 /2.5;

        rotate([0, 0, 90 +20])
        translate([0, r, 0])
        cylinder(r=SNAP_HOLE_DIAMETER/2 *1.5, true);        
    }
}

module make_servo_hull(with_clearances=false) {
    z = WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS;
    translate([SERVO_X_POSITION, 0, z])
    servo_hull(with_clearances);
}

module make_servo_cavity() {
    step = SERVO_THICKNESS-1;
    n = ceil((PLATE_THICKNESS-SERVO_THICKNESS)/step) + 1;
    for(i=[0:n])
        translate([0, 0, i*step])
            make_servo_hull(true);
}

module make_servo_extraction_cut() {
    servo_cut(PLATE_THICKNESS*1.5, shave_by=8);
}

module make_servo_grips() {
    z = WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS;    

    intersection() {
        translate([SERVO_X_POSITION, 0, z+SERVO_THICKNESS/2])
        servo_grips();
    
        scale([1, 1, PLATE_THICKNESS])
        cylinder(r=PLATE_DIAMETER/2);
    }
}

module plate(){
    difference() {
        make_plate_base(PLATE_THICKNESS);

        make_center_screw_cavity(SCREW_SHAFT_DIAMETER);
        make_snap_cavities();
        make_servo_cavity();
        make_servo_extraction_cavity();
        //make_servo_extraction_cut();
    }
    make_servo_grips();
    
    if(0) difference() {
        make_snap_pins();
        make_servo_cavity();
    }
}

//
// ALL
//
plate();


if (1) {
    // servo ghost
    translate([GEAR_HUB_CUBE_HEIGHT/2 + WHEEL_THICKNESS, 0, 
               WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS])
    rotate([0, -90, 0]) %make_gears();
    %make_servo_hull();
}



