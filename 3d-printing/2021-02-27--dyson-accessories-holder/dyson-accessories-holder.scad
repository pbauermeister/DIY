$fn = $preview ? 12 : 90;
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
ANGLE = 30;
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

module unit(outer) {
    if (outer) {
        shape(WALL, HEIGHT + WALL);
    }
    else {
        // screw hole
        cylinder(d=SCREW_DIAMETER, h=HEIGHT);

        // main hole
        translate([0, 0, WALL])
        difference() {
            cavity_extra() shape(0, HEIGHT);
            cylinder(d=SCREW_DIAMETER+WALL*2, h=WALL);
        }

        // side hole
        translate([0, -DIAMETER/4, WALL+HEIGHT-HOLE_DIAMETER/2 - HOLE_SHIFT])
        rotate([90, 0, 0])
        cylinder(d=HOLE_DIAMETER, h=DIAMETER);

        // bottom
        rotate([0, 0, 45])        
        translate([0, 0, LAYER])
        difference() {
            translate([0, 0, -LAYER])
            cylinder(d=DIAMETER, h=LAYER*2);
            rotate([0, 0, -ANGLE])
            cube([SUPPORT, DIAMETER, 4*LAYER], center=true);
            rotate([0, 0, -ANGLE])
            cube([DIAMETER, SUPPORT, 4*LAYER], center=true);
            
            cylinder(d=SCREW_DIAMETER+WALL, h=4*LAYER, center=true);
        }
        
    }
}

module brace() {
    w = DIAMETER * .66;
    for (i=[0:N-2]) {
        translate([i*DISTANCE, -w/2, LAYER])
        cube([DISTANCE, w, HEIGHT+WALL-LAYER]);    
        
        translate([i*DISTANCE + DISTANCE/2, -w/2, 0])
        cube([SUPPORT, w, LAYER]);

        translate([i*DISTANCE, -w/2, 0])
        cube([DISTANCE, SUPPORT, LAYER]);

        translate([i*DISTANCE, w/2-SUPPORT, 0])
        cube([DISTANCE, SUPPORT, LAYER]);
    }
}

module outer() {
    for (i=[0:N-1]) {
        translate([DISTANCE*i, 0, 0])
        rotate([0, 0, ANGLE])
        unit(true);
    }
    brace();
}

module inner() {
    for (i=[0:N-1]) {
        translate([DISTANCE*i, 0, 0])
        rotate([0, 0, ANGLE])
        unit(false);
    }    
}

difference() {
    outer();
    inner();
    
    //cube(100);
}
