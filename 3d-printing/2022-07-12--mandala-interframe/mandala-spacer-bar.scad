FRAME_THICKNESS =   8/2; // to 9

ATOM = 0.01;

HOLE_POSITION = 20+4;
HOLE_DIAMETER = 3;
GUIDE_SIZE = HOLE_POSITION + 3; //28 +4;
HEIGHT = 3;

LENGTH = 155;

THICKNESS = .5;
CHAMFER = 1;

$fn= 90;

module piece() {
    intersection() {
        difference() {
            translate([0, ATOM/2, 0])
            cube([GUIDE_SIZE, LENGTH-ATOM, HEIGHT]);

            hull() {
                translate([FRAME_THICKNESS, 0, THICKNESS])
                cube([GUIDE_SIZE, LENGTH, HEIGHT]);

                translate([FRAME_THICKNESS-HEIGHT/3, 0, HEIGHT])
                cube([GUIDE_SIZE, LENGTH, HEIGHT]);
            }

            translate([FRAME_THICKNESS+2, 0, -ATOM])
            cube([GUIDE_SIZE, LENGTH, HEIGHT]);
        }

        hull() {
            translate([0, 0, CHAMFER])
            cube([GUIDE_SIZE+CHAMFER, LENGTH, HEIGHT]);
            translate([CHAMFER, 0, 0])
            cube([GUIDE_SIZE, LENGTH, HEIGHT]);
        }
    }
}

for (x=[0:3])
    translate([x*FRAME_THICKNESS*2 , 0, 0])
    piece();