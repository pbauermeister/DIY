
TOLERANCE = .17;

INNER_DIAMETER = 11 + TOLERANCE*2;
THICKNESS = .5;
HANDLE_LENGTH_EXTRA = 7;
HANDLE_LENGTH = 25 + 3 + HANDLE_LENGTH_EXTRA;

BLADE_LENGTH = 30;
OUTER_DIAMETER = INNER_DIAMETER+THICKNESS*2;
TOP_THICKNESS = 10;
BLADE_WIDTH = 14;
BLADE_THICKNESS = 1.5;

ATOM = .01;
$fn = 60;

module cap() {
    difference() {
        union() {
            cylinder(d=OUTER_DIAMETER, h=HANDLE_LENGTH+BLADE_LENGTH);
            translate([0, 0, BLADE_LENGTH/2+HANDLE_LENGTH/2])
            cube([BLADE_THICKNESS+2, BLADE_WIDTH+1, BLADE_LENGTH+HANDLE_LENGTH], center=true);
            
            for (y=[0:2:BLADE_LENGTH]) {
                translate([0, 0, y]) cylinder(d=OUTER_DIAMETER+.7, h=1);
                translate([0, 0, y+1]) cylinder(d=OUTER_DIAMETER, h=1);
            }
        }

        translate([0, 0, THICKNESS])
        cylinder(d=INNER_DIAMETER, h=HANDLE_LENGTH+BLADE_LENGTH - HANDLE_LENGTH_EXTRA);

        translate([0, 0, THICKNESS])
        cylinder(d=INNER_DIAMETER-TOLERANCE*2, h=HANDLE_LENGTH+BLADE_LENGTH);

        translate([-BLADE_THICKNESS/2, -BLADE_WIDTH/2, -ATOM])
        cube([BLADE_THICKNESS, BLADE_WIDTH, BLADE_LENGTH+HANDLE_LENGTH+ATOM*2]);
        
        //if($preview) translate([0, 0, -ATOM]) cube(1000);
    }
}

cap();