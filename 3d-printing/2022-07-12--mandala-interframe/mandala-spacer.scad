FRAME_THICKNESS =   8/2; // to 9

ATOM = 0.01;

HOLE_POSITION = 20+4;
HOLE_DIAMETER = 3;
GUIDE_SIZE = HOLE_POSITION + 3; //28 +4;
HEIGHT = 3;
THICKNESS = .5;
CHAMFER = 1;

$fn= 90;

module piece() {
    intersection() {
        difference() {
            cube([GUIDE_SIZE, GUIDE_SIZE, HEIGHT]);

            hull() {
                translate([FRAME_THICKNESS, FRAME_THICKNESS, THICKNESS])
                cube([GUIDE_SIZE, GUIDE_SIZE, HEIGHT]);

                translate([FRAME_THICKNESS-HEIGHT/3, FRAME_THICKNESS-HEIGHT/3, HEIGHT])
                cube([GUIDE_SIZE, GUIDE_SIZE, HEIGHT]);
            }
            
            translate([HOLE_POSITION, HOLE_POSITION, 0])
            cylinder(d=HOLE_DIAMETER, h=HEIGHT*3, center=true);
        }

        hull() {
            translate([0, 0, CHAMFER])
            cube([GUIDE_SIZE+CHAMFER, GUIDE_SIZE+CHAMFER, HEIGHT]);
            translate([CHAMFER, CHAMFER, 0])
            cube([GUIDE_SIZE, GUIDE_SIZE, HEIGHT]);
        }
    }
}

for (x=[-1, 1])
    for (y=[-1, 1])
        translate([x*GUIDE_SIZE*.6, y*GUIDE_SIZE*.6, 0])
        piece();