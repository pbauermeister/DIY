/*
 * Cover for front radar of VW Polo.
 */

use <../chamferer.scad>

THICKNESS   = 4;
RADIUS      = 7.5; // 12; // 6;
fn          = $preview? 16 : 50;

module footprint(h) {
    linear_extrude(h)
    translate([0, -246, 0])
    import("radar-cover-4.dxf");
}

module plate0(r=RADIUS, h=THICKNESS) {
    chamferer(r, "cylinder", fn=fn) footprint(h);
}

module plate(r=RADIUS, h=THICKNESS) {
    // sharp corners
    difference() {
        plate0(r=RADIUS-1-1.5, h=THICKNESS);
        translate([59, 30-4-3, 0])
        cylinder(d=90-2, h=THICKNESS*3, center=true);
    }
    // dull corners
    plate0(r=RADIUS+5, h=THICKNESS);
}

difference() {
    plate(r=RADIUS);

    // hollowing
    translate([0, 0, .4])
    chamferer(2 - .5, "cylinder", fn=fn, shrink=true, grow=false)
    plate();
}

translate([51, 6, 0])
cube([5, 2, 1]);