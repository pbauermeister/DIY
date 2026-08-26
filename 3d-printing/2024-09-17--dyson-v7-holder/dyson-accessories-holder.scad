/*
Holder for Dyson v7 accessories.
*/

$fn = $preview ? 12 : 180;
ATOM = 0.1;
PLAY = .6;
TOLERANCE = 0.3;
LAYER = 0.15 +0.01;

WALL = 2.5;
DIAMETER = 35 + PLAY*2;
HEIGHT         = 28          + .5;
SLIT_THICKNESS =  3          + .1;
SLIT_LENGTH    =  3          + .2;
HOLE_DIAMETER  = 14.3        + .2;
HOLE_SHIFT     =  3.5;

SUPPORT = 1.5;

DISTANCE = 60;
ANGLE = 30 * 0;
N = 3;

SCREW_DIAMETER = 3.5;

module cavity_extra() {
    if ($preview) {
        translate([0, 0, -ATOM])
        scale([1, 1, (HEIGHT+ATOM*2)/HEIGHT])
        children();
    }
    else children();
}

module shape(wall, height) {
    cylinder(d=DIAMETER + wall*2, h=height);

    translate([0, 0, height/2])
    cube([DIAMETER+SLIT_LENGTH*2 + wall*2, SLIT_THICKNESS + wall*2, height],
         center=true);
}

module screw_ring() {
    cylinder(d=SCREW_DIAMETER+WALL*2);
}

module unit(outer, two_holes=true) {
    if (outer) {
        shape(WALL, HEIGHT + WALL);
    }
    else {
        // screw hole
        cylinder(d=SCREW_DIAMETER, h=HEIGHT);

        // main hole
        translate([0, 0, WALL*.4])
        difference() {
            cavity_extra() shape(0, HEIGHT*2);
            cylinder(d=SCREW_DIAMETER+WALL*2, h=WALL);
        }

        // side hole
        translate([0, 0, WALL+HEIGHT-HOLE_DIAMETER/2 - HOLE_SHIFT])
        rotate([-90, 0, 0])
        cylinder(d=HOLE_DIAMETER, h=DIAMETER*3, center=two_holes);
    }
}

module brace(n=N) {
    w = DIAMETER * .66;
    if(n>=2)
    for (i=[0:n-2]) {
        translate([i*DISTANCE, -w/2, 0])
        cube([DISTANCE, w, HEIGHT+WALL]);    
    }
}

module outer(n=N) {
    for (i=[0:n-1]) {
        translate([DISTANCE*i, 0, 0])
        rotate([0, 0, ANGLE])
        unit(true);
    }
    brace(n);
}

module inner(n=N) {
    for (i=[0:n-1]) {
        translate([DISTANCE*i, 0, 0])
        rotate([0, 0, ANGLE])
        unit(false);
    }    
}

module holder(n=N) {
    difference() {
        outer(n);
        inner(n);
        //cube(100);
    }
}

holder(2);