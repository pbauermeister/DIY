

$fn = 90;
HEIGHT = 6;
DEPTH = 15;
ATOM = 0.001;
WALL_THICKNESS = 1.2;
WIDTH = 28;
SPACING = 5;

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

for (i=[0:2])
    for (j=[0:2])
        translate([i*(WIDTH+SPACING), j*(DEPTH+SPACING), 0])
        box(HEIGHT);
