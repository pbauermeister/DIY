//
// GENERAL
//

$fn = 96;

PLAY = 0.4;
TOLERANCE = 0.17;
ATOM = 0.01;
WALL_THICKNESS = 1;

//
// SERVO (new)
//

SERVO_THICKNESS = 11.5;
SERVO_AXIS_RADIUS = 3;

//
// GEARS (new)
//

GEARS_DISTANCE = 14.3;
echo("GEARS_DISTANCE", GEARS_DISTANCE);

GEARS_THICKNESS = 5;
WHEEL_AXIS_TIGHTEN = TOLERANCE*0.75;
WHEEL_HOLE_DIAMETER = SERVO_AXIS_RADIUS*2 - WHEEL_AXIS_TIGHTEN;

//PINION_RADIUS = 5.6;
//WHEEL_RADIUS = 10.6;
WHEEL_PLATE_THICKNESS = 1;

//    Erlaubte Module nach DIN 780:
//    0.05 0.06 0.08 0.10 0.12 0.16
//    0.20 0.25 0.3  0.4  0.5  0.6
//    0.7  0.8  0.9  1    1.25 1.5
//    2    2.5  3    4    5    6
//    8    10   12   16   20   25
//    32   40   50   60
GEARS_MODULE = 0.65;



// Plate
PLATE_DIAMETER = 50;
PLATE_THICKNESS = 20.5;
PLATES_OVERLAP = 12;

PLATE_HEIGHT_SHORT = 18;


PLATE2_WHEEL_HEIGHT = 2.5;
PLATE2_HEIGHT = PLATE2_WHEEL_HEIGHT + GEARS_THICKNESS;

PLATE2_GROVE_HEIGHT = 2;
PLATE2_GROVE_THICKNESS = 5;
PLATE2_LEVER_HEIGHT = 2;

PLATE2_BAR_WIDTH = 5;
PLATE2_RADIUS_RECESSION = 1.5;

PLATE2_RADIUS = PLATE_DIAMETER/2 - PLATE2_RADIUS_RECESSION;

// Side screws
SCREW_PLATE_THICKNESS = 1;
SCREW2_DIAMETER = 2.9;
SCREW2_HEAD_DIAMETER = 5.5;
SCREW2_HEAD_THICKNESS = 2;
SCREW2_HEIGHT = 12; // overall

SERVO_SCREW1_H_DISPLACEMENT = 20.5;
SERVO_SCREW2_H_DISPLACEMENT = -9;
SERVO_SCREW_V_DISPLACEMENT = -11.5;
SERVO_SCREW_HEAD_EXTENT = 20;

SERVO_SCREW_THREAD_DIAMETER = 2.5;


HOLDER_ARM_HEIGHT = 13;
HOLDER_ARM_RADIUS_SHORTAGE = 15;
HOLDER_ARM_RADIUS = 4;
HOLDER_ARM_THICKNESS = 6;
HOLDER_THICKNESS = 3;
HOLDER_ANGLE = 35; //20
HOLDER_MODULES_SPACING = 10;


block_cylinder = PLATE_THICKNESS + PLATE2_HEIGHT;
BLOCKS_JOIN = PLAY/2;
BLOCK1_HEIGHT = block_cylinder*2  + PLAY*2 - PLATE2_HEIGHT;
BLOCK1_HEIGHT_STACKABLE = BLOCK1_HEIGHT + BLOCKS_JOIN;

BLOCK2_HEIGHT = PLATE2_HEIGHT + PLAY*2;
BLOCK2_HEIGHT_STACKABLE = BLOCK2_HEIGHT + BLOCKS_JOIN;

BLOCK3_HEIGHT = block_cylinder*2  + PLAY*2 - PLATE2_HEIGHT;
BLOCK3_HEIGHT_STACKABLE = BLOCK3_HEIGHT + BLOCKS_JOIN;

//////////////////////////////////////////////////////////////////////////

//
// SPECIFIC
//

//// Center screw
//SCREW_SHAFT_DIAMETER = 2;
//SCREW_THREAD_DIAMETER = 2.5;
//SCREW_HOLE_LENGTH = 5;



// PLATE 2
PINION_NECK_RADIUS = 6.5;
PINION_SCREW_HEAD_RADIUS = 3 + PLAY;

PINION_THICKNESS = 5.3;
PINION_HEIGHT = PINION_THICKNESS;

//PLATE2_HEIGHT = 7;
//PLATE2_H4 = PLATE2_HEIGHT;
//PLATE2_H3 = 5.5;
//PLATE2_H2 = 5;
//PLATE2_H1 = 3;

//PLATE2_R4 = PLATE2_R5;// - 1;

//PLATE2_R32 = (PLATE2_R4-1);
//PLATE2_R3 = PLATE2_R4 - 1;
//PLATE2_R2 = PLATE2_R3 - 1.5;
//PLATE2_R1 = PLATE2_R2 - 1.5;
//PLATE2_R1 = PLATE2_R5 - 7;
//PLATE2_R0 = PLATE2_R5 - 8;
//
//
//PLATE2_BAR_SPACE = 0.4;
//PLATE2_RING_THICKNESS = 0.7 * 2;
//
//PLATE2_RATCHET_RADIUS = 1;
//
//PLATE2_SPRING_THICKNESS = 0.7;
//PLATE2_SPRING_HEIGHT = 1;
//
//PLATE2_BAR_ANGLE = 20;

//PLATE2_NECK_HEIGHT = PLATE2_H4 - PINION_HEIGHT + 0.5;
//PLATE2_CROWN_HEIGHT = PLATE2_H4 - PLATE2_H3;

BOX_SIDE = 70;
PLATE2_BOX_INNER_HOLE_DIAMETER = 62;

WHEEL_THICKNESS = 3.5 -0.2;

SERVO_X_ADJUSTMENT = 0.5;
SERVO_X_POSITION = WHEEL_THICKNESS - SCREW_PLATE_THICKNESS + SERVO_X_ADJUSTMENT;
echo("Servo x pos: ", SERVO_X_POSITION);

HOLDER_RADIUS = 29.5;
HOLDER_SPINE_THICKNESS = 2.5 +1;

ZIP_TIE_SLIT_WIDTH = 3;
ZIP_TIE_SLIT_THICKNESS = 2;
ZIP_TIE_BUMP_RADIUS = 1;

echo("Total height: ", PLATE_THICKNESS+PLATE2_HEIGHT+PLAY+TOLERANCE);

// Snapping
SNAP_HOLE_DIAMETER = 4;

CUBE_CROWN_HEIGHT = 2.5;
CUBE_LEVER_THICKNESS = 4;
CUBE_SNAP_BALLS_RADIUS = 0.6;
DIGIT_SEGMENT_WIDTH = 3.5;

//
// DIGIT SEGMENTS
// 

SEGMENTS_TOP = ["a", "b", "c", "c", "b", "d", "d", "c", "a", "a"];
SEGMENTS_MID = ["j", "i", "k", "k", "k", "k", "k", "i", "k", "k"];
SEGMENTS_LOW = ["e", "f", "g", "h", "f", "h", "e", "f", "e", "h"];

//
// HELPERS
//

module spoke(radius, width, height) {
    translate([0, 0, height/2])
    intersection() {
        cube([radius*3, width, height], true);

        translate([0, 0, -height/2])
        scale([1, 1, height])
        cylinder(r=radius, true);
    }
}

module barrel(outer_radius, inner_radius, height) {
    scale([1, 1, height])
    difference() {
        cylinder(r=outer_radius);
        translate([0, 0, -0.5]) scale([1, 1, 2])
        cylinder(r=inner_radius);
    }
}

module box_sides(outer_side, thickness, height) {
    scale([1, 1, height/outer_side])
    translate([0, 0, outer_side/2])
    difference() {
        cube(outer_side, true);
        scale([1, 1, 2])
        cube(outer_side - thickness*2, true);
    }
}

module alignment_columns(column_extra=0, height=1) {
    r = PLATE_DIAMETER/2 - PLATE_SCREWS_BORDER_DISTANCE;
    n = 4;
    offset_angle = 45;
    scale([1, 1, height])
    for(a=[0:n-1])
        rotate([0, 0, a*360/n + offset_angle])
        translate([0, r, 0])
        cylinder(r=SNAP_HOLE_DIAMETER/2 + column_extra, true);        
}

function servo_cover_height() =
           PLATE_THICKNESS
           - (WHEEL_EXTERNAL_DIAMETER/2 - PINION_THICKNESS + SERVO_THICKNESS/2)
           -TOLERANCE;

module screw(head_extent=0, is_clearance_hole=false) {   
    // thread
    translate([0, 0, -SCREW2_HEIGHT + SCREW2_HEAD_THICKNESS])
    cylinder(h=SCREW2_HEIGHT,
             r=SCREW2_DIAMETER/2 - TOLERANCE
               + (is_clearance_hole ? TOLERANCE*2 : 0));

    // head
    for (i=[0:head_extent])
        translate([0, 0, i])
        cylinder(h=SCREW2_HEAD_THICKNESS, r=SCREW2_HEAD_DIAMETER/2 + PLAY);
}

module flip(height, additional_angle=0) {
        translate([0, 0, height])
        rotate([180, 0, 90-additional_angle])
        children();
}