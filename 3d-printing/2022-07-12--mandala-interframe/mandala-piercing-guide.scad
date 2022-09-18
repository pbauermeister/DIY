FRAME_THICKNESS =   8/2; // to 9

ATOM = 0.01;

HOLE_POSITION = 20+4;
HOLE_DIAMETER = 2;
GUIDE_SIZE = 28 +4;

$fn= 90;

module piece() {
    difference() {
        cube([GUIDE_SIZE, GUIDE_SIZE, 10]);

        translate([FRAME_THICKNESS, FRAME_THICKNESS, 5])
        cube([GUIDE_SIZE, GUIDE_SIZE, 10]);
        
        translate([HOLE_POSITION, HOLE_POSITION, 0])
        cylinder(d=HOLE_DIAMETER, h=40, center=true);
    }
}

for (x=[-1, 1])
    for (y=[-1, 1])
        translate([x*GUIDE_SIZE*.6, y*GUIDE_SIZE*.6, 0])
        piece();