use <../chamferer.scad>;

W_LEVER      =  12.2;
PLAY         =   0.1;
GAP          =   0.3*2;
W_INNER      = W_LEVER + PLAY*2;
TH           =   2;
W_OUTER      = W_INNER + TH*2;
HEIGHT       =  30;
THICKNESS    =   6;
WALL         =   3;
D            = 102;
SLIT_H       =   17;

CHAM = .5;

ATOM = 0.01;
$fn  = 200;

module body() {
    difference() {

        chamferer(CHAM)
        difference() {
            translate([-W_OUTER/2, -THICKNESS, 0])
            cube([W_OUTER, THICKNESS + WALL, HEIGHT]);

            // slant
            rotate([14.7, 0, 0])
            translate([-W_OUTER*1.25, -WALL-THICKNESS, 0])
            cube([W_OUTER*2, THICKNESS + WALL, HEIGHT]);
        }

        // rail
        translate([-W_INNER/2, -THICKNESS*2, -HEIGHT/2])
        cube([W_INNER, THICKNESS*2, HEIGHT*2]);

        if (0)
        %translate([-W_LEVER/2, -4.5, -HEIGHT/2])
        cube([W_LEVER, 4.5, HEIGHT*2]);

        // curved back
        translate([0, D/2 + WALL/2, -HEIGHT/2])
        cylinder(d=D, h=HEIGHT*2);

        // slits
        for (x=[W_LEVER/2-GAP+PLAY, -W_LEVER/2 - PLAY]) {
            translate([x, -1, HEIGHT-SLIT_H])
            cube([GAP, THICKNESS, SLIT_H+1]);

            translate([x+GAP/2, -ATOM, HEIGHT-SLIT_H])
            rotate([-90, 0, 0])
            cylinder(r=GAP*1.5, h=THICKNESS);
        }
    }
}

module bumps() {
    th = .67;
    th2 = .6*2;
    h = 4;
    
    // grippers
    for (x=[W_INNER/2-th*2, -W_INNER/2-TH]) {
        translate([0, -THICKNESS -th2/4 +ATOM*2, HEIGHT-h])
        hull() {
            w = TH + th*2;
            translate([x, 0, 0])
            chamferer(CHAM)
            cube([w, th2, h]);

            translate([x+w/2, th2/2, -w/2])
            cube([ATOM, ATOM, h]);
        }
    }

    // frictioners
    for (x=[W_INNER/2, -W_INNER/2]) {        
        translate([x, -THICKNESS*.1, 0])
        translate([0, 0, HEIGHT-h*.4])
        scale([1, 1, 3])
        rotate([90, 0, 0])
        cylinder(r=PLAY*2.9, h=THICKNESS*.9);
    }
    
    // bridge
    translate([0, .02, HEIGHT-h*1.75]) {
        chamferer(CHAM)
        difference() {
            dy = .25;
            translate([-W_OUTER/2, -THICKNESS -th2/4, 0])
            //chamferer(CHAM)
            cube([W_OUTER, th2, h]);

            if (0)
            translate([0, -THICKNESS +th2/4 - dy/2, -h/2])
            rotate([0, 0, 90])
            translate([-W_OUTER/2, 0, 0])
            cube([W_OUTER, dy, h*2]);
        }
    }
}

module clip() {
    body();
    bumps();
}

rotate([-90, 0, 0])
clip();