/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

include <definitions.scad>
use <2-servo-holder.scad>

module encoder_mask(extra_margin=0) {
    spacing = (ENCODER_HEIGHT - TAB_SPACING * (4+3+4)) / 6;
    margin = PLAY*2 + extra_margin*2;
    for (i=[1:4]) {
        translate([0, 0, spacing * 5 + TAB_SPACING * (7+i-1) - margin])
        scale([1, 1, TAB_SPACING + margin*2])
        cylinder(r=BODY_RADIUS*1.5, h=1, true);

        translate([0, 0, spacing * 1 + TAB_SPACING * (0+i-1) - margin])
        scale([1, 1, TAB_SPACING + margin*2])
        cylinder(r=BODY_RADIUS*1.5, h=1, true);
    }

    for (i=[1:3]) {
        translate([0, 0, spacing * 3 + TAB_SPACING * (4+i-1) - margin])
        scale([1, 1, TAB_SPACING + margin*2])
        cylinder(r=BODY_RADIUS*1.5, h=1, true);
    }
}

module encoder_mask2(radius) {
    spacing = (ENCODER_HEIGHT - TAB_SPACING * (4+3+4)) / 6;

    for(param=[[5, 7, 4, 1], [1, 0, 4, 1], [3, 4, 3, 1] ]) {
        hull() {
            translate([0, 0, spacing * param[0] + TAB_SPACING * (param[1]+param[2]-1) + radius/2])
            scale(radius)
            sphere(r=1, true);

            translate([0, 0, spacing * param[0] + TAB_SPACING * (param[1]+param[3]-1) + radius/2])
            scale(radius)
            sphere(r=1, true);
        }
    }
}

module encoder_mask3(thickness) {
    spacing = (ENCODER_HEIGHT - TAB_SPACING * (4+3+4)) / 6;
    for (i=[2.5:2.5]) {
        translate([0, 0, spacing * 5 + TAB_SPACING * (7+i-1)])
        scale([1, 1, thickness])
        cylinder(r=BODY_RADIUS*1.5, h=1, true);

        translate([0, 0, spacing * 1 + TAB_SPACING * (0+i-1)])
        scale([1, 1, thickness])
        cylinder(r=BODY_RADIUS*1.5, h=1, true);
    }

    for (i=[2:2]) {
        translate([0, 0, spacing * 3 + TAB_SPACING * (4+i-1)])
        scale([1, 1, thickness])
        cylinder(r=BODY_RADIUS*1.5, h=1, true);
    }
}

module encoder() {
    rotate([0, 0, ENCODER_ROTATION])
    difference() {
        // body
        scale([1, 1, ENCODER_HEIGHT - PLAY])
        cylinder(r=ENCODER_RADIUS, h=1, true);

        // cavity
        encoder_cavity();

        // servo axis
        translate([0, 0, ENCODER_HEIGHT - SERVO1_HEIGHT])
        servo1_hull();

        // codes
        spacing = (ENCODER_HEIGHT - TAB_SPACING * (4+3+4)) / 6;
        for (i=[0:9]) {
            top = TABS[0][i];
            mid = TABS[1][i];
            bot = TABS[2][i];

            rotate([0, 0, 90 + ROTATION_STEP*i]) {
                translate([ENCODER_RADIUS, 0, spacing * 5 + TAB_SPACING * (7+top-1)])
                cube([TAB_HSIZE, TAB_HSIZE, TAB_VSIZE], true);

                translate([ENCODER_RADIUS, 0, spacing * 3 + TAB_SPACING * (4+mid-1)])
                cube([TAB_HSIZE, TAB_HSIZE, TAB_VSIZE], true);

                translate([ENCODER_RADIUS, 0, spacing * 1 + TAB_SPACING * (0+bot-1)])
                cube([TAB_HSIZE, TAB_HSIZE, TAB_VSIZE], true);
            }
        }
    }
}

module encoder_cavity() {
    // remove center
    translate([0, 0, -ATOM])
    scale([1, 1, ENCODER_HEIGHT-ENCODER_THICKNESS + ATOM*2])
    cylinder(r=ENCODER_RADIUS-ENCODER_THICKNESS, h=1, true);

    // remove quarter 1
    rotate([0, 0, -ROTATION_STEP*1.5])
    translate([0, -ATOM, -ATOM])
    scale([ENCODER_RADIUS*2, ENCODER_RADIUS*2+ATOM, ENCODER_HEIGHT-ENCODER_THICKNESS+ATOM*2])
    cube(1);

    // remove quarter 2
    rotate([0, 0, -ROTATION_STEP*7.5])
    translate([0, 0, -ATOM])
    scale([ENCODER_RADIUS*2, ENCODER_RADIUS*2, ENCODER_HEIGHT-ENCODER_THICKNESS+ATOM*2])
    cube(1);
}

encoder();

