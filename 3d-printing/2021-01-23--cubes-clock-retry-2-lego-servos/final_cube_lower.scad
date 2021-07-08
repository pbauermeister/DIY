include <definitions.scad>
use <tower.scad>
use <servos_123.scad>
use <servo_horn_adjuster.scad>
use <servo.scad>
use <cube.scad>

//%servos();

GRIPPER_HEIGHT = CUBE_HEIGHT / 2 -SERVO_TAB_BOTTOM_TO_HORN_HEIGHT
                 + SERVO_TAB_BOTTOM_TO_HORN_HEIGHT - GRIPPER_THICKNESS + GRIPPER_AXIS_EXTRA_HEIGHT
                 + PLAY;

module cube_lower() {
    difference() {
        cube_new(0, GRIPPER_HEIGHT, simple=false);
        servo3(with_cavities=true, short_cavity=true);
    
        // groove
        translate([0, 0, CUBE_HEIGHT - GROOVE_DEPTH - PLAY*2])
        difference() {
            cylinder(d=CUBE_WIDTH - GROOVE_MARGIN*2 + PLAY*2, h=CUBE_HEIGHT);
            cylinder(d=CUBE_WIDTH - GROOVE_MARGIN*2 - PLAY*2 - GROOVE_THICKNESS*2, h=CUBE_HEIGHT);
        }
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

difference() {
    cube_lower();
    if ($preview) cube(CUBE_WIDTH);
}
%servo3();
