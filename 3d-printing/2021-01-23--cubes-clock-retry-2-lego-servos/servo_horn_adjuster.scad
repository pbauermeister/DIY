//
// Print profile: normal
//

include <definitions.scad>
use <tower.scad>


module crown(shave=0, holes=false, simple=false) {
    translate([0, 0, GRIPPER_THICKNESS/2])
    difference() {
        // body
        cube([CUBE_WIDTH-shave*2, CUBE_WIDTH-shave*2, GRIPPER_THICKNESS], center=true);


        // hole
        cylinder(r=GRIPPER_CROWN_RADIUS, h=GRIPPER_THICKNESS*2, center=true);
        
        // teeth
        if (!simple)
            for (i=[0:GRIPPER_STEPS-1]) {
                rotate([0, 0, i*360/GRIPPER_STEPS])
                translate([GRIPPER_CROWN_RADIUS, 0, 0])
                scale([1.75, 1, 1])
                rotate([0, 0, 45])
                cube([GRIPPER_TOOTH, GRIPPER_TOOTH, GRIPPER_THICKNESS*2], center=true);
            }
        
        // groove
        if (!simple)
            rotate_extrude(convexity = 10)
            translate([GRIPPER_CROWN_RADIUS, 0, 0])
            circle(d = GRIPPER_BALL_DIAMETER+PLAY*2);

        // corner holes
        if (holes) {
            shift = 2;
            d2 = (CUBE_WIDTH/2 - GRIPPER_MARGIN*sqrt(2)) * (sqrt(2)-1) - shift;
            for (i=[0:3]) {
                rotate([0, 0, 45 + i*90])
                translate([CUBE_WIDTH/2 - GRIPPER_MARGIN + d2/2 +shift, 0, 0])
                cylinder(d=d2, h=GRIPPER_THICKNESS*2, center=true);
            }
        }
    }
}

module gripper() {
    translate([0, 0, GRIPPER_THICKNESS/2])
    difference() {
        d = CUBE_WIDTH/2-GRIPPER_MARGIN;
        cube_w = 1 * 3.5;
        cube_diag = cube_w / sqrt(2);
        arm_width = cube_w * 4;
        cavity_w = 1.5;
        cavity_shift = 0.75;
        union() {
            cylinder(r=HORN_CROSS_WIDTH, h=GRIPPER_THICKNESS, center=true);

            for (i=[0:3]) {
                rotate([0, 0, i*90])
                difference() {
                    union() {
                        translate([CUBE_WIDTH/2-GRIPPER_MARGIN-cube_diag+TOLERANCE, 0, 0])
                        scale([1, 0.66, 1])
                        rotate([0, 0, 45])
                        cube([cube_w, cube_w, GRIPPER_THICKNESS], center=true);
                        translate([d/2-cube_w/sqrt(2), 0, 0])
                        cube([d, arm_width, GRIPPER_THICKNESS], center=true);
                        
                        translate([TOLERANCE*0, 0, 0])
                        hull() {
                            translate([CUBE_WIDTH/2-GRIPPER_MARGIN+TOLERANCE, 0, 0])
                            sphere(d=GRIPPER_BALL_DIAMETER-TOLERANCE);
                            translate([CUBE_WIDTH/2-GRIPPER_MARGIN+TOLERANCE-cube_diag*2, cube_diag*2*.66, 0])
                            sphere(d=GRIPPER_BALL_DIAMETER-TOLERANCE);
                        }
                        translate([TOLERANCE*0, 0, 0])
                        hull() {
                            translate([CUBE_WIDTH/2-GRIPPER_MARGIN+TOLERANCE, 0, 0])
                            sphere(d=GRIPPER_BALL_DIAMETER-TOLERANCE);
                            translate([CUBE_WIDTH/2-GRIPPER_MARGIN+TOLERANCE-cube_diag*2, -cube_diag*2*.66, 0])
                            sphere(d=GRIPPER_BALL_DIAMETER-TOLERANCE);
                        }

                    }
                    translate([d-cavity_w/2-cube_w/sqrt(2)-cavity_shift, 0, 0])
                    cube([cavity_w, arm_width-cavity_w*2, GRIPPER_THICKNESS*2], center=true);
                }
            }
            translate([0, 0, -GRIPPER_THICKNESS/2])
            cylinder(d=arm_width, h=GRIPPER_THICKNESS + GRIPPER_AXIS_EXTRA_HEIGHT);
        }

        // horn axis hole
        translate([0, 0, -GRIPPER_THICKNESS/2-ATOM])
        horn_cross(0.3/2, GRIPPER_THICKNESS+ATOM*2 + GRIPPER_AXIS_EXTRA_HEIGHT);
        
        // hollowings
        for (i=[0:3]) {
            rotate([0, 0, i*90])
            translate([d/2, 0, 0])
            cylinder(d=arm_width-5, GRIPPER_THICKNESS*2, center=true);
        }

    }
}


crown(holes=true);

if (1)
translate([CUBE_WIDTH, 0, 0])
gripper();
