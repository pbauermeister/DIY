

THICKNESS = 2;
LENGTH = 30;
HEIGHT = 25;
ATOM = 0.001;

difference() {
    translate([-LENGTH/2, 0, 0])
    cube([LENGTH, THICKNESS, HEIGHT]);

    th2 = THICKNESS*.9;
    for (i=[-3:3]) {
        translate([th2*i*1.5 -th2/4+th2/4*1.5, th2/2.5, -ATOM])
        cube([th2*.25, THICKNESS, HEIGHT + ATOM*2]);
    }

    for (i=[-3:3]) {
        translate([th2*i*1.5 -th2/4-th2/4*1.5, -th2/2.5, -ATOM])
        cube([th2*.25, THICKNESS, HEIGHT + ATOM*2]);
    }
}