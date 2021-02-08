//
// GENERAL
//

$fn = 96;

PLAY = 0.35; //0.40
TOLERANCE = 0.12; //0.17
SPACING = 0.5;
ATOM = 0.01;
WALL_THICKNESS = 1;


//
// SERVO
//

//include <def-servo-mc-1811.scad>
include <def-servo-lego-geekservo.scad>

SERVO_TOTAL_HEIGHT = SERVO_BODY_HEIGHT + SERVO_TAB_OFFSET_Z + SERVO_TAB_BOTTOM_TO_HORN_HEIGHT;
echo("SERVO_TOTAL_HEIGHT", SERVO_TOTAL_HEIGHT);

//
// CUBE
//

CUBE_HEIGHT = 54 + CUBE_SIZE_EXTRA;
CUBE_WIDTH  = 54 + CUBE_SIZE_EXTRA;
echo("CUBE_WIDTH", CUBE_WIDTH);

CUBE_RAISE = 6 +4;
CUBE_WALL_THICKNESS = 1;

SPACING_SMALL = ceil(sqrt(2) * CUBE_WIDTH/2) + CUBE_WIDTH/2 + 4;
SPACING_CENTRAL = 45;

echo("SPACING_SMALL", SPACING_SMALL);


//
// CAVITY
//

SERVO_CABLE_CAVITY_THICKNESS = 5;
SERVO_CABLE_CAVITY_WIDTH = 12;
SERVO_CABLE_CAVITY_OFFSET_FROM_BORDER = 2.5;


SERVO_BODY_CAVITY_OFFSET_X = 3;
SERVO_BODY_CAVITY_OFFSET_Y = 8;
SERVO_CAVITY_BOTTOM_EXTENT = 50;


//
// GENERIC SCREW
//

SCREW2_DIAMETER = 2.4; //2.2
SCREW2_HEAD_DIAMETER = 5.5;
SCREW2_HEAD_THICKNESS = 2;
SCREW2_HEIGHT = 11; //12*2; // overall


//
// SUPPORT - BOTTOM
//

SUPPORT_DIAMETER = CUBE_WIDTH - (CUBE_WALL_THICKNESS + SPACING + TOLERANCE)*2;
echo("SUPPORT_DIAMETER", SUPPORT_DIAMETER);
SERVO_TOP_TO_CUBE_MARGIN = 4;


//
// BASE
//

BASE_LENGTH = SPACING_SMALL*3 + SPACING_CENTRAL+CUBE_WIDTH;
BASE_HEIGHT = 20;


//
// HELPERS
//

module screw(head_extent=0, is_clearance_hole=false, is_headless=false) {   
    // thread
    translate([0, 0, -SCREW2_HEIGHT + SCREW2_HEAD_THICKNESS]) {
        cylinder(h=SCREW2_HEIGHT,
                 r=SCREW2_DIAMETER/2 - TOLERANCE
                   + (is_clearance_hole ? TOLERANCE*2 : 0));

        h = SCREW2_HEIGHT - SCREW2_HEAD_THICKNESS*1 - 0.2;
        w = TOLERANCE / 3;

        translate([0, 0, h/2]) {
            rotate([0, 0, 0])
            cube([SCREW2_DIAMETER*1.1, w, h], center=true);

            rotate([0, 0, -60])
            cube([SCREW2_DIAMETER*2.2, w, h], center=true);

            rotate([0, 0, 60])
            cube([SCREW2_DIAMETER*2.2, w, h], center=true);

            rotate([0, 0, 90])
            cube([SCREW2_DIAMETER*3.0, w, h], center=true);
        }
    }

    // head
    screw_r = (is_headless ? SCREW2_DIAMETER/2 : SCREW2_HEAD_DIAMETER/2) + (is_clearance_hole ? PLAY : 0);
    for (i=[0:head_extent])
        translate([0, 0, i])
        cylinder(h=SCREW2_HEAD_THICKNESS, 
                 r=screw_r);
}

module flip(height, additional_angle=0) {
        translate([0, 0, height])
        rotate([180, 0, 90-additional_angle])
        children();
}

