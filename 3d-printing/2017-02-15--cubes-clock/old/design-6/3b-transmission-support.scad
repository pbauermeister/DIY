/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

include <definitions.scad>
use <1-encoder.scad>
use <3-transmission.scad>
use <4-bottom.scad>

module transmission_support() {
    space = 2;
    thickness = 1;
    d1 = TRANSMISSION_RADIUS_OUTER*2 + space*2;
    d2 = TRANSMISSION_RADIUS_OUTER*2 + space*2 + thickness*2;
    echo(d2);

    height = BODY_HEIGHT * 0.83;

    // frame
    translate([0, 0, -BOTTOM_WHEELS_THICKNESS])
    scale([1, 1, height])
    difference() {
        scale([d2, d2, 1])
        translate([0, 0, 0.5])
        cube(1, true);

        // inner space
        scale([d1, d1, 1.01])
        translate([0, 0, 0.5])
        cube([1, 1, 1], true);

        // side opening
        translate([0, -thickness-ATOM, 0])
        scale([d1*2, d1, 1.01])
        translate([0, 0, 0.5])
        cube(1, true);
    }

    // bridges
    intersection() {
        scale([1, 1, height])
        translate([0, d1/4+thickness/2, 0])
        scale([1, d1/2, 1])
        translate([0, 0, 0.5])
        cube(1, true);
        
        encoder_mask3(0.6);
    }
    
    // leg
    translate([0, 0, -BOTTOM_WHEELS_THICKNESS])
    scale([1, 1, height])
    translate([0, d1/4+thickness/2 + d1/2, 0])
    scale([1, d1/2, 1])
    translate([0, 0, 0.5])
    cube(1, true);
 
}

import("3-transmission.stl");
transmission_support();


dist = -BODY_RADIUS + TRANSMISSION_RADIUS_OUTER - TRANSMISSION_RADIAL_SHIFT;
translate([0, -dist, 0])
translate([0, 0, -BOTTOM_WHEELS_THICKNESS])
bottom_transmission_wheel();