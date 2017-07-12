/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

include <definitions.scad>
use <1-encoder.scad>
use <3-transmission.scad>

module transmission_support() {
    space = 2;
    thickness = 1;
    d1 = TRANSMISSION_RADIUS_OUTER*2 + space*2;
    d2 = TRANSMISSION_RADIUS_OUTER*2 + space*2 + thickness*2;

    scale([1, 1, BODY_HEIGHT])
    difference() {
        scale([d2, d2, 1])
        translate([0, 0, 0.5])
        cube(1, true);

        scale([d1, d1, 1])
        translate([0, 0, 0.5])
        cube(1, true);
    }
    intersection() {
        scale([1, 1, BODY_HEIGHT])
        translate([0, d1/4+thickness/2, 0])
        scale([1, d1/2, 1])
        translate([0, 0, 0.5])
        cube(1, true);
        encoder_mask3(0.6);
    }
}

import("3-transmission.stl");
transmission_support();

