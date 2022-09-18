WIDTH = 20;
HEIGHT = 40;
THICKNESS = 5;

RAIL_OPENING = 6.5 -.2;
RAIL_THICKNESS = 2.2;
MARGIN = .33;
STEP = HEIGHT/5;
BOLT = 10.2;
DIAMETER = 4.8;
ATOM = .001;
R = .5;
$fn = 30;

    module piece() {
    difference() {
        union() {
            translate([-WIDTH/2, -THICKNESS, 0])
            cube([WIDTH, THICKNESS, HEIGHT]);
            hull() {
                translate([-RAIL_OPENING/2, 0, 0])
                cube([RAIL_OPENING, RAIL_THICKNESS*2, HEIGHT]);

                translate([-RAIL_OPENING/2-MARGIN, RAIL_THICKNESS*1.5, 0])
                cube([RAIL_OPENING + MARGIN*2, ATOM, HEIGHT]);
            }
        }
        
        hull() {
            translate([0, R/2, -ATOM/2])
            cylinder(r=R, h=HEIGHT+ATOM);

            translate([0, RAIL_THICKNESS*2.5, -ATOM/2])
            cylinder(r=R*2, h=HEIGHT+ATOM, $fn=30);
        }

        translate([RAIL_OPENING/2+R/4, R/4, -ATOM/2])
        cylinder(r=R, h=HEIGHT+ATOM);

        translate([-RAIL_OPENING/2-R/4, R/4, -ATOM/2])
        cylinder(r=R, h=HEIGHT+ATOM);
        
        th = .5;
        dz = HEIGHT/4 - BOLT/4;
        translate([-WIDTH/2, 0, dz-th/2]) cube([WIDTH, RAIL_THICKNESS*3, th]);
        translate([-WIDTH/2, 0, HEIGHT-dz-th/2]) cube([WIDTH, RAIL_THICKNESS*3, th]);
        
        translate([-WIDTH/2, 0, HEIGHT/2 - BOLT/2])
        cube([WIDTH, RAIL_THICKNESS*3, BOLT]);

        translate([0, THICKNESS, HEIGHT/2])
        rotate([90, 0, 0])
        cylinder(d=DIAMETER, h=THICKNESS*3);
    }
}

//rotate([90, 0, 0])
piece();