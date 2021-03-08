//
// Print profile: normal
//

include <definitions.scad>
use <tower.scad>

ADJUST = 1;  // increase to loosen plate and gripper

module plate(thickness, margin, ball_diameter, adjust) {
    translate([0, 0, thickness/2])
    difference() {
        // body
        cube([CUBE_WIDTH, CUBE_WIDTH, thickness], center=true);

        r0 = CUBE_WIDTH/2-margin;
        circum = PI*r0*2;
        steps = 360 / 1;
        tooth = circum / steps / sqrt(2);
        r = r0 - tooth*sqrt(2)/2 -PLAY/2*ADJUST;

        // hole
        cylinder(r=r, h=thickness*2, center=true);
        
        // teeth
        for (i=[0:steps-1]) {
            rotate([0, 0, i*360/steps])
            translate([r, 0, 0])
            scale([1.75, 1, 1])
            rotate([0, 0, 45])
            cube([tooth, tooth, thickness*2], center=true);
        }
        
        // groove
        rotate_extrude(convexity = 10)
        translate([r, 0, 0])
        circle(d = ball_diameter+PLAY*2);

        // corner holes
        shift = 2;
        d2 = (CUBE_WIDTH/2 - margin*sqrt(2)) * (sqrt(2)-1) - shift;
        for (i=[0:3]) {
            rotate([0, 0, 45 + i*90])
            translate([CUBE_WIDTH/2 - margin + d2/2 +shift, 0, 0])
            cylinder(d=d2, h=thickness*2, center=true);
        }
    }
}

module gripper(thickness, margin, ball_diameter) {
    translate([0, 0, thickness/2])
    difference() {
        d = CUBE_WIDTH/2-margin;
        cube_w = 1 * 3.5;
        cube_diag = cube_w / sqrt(2);
        arm_width = cube_w * 4;
        cavity_w = 1.5;
        cavity_shift = 0.75;
        union() {
            cylinder(r=HORN_CROSS_WIDTH, h=thickness, center=true);

            for (i=[0:3]) {
                rotate([0, 0, i*90])
                difference() {
                    union() {
                        translate([CUBE_WIDTH/2-margin-cube_diag+TOLERANCE, 0, 0])
                        scale([1, 0.66, 1])
                        rotate([0, 0, 45])
                        cube([cube_w, cube_w, thickness], center=true);
                        translate([d/2-cube_w/sqrt(2), 0, 0])
                        cube([d, arm_width, thickness], center=true);
                        
                        translate([TOLERANCE*0, 0, 0])
                        hull() {
                            translate([CUBE_WIDTH/2-margin+TOLERANCE, 0, 0])
                            sphere(d=ball_diameter-TOLERANCE);
                            translate([CUBE_WIDTH/2-margin+TOLERANCE-cube_diag*2, cube_diag*2*.66, 0])
                            sphere(d=ball_diameter-TOLERANCE);
                        }
                        translate([TOLERANCE*0, 0, 0])
                        hull() {
                            translate([CUBE_WIDTH/2-margin+TOLERANCE, 0, 0])
                            sphere(d=ball_diameter-TOLERANCE);
                            translate([CUBE_WIDTH/2-margin+TOLERANCE-cube_diag*2, -cube_diag*2*.66, 0])
                            sphere(d=ball_diameter-TOLERANCE);
                        }

                    }
                    translate([d-cavity_w/2-cube_w/sqrt(2)-cavity_shift, 0, 0])
                    cube([cavity_w, arm_width-cavity_w*2, thickness*2], center=true);
                }
            }
        }

        // horn axis hole
        translate([0, 0, -thickness/2-ATOM])
        horn_cross(0.3/2, thickness+ATOM*2);
        
        // hollowings
        for (i=[0:3]) {
            rotate([0, 0, i*90])
            translate([d/2, 0, 0])
            cylinder(d=arm_width-5, thickness*2, center=true);
        }

    }
}

thickness = 5;
margin = 3;
ball_diameter = 1.5;

plate(thickness, margin, ball_diameter);

if (0)
translate([CUBE_WIDTH, 0, 0])
gripper(thickness, margin, ball_diameter);
