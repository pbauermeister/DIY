

$fn = 90;

THICKNESS = sqrt(2);
HEIGHT = 50;
WIDTH = 30 + 6.25;
DEPTH = 15;
N = 5;
WALL_THICKNESS = 0.8;
ATOM = 0.001;
ROT = 45;

WIDTH = 30 -0.7;
N  = 4;
N2 = 5;
WALL_THICKNESS = 0.8;
THICKNESS1 = 4;
THICKNESS2 = 6;
WIDTH = 30  -4;
ROT = 0;

module grid() {
    for (i=[-N:N])
        translate([0, 0, HEIGHT/N*i])
        cube([100,100,THICKNESS], true);

    for (i=[-N:N])
        translate([0, 0, HEIGHT/N*i])
        cube([100,100,THICKNESS], true);
}

module grid() {
    for (i=[-N:N])
        translate([0, 0, HEIGHT/N*i])
        rotate([ROT, 0, ROT])
        cube([100,100,THICKNESS1], true);

    rotate([0, 90, 0])
    for (i=[-N2:N2])
        if(i)
        translate([0, 0, HEIGHT/N2*i])
        rotate([-ROT, 0, ROT])
        cube([100,100,THICKNESS2], true);
}

module rounded(offset, h) {
    cube([WIDTH-DEPTH-offset*0, DEPTH-offset*2, h+ATOM*2], true);

    translate([WIDTH/2-DEPTH/2, 0, 0])
    cylinder(d=DEPTH-offset*2, h=h+ATOM*2, center=true);

    translate([-WIDTH/2+DEPTH/2, 0, 0])
    cylinder(d=DEPTH-offset*2, h=h+ATOM*2, center=true);
}

module box(h) {
    difference() {
        rounded(0, h);
        rounded(WALL_THICKNESS, h+ATOM*2);
    }
}

module all() {
    intersection() {
        grid();
        box(HEIGHT);
    }

    translate([0, 0, -HEIGHT/2]) box(THICKNESS);
    translate([0, 0,  HEIGHT/2]) box(THICKNESS);
}

all();