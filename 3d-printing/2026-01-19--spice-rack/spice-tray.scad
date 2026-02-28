/*
This tray version consists of one long tray per level
- meant to be stacked,
- held together by vertical steel bars,
- needing a large printer.
*/

use <../chamferer.scad>

TRAY_L       = 300;
TRAY_W       =  75;
TRAY_H       = 150;

TRAY_FENCE_H =  40;
TH           =   4;
SCREW_D      =   5.3;

$fn          = $preview ? 10 : 160 / 4;
ATOM         =   0.01;

module base(recess=0) {
    hull() {
        for (x=[TRAY_W/2, TRAY_L - TRAY_W/2])
            translate([x, TRAY_W/2, recess])
            cylinder(d=TRAY_W - recess*2, h=TRAY_H);

        if (!recess)
            translate([recess, TRAY_W/2+recess , recess])
            cube([TRAY_L - recess*2, TRAY_W/2-recess*2, TRAY_H]);
    }

    if (recess) {
        d = TRAY_W * .67;

        // shave front
        hull() for (z=[d/2 + TRAY_FENCE_H, TRAY_H]) {
            translate([0, TRAY_W/2-d/2, z])
            rotate([0, 90, 0])
            cylinder(d=d, h=TRAY_L);

            translate([0, -d/2, z])
            rotate([0, 90, 0])
            cylinder(d=d, h=TRAY_L);
        }

        hull()
        for (z=[d/2 + TRAY_FENCE_H, TRAY_H]) 
        for (x=[d*1.5, TRAY_L - d*1.5]){
            translate([x, 0, z])
            rotate([90, 0, 0])
            cylinder(d=d, h=TRAY_L*2, center=true);
        }
    }
}

module gasket0(ch, h) {
    chamferer(ch, "cylinder", grow=false)
    intersection() {
        translate([0, 0, -TRAY_H + h])
        body();
        cube([TRAY_L, TRAY_W, h]);
    }
}

module gasket(ch, shave, h) {
    chamferer(shave, "cylinder", grow=false)
    difference() {
        gasket0(ch, h);
        translate([0, 0, -h/2])
        gasket0(ch*3, h*2);
    }
}


module body(with_holes=false) {
    difference() {
        base();

        // hollowing
        base(TH);

        // floor holes
        l = (TRAY_L-TRAY_W)/4;
        ch = TH*1.5;
        for (x=[TRAY_W/2, TRAY_L/2-l/2, TRAY_L-TRAY_W/2-l])
            translate([x, TRAY_W/2, -ATOM])
            chamferer(ch, "cylinder", shrink=false, fn=$preview?8:20)
            cube([l, ATOM, TH*2]);

        // screw holes
        pos = 8.1 +.15;
        if (with_holes)
        for (x=[pos, TRAY_L - pos])
            translate([x, TRAY_W - pos, -ATOM]) {
                cylinder(d=SCREW_D, h=TRAY_H*2);
                
                d_ext = SCREW_D*1.7;
                cylinder(d=d_ext, h=SCREW_D);

                translate([0, 0, SCREW_D])
                sphere(d=d_ext);
            }
    }
}

module tray() {
    ch = 1.1 -.16;

    difference() {
        body(true);
        
        // gasket inset
        translate([0, 0, -.1])
        gasket(ch, 0, 1);
    }

    // gasket outset
    translate([0, 0, TRAY_H])
    gasket(ch, .3, .6);
}

tray();
