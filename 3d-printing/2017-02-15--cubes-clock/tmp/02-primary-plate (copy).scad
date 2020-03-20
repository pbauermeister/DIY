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
    translate([PLATE_THICKNESS/2-GEAR_HUB_CUBE_WIDTH/2, 0, GEAR_HUB_CUBE_WIDTH/2])
    rotate([0, 90, 0]) 
    scale([1, 1, PLATE_THICKNESS +0*GEAR_HUB_CUBE_WIDTH])
    difference() {
        // cheese base
        translate([0, 0, -0.5]) cylinder(r=PLATE_DIAMETER/2);

        // slot for servo wheel
        slot_thickness = WHEEL_THICKNESS + PLAY * 4;
        slot_length = WHEEL_EXTERNAL_DIAMETER  + PLAY *2;

        translate([-slot_thickness/2 + GEAR_HUB_CUBE_WIDTH/2 + PLAY*3.5, 0, 0])
        cube([slot_thickness, slot_length, 2], true  );
    }
}

module make_center_screw_cavity(diameter) {
//    translate([-GEAR_HUB_CUBE_WIDTH/2, 0, GEAR_HUB_CUBE_HEIGHT/2 + GEAR_HUB_CUBE_SHIFT])
    translate([-GEAR_HUB_CUBE_WIDTH/2, 0, GEAR_HUB_CUBE_WIDTH/2])
    rotate([0, 90, 0])        
    translate([0, 0, -ATOM])
    scale([1, 1, PLATE_THICKNESS+ATOM*2])
        cylinder(r=diameter/2, true);
}

module make_snap_cavities() {
    translate([-GEAR_HUB_CUBE_WIDTH/2, 0, GEAR_HUB_CUBE_HEIGHT/2 + GEAR_HUB_CUBE_SHIFT])
    rotate([0, 90, 0])        
    translate([0, 0, -ATOM])
    scale([1, 1, PLATE_THICKNESS+ATOM*2]) {
        r = PLATE_DIAMETER/2 - PLATE_SCREWS_BORDER_DISTANCE;
        n = 2;
        offset_angle = 50;
        for(a=[0:n-1])
            rotate([0, 0, a*360/n + offset_angle])
            translate([0, r, 0])
            cylinder(r=SNAP_HOLE_DIAMETER/2, true);        
    }
}

module make_servo_hull(offset=0, with_clearances=false) {
    rotate([0, 180, 0])
    translate([0, 0, -GEAR_HUB_CUBE_SHIFT])
    translate([0, 0, offset])
    servo_hull(with_clearances);
}

module make_servo_cavity() {
    step = 1;
    n = ceil((PLATE_THICKNESS-SERVO_THICKNESS)/step) + 1;
    for(x=[0:n])
        translate([x*step, 0, 0])
            make_servo_hull(0, true);
}

module make_servo_extraction_cut() {
    rotate([0, 180, 0])
    translate([0, 0, -GEAR_HUB_CUBE_SHIFT])
    servo_cut(PLATE_THICKNESS*1.5, shave_by=8);
}

module make_servo_grips() {
    rotate([0, 180, 0])
    translate([0, 0, -GEAR_HUB_CUBE_SHIFT])
    servo_grips();
}

module plate(){
    difference() {
        make_plate_base(PLATE_THICKNESS);

        make_center_screw_cavity(SCREW_SHAFT_DIAMETER);
        make_snap_cavities();
        make_servo_cavity();
        make_servo_extraction_cut();
    }
    make_servo_grips();
}

//
// ALL
//
//rotate([0, -90, 0])
plate();

if(0) rotate([0, -90, 0]) {
    %make_gears();
    %make_servo_hull();
}
