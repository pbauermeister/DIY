//
// Print profile: normal
//
include <definitions.scad>
use <tower.scad>
use <servos_123.scad>
use <servo_horn_adjuster.scad>
use <servo.scad>
use <cube.scad>

//%servos();

GRIPPER_HEIGHT = CUBE_HEIGHT / 2 -SERVO_TAB_BOTTOM_TO_HORN_HEIGHT
                 + SERVO_TAB_BOTTOM_TO_HORN_HEIGHT - GRIPPER_THICKNESS
                 + PLAY;

module cube_upper() {
    translate([0, 0, CUBE_HEIGHT+TOLERANCE]) {
        %translate([0, 0, GRIPPER_HEIGHT]) gripper();

        cube_new(0, GRIPPER_HEIGHT, simple=false);

        // rail
        translate([0, 0, -GROOVE_DEPTH])
        difference() {
            cylinder(d=CUBE_WIDTH - GROOVE_MARGIN*2, h=GROOVE_DEPTH);
            cylinder(d=CUBE_WIDTH - GROOVE_MARGIN*2 - GROOVE_THICKNESS*2, h=GROOVE_DEPTH);
        }

        difference() {
            cylinder(d=CUBE_WIDTH - WALL_THICKNESS*2, h=CUBE_HEIGHT);
            cylinder(d=CUBE_WIDTH - GROOVE_MARGIN*2 - GROOVE_THICKNESS*2 + PLAY, h=CUBE_HEIGHT);
        }

        r1 = CUBE_WIDTH/2 - WALL_THICKNESS - (SPACING/2);
        difference() {
            translate([0, 0, GRIPPER_HEIGHT/2])
            cube([CUBE_WIDTH - WALL_THICKNESS*2, CUBE_WIDTH - WALL_THICKNESS*2, GRIPPER_HEIGHT], center=true);

            translate([0, 0, -ATOM])
            cylinder(r=r1, h=GRIPPER_HEIGHT+ATOM*2);
            
            translate([0, 0, WALL_THICKNESS])
            cylinder(r=r1+TOLERANCE*2, h=GRIPPER_HEIGHT-WALL_THICKNESS);
        }
    }
}

difference() {
    cube_upper();
    if ($preview) cube(CUBE_WIDTH*3);
}

%servo3();
