/*
This tray version consists of two halves
- not meant to be stacked,
- but to be held by a perforated peg board oriented vertically:
  https://www.ikea.com/ch/fr/p/skadis-panneau-perfore-blanc-10321618/
- each tray consists of two halves,
- there is no stacking nor gaskets.
*/

use <../chamferer.scad>

TRAY_L                  = 300;
TRAY_W                  =  75;
TRAY_H                  =  60 -15;
TRAY_H2                 =  35 -10;

TRAY_FENCE_H            =  40;
TH                      =   3;

CH                      =   1.5/2;
BOTTOM_STRIPES_MARGIN   =   3;

JOINT_L                 =   5;
JOINT_PLAY              =   0.15;

R                       = 10;

WITH_FLOOR_HOLES        = false;

$fn                     = $preview ? 14 : 160;
ATOM                    =   0.01;

module base(recess=0) {
    chamferer($preview ? 0 : (recess ? CH : 0))    
    difference() {
        hull() {
            /*
            for (x=[TRAY_W/2, TRAY_L - TRAY_W/2])
                translate([x, TRAY_W/2, recess])
                cylinder(d=TRAY_W - recess*2, h=TRAY_H);
            */

            r0 = R; //TRAY_W/4;
            r = r0 - recess;
            for (x=[r0, TRAY_L - r0])
                translate([x, r0, recess])
                cylinder(r=r, h=TRAY_H, $fn=$preview?$fn*2:$fn);

            // back cubic reinforecment
            translate([recess, TRAY_W/2+recess , recess])
            cube([TRAY_L - recess*2, TRAY_W/2-recess*2, TRAY_H]);
        }
    }

    // front shaving
    if (recess) {
        // shave front
        d = TRAY_W * .67;
        hull() for (z=[TRAY_H2, TRAY_H]) {
            translate([0, TRAY_W*1 - TH - d*.5, z + d/2])
            rotate([0, 90, 0])
            cylinder(d=d, h=TRAY_L*3, center=true);

            translate([0, -d/2, z + d/2])
            rotate([0, 90, 0])
            cylinder(d=d, h=TRAY_L*3, center=true);
        }
    }
}

FLOOR_HOLE_DIAMETER = TRAY_W * .4;

module body() {
    difference() {
        base();

        // hollowing
        base(TH);

        // floor hole
        ch = FLOOR_HOLE_DIAMETER / 2.5;
        l = TRAY_L/2 - TRAY_W;

        if (WITH_FLOOR_HOLES) for (x=[TRAY_L*.25, TRAY_L*.75]) {
            translate([x-l/2, TRAY_W/2, -ATOM])
            chamferer(ch, "cylinder", shrink=false, fn=$preview?8:50)
            cube([l, ATOM, TH*2]);
        }
    }
}

module divider(shrink) {
    translate([-JOINT_L/2, 0, 0]) {
        rotate([0, 90, 0]) cylinder(r=TRAY_L, h=TRAY_L, center=true);

        // joint lip
        d = shrink ? -JOINT_PLAY : JOINT_PLAY;
        translate([JOINT_L, TH/2 - d, TH/2 - d])
        cube([TRAY_L/2, TRAY_W - TH + d*2, TRAY_H*1.1]);
    }
}

module mk_bottom() {
    difference() {
        chamferer($preview ? 0 : CH)
        children();

        // bottom strips
        margin = BOTTOM_STRIPES_MARGIN;
        if (!$preview)
        translate([0, 0, -ATOM])
        intersection() {
            chamferer(margin, "cylinder", grow=false) children();
            dy = TRAY_W/30;
            union() for (y=[0:dy:TRAY_W])
                translate([0, y+dy/4, 0])
                rotate([45, 0, 0])
                cube([TRAY_L*3, 1, 1], center=true);
        }
    }
}

module left_part() {
    intersection() {
        //mk_bottom()
        body();
        divider(true);
    }
}

module right_part() {
    difference() {
        //mk_bottom()
        body();
        divider(false);
    }
}


module scene() {
    rotate([0, -90, 0]) {
        translate([0, -TRAY_W, 1])
        left_part();

        translate([0, 0, -1]) rotate([-180, 0, 0]) translate([TRAY_L, TRAY_W, 0]) rotate([0, 0, 180])
        right_part();
    }

    // pads
    for(kx=[-1, 0, 1])
        translate([kx*TRAY_H, 0, 0]) 
        cylinder(d=25, h=.3);
}

difference() {
    scene();
    cylinder(d=TRAY_W*5, h=TRAY_L - 20, center=true);
}