PIN_DIAMETER = 7 +1 -1 + .2;
PIN_LENGTH = 12;

WIDTH = 16;

GAP = 1.5;
CABLE_DIAMETER = 5;
SLIT_THICKNESS = .7;

TOLERANCE = .17;
THICKNESS = 4;
ATOM = .01;

$fn = 90;

module cable() {
    translate([CABLE_DIAMETER/2 + PIN_DIAMETER/2 + GAP, 0, CABLE_DIAMETER/2])
    rotate([90, 0, 0])
    cylinder(d=CABLE_DIAMETER, h=30, center=true);
}

SCREW_HEAD_DIAMETER = 5.5 + .2;
SCREW_HEAD_THICKNESS = 2;
SCREW_DIAMETER = 3;
SCREW_LENGTH = 9;

module screw_cavity() {
    cylinder(d=SCREW_DIAMETER - TOLERANCE*2, h=SCREW_LENGTH+1);
    cylinder(d=SCREW_DIAMETER + TOLERANCE*2, h=5);

    D = SCREW_HEAD_DIAMETER + 1.5;

    translate([0, 0, -THICKNESS*2+ATOM])
    cylinder(d=D, h=THICKNESS*2);

    cylinder(d1=D, d2=0, h=D/4);
}

module screw() {
    cylinder(d=SCREW_DIAMETER, h=SCREW_LENGTH);

    translate([0, 0, -SCREW_HEAD_THICKNESS])
    cylinder(d=SCREW_HEAD_DIAMETER, h=SCREW_HEAD_THICKNESS);
}


module bracket0() {
    %cable();

    difference() {
        hull() {
            dh = PIN_DIAMETER/4;

            cylinder(d=PIN_DIAMETER, h=ATOM);

            cylinder(d=PIN_DIAMETER, h=PIN_LENGTH-dh*.5);

            cylinder(d=PIN_DIAMETER-dh, h=PIN_LENGTH);
        }
        translate([-PIN_DIAMETER, -SLIT_THICKNESS/2, THICKNESS/2])
        cube([PIN_DIAMETER*2, SLIT_THICKNESS, PIN_LENGTH]);
    }

    hull() {
        translate([0, 0, -THICKNESS])
        cylinder(d=WIDTH, h=THICKNESS);

        translate([0, -WIDTH/2, -THICKNESS])
        cube([PIN_DIAMETER/2+GAP+CABLE_DIAMETER+THICKNESS, WIDTH, THICKNESS]);
    }


    difference() {
        union() {
            translate([CABLE_DIAMETER/2 + PIN_DIAMETER/2 + GAP, 0, CABLE_DIAMETER/2])
            
            rotate([90, 0, 0])
            cylinder(d=CABLE_DIAMETER+THICKNESS*2, h=WIDTH, center=true);

            translate([0, -WIDTH/2, 0])
            cube([PIN_DIAMETER/2+GAP+CABLE_DIAMETER+THICKNESS, WIDTH, CABLE_DIAMETER/2]);

        }
        cable();

        l1 = PIN_DIAMETER/2+GAP+CABLE_DIAMETER/2;
        l2 = PIN_DIAMETER/2+CABLE_DIAMETER;
        l = (l1+l2)/2;
        translate([-ATOM, -WIDTH/2 - ATOM, 0])
        cube([l, WIDTH + ATOM*2, CABLE_DIAMETER+THICKNESS]);
    }
}

module bracket() {
    difference() {
        bracket0();
        translate([0, 0, -THICKNESS+2.2]) {
            screw_cavity();
            %screw();
        }
        if ($preview) translate([-200, 0, -10]) cube(200);
    }
}

for (y=[0:3])
   translate([0, y * (WIDTH+5), 0])
   bracket();