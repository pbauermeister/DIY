WIDTH = 20;
HEIGHT = 40;
THICKNESS = 3.5;

RAIL_OPENING = 6.5 -.2;
RAIL_THICKNESS = 2.2;
MARGIN = .33;
STEP = HEIGHT/5;
BOLT = 10.2;
DIAMETER = 4.8;

ARM_LENGTH = 50;
TOLERANCE = .17;
ATOM = .001;
R = .5;
$fn = $preview ? 5 : 30;

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
        
        th = .25;
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

module arm() {
    D = 5+THICKNESS;
    difference() {
        intersection() {
            minkowski() {
                difference() {
                    translate([WIDTH/2-THICKNESS, -THICKNESS/2, 0])
                    cube([ARM_LENGTH-WIDTH/2 + THICKNESS, TOLERANCE, HEIGHT]);

                    hull() {
                        translate([ARM_LENGTH-D*.75, 0, HEIGHT/4])
                        rotate([90, 0, 0])
                        cylinder(d=D, h=THICKNESS*75, center=true);

                        translate([ARM_LENGTH-D*.75, 0, HEIGHT*.75])
                        rotate([90, 0, 0])
                        cylinder(d=D, h=THICKNESS*5, center=true);
                    }

                    translate([ARM_LENGTH-D, -THICKNESS*2, HEIGHT*.3 - 1.5])
                    cube([D*2, THICKNESS*3, 3+THICKNESS]);
                }
                sphere(d=THICKNESS, $fn=18);
            }
            translate([WIDTH/2, -THICKNESS, 0])
            cube([ARM_LENGTH-WIDTH/2, THICKNESS, HEIGHT]);
        }

        translate([WIDTH/2, -THICKNESS*2, HEIGHT/4 - D/2])
        cube([ARM_LENGTH/2        <<<<<<<<<<<<<<<<<<<<<<<<<<< , THICKNESS * 3, HEIGHT/2 + D]);
    }
}

//rotate([90, 0, 0])
piece();
arm();