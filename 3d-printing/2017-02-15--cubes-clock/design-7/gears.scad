include <lib/wheel-lib.scad>
include <servo.scad>
include <definitions.scad>

//
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 10%
//

// Gear
WHEEL_EXTERNAL_DIAMETER = 24.65;
WHEEL_AXIS_TIGHTEN = TOLERANCE*0.5;
WHEEL_HOLE_DIAMETER = SERVO_AXIS_RADIUS*2 - WHEEL_AXIS_TIGHTEN;
WHEEL_PLATE_THICKNESS = 1;

GEAR_HUB_CUBE_WIDTH = 15.8 - PLAY*2 + 0.3;
GEAR_HUB_CUBE_HEIGHT = 5.8 - PLAY*2 + 1.3;
GEAR_HUB_CUBE_SHIFT = WHEEL_THICKNESS;


//
// PARTS
//

module make_gears(generate_what=GEAR_BEVEL_PAIR_TOGETHER) {
    gear_bevel_pair(
        gears_module=0.8,
        wheel_teeth_nb=30,
        wheel_hole_diameter=WHEEL_HOLE_DIAMETER,
        pinion_teeth_nb=14,
        pinion_hole_diameter=SCREW_THREAD_DIAMETER + TOLERANCE,
        teeth_width=5,
        axis_angle=90,
        generate_what=generate_what
        //                generate_what=GEAR_BEVEL_PAIR_ONLY_PINION
    );
    
    if (generate_what==GEAR_BEVEL_PAIR_TOGETHER) {
        // Wheel plate
        translate([0, 0, -WHEEL_PLATE_THICKNESS])
        wheel_plate();
    }
}

module make_gears_test_box() {
    translate([0, 0, GEAR_HUB_CUBE_HEIGHT/2 + GEAR_HUB_CUBE_SHIFT])
    cube([GEAR_HUB_CUBE_WIDTH, GEAR_HUB_CUBE_WIDTH, GEAR_HUB_CUBE_HEIGHT], true);

    // markers
    translate([0, 0, GEAR_HUB_CUBE_HEIGHT + GEAR_HUB_CUBE_SHIFT])
    sphere(r=SERVO_AXIS_RADIUS-TOLERANCE);

    translate([-GEAR_HUB_CUBE_WIDTH/2, 0, GEAR_HUB_CUBE_HEIGHT/2 + GEAR_HUB_CUBE_SHIFT])
    sphere(r=SCREW_THREAD_DIAMETER/2 - TOLERANCE);
}

module make_gears_for_test(together=true) {
    if (together) {
        %make_gears();
        %make_gears_test_box();
    } else {
        make_gears(GEAR_BEVEL_PAIR_SEPARATE_FLAT);    
        translate([-WHEEL_EXTERNAL_DIAMETER/2 - 20, 0, -GEAR_HUB_CUBE_SHIFT])
        make_gears_test_box();
    }
}

module wheel_plate() {
    difference() {
        cylinder(r=WHEEL_EXTERNAL_DIAMETER/2);
        translate([0, 0, -ATOM])
        scale([1, 1, WHEEL_PLATE_THICKNESS+ATOM*2])
        cylinder(r=SCREW_THREAD_DIAMETER/2 + TOLERANCE);
    }
}
    
module make_printable_wheel() {

//    // Pinion
//    translate([WHEEL_EXTERNAL_DIAMETER/2 + 20, 0, 0])
//    make_gears(GEAR_BEVEL_PAIR_ONLY_PINION_FLAT);
    
    // Wheel
    translate([0, 0, WHEEL_PLATE_THICKNESS])
    make_gears(GEAR_BEVEL_PAIR_ONLY_WHEEL);

    // Wheel plate
    wheel_plate();
}
