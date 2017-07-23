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


//
// PARTS
//

//TODO: Ratchet to clip servo into its cavity; hole to free up servo

module make_plate_base(thickness) {
    scale([1, 1, PLATE_THICKNESS +0*GEAR_HUB_CUBE_WIDTH])
    difference() {
        // cheese base
        cylinder(r=PLATE_DIAMETER/2);

        // slot for servo wheel
        slot_thickness = WHEEL_THICKNESS + PLAY * 2;
        slot_length = WHEEL_EXTERNAL_DIAMETER  + PLAY *2;
        translate([slot_thickness/2 + GEAR_HUB_CUBE_HEIGHT/2 - PLAY*0, 0, 0])
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
    scale([1, 1, PLATE_THICKNESS+ATOM*2]) {
        r = PLATE_DIAMETER/2 - PLATE_SCREWS_BORDER_DISTANCE;
        n = 4;
        offset_angle = 50;
        for(a=[0:n-1])
            rotate([0, 0, a*360/n + offset_angle])
            translate([0, r, 0])
            cylinder(r=SNAP_HOLE_DIAMETER/2, true);        
    }
}

module make_servo_hull(with_clearances=false) {
    z = WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS;
    translate([WHEEL_THICKNESS-SCREW_PLATE_THICKNESS, 0, z])
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
    translate([WHEEL_THICKNESS-SCREW_PLATE_THICKNESS, 0, z+SERVO_THICKNESS/2])
    servo_grips();
}

module plate(){
    difference() {
        make_plate_base(PLATE_THICKNESS);

        make_center_screw_cavity(SCREW_SHAFT_DIAMETER);
        make_snap_cavities();
        make_servo_cavity();
        //make_servo_extraction_cut();
    }
    make_servo_grips();
}

//
// ALL
//
plate();


if (1) {
    translate([GEAR_HUB_CUBE_HEIGHT/2 + WHEEL_THICKNESS, 0, 
               WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS])
    rotate([0, -90, 0])
    %make_gears();
    
    %make_servo_hull();
}
