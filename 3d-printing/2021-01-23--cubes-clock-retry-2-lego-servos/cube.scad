include <definitions.scad>
use <servo_horn_adjuster.scad>
/*
use <tower.scad>
use <servos_123.scad>
use <servo.scad>
*/

module _cube_walls(altitude, inner_width, inner_height, mink=true) {
    difference() {
        translate([-CUBE_WIDTH/2+CHAMFER, -CUBE_WIDTH/2+CHAMFER, altitude+CHAMFER])
        minkowski() {
            cube([CUBE_WIDTH-CHAMFER*2, CUBE_WIDTH-CHAMFER*2, CUBE_HEIGHT-CHAMFER*2]);
            if (!$preview && mink)
                sphere(r=CHAMFER);
        }

        translate([-inner_width/2, -inner_width/2, altitude])
        cube([inner_width, inner_width, inner_height]);
    }
}

module cube_new(altitude, gripper_height, simple=false) {
    inner_width = CUBE_WIDTH - CUBE_WALL_THICKNESS*2;
    inner_height = CUBE_HEIGHT - CUBE_WALL_THICKNESS;

    // walls
    color("#eeeeee")
    _cube_walls(altitude, inner_width, inner_height);

    if (gripper_height) {
        // gripper
        translate([0, 0, gripper_height])
        crown(shave=CUBE_WALL_THICKNESS, simple=$preview || simple);

        translate([-CUBE_WIDTH/2+CUBE_WALL_THICKNESS, -CUBE_WIDTH/2+CUBE_WALL_THICKNESS, 0])
        translate([0, 0, gripper_height+GRIPPER_THICKNESS])
        cube([CUBE_WIDTH-CUBE_WALL_THICKNESS*2, CUBE_WIDTH-CUBE_WALL_THICKNESS*2, CUBE_HEIGHT-gripper_height-GRIPPER_THICKNESS-CUBE_WALL_THICKNESS]);
    }
}

cube_new(0, 0);