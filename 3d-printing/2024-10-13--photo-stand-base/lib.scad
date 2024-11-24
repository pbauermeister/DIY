
N              = 10+5;
M              =  5;
FACET          = 20;
PROTUDE        =  2.5;
RADIUS         = 45;
H              = FACET * M;
TH             =  0.7;
ARM_WIDTH      = 31;//25;
ARM_THICKNESS  = 17;
WALL           = 0.8;
CLAW_THICKNESS = 17;
CLAW_POS       = 15;
TOLERANCE      = .17*2;

ATOM           =  0.01;

$fn = 100;

module ring(inset=0) {

    d = RADIUS*2*PI / N;

    for(j=[0:M-1]) {
        for (i=[0:N-1]) {
            translate([0, 0, j*FACET])
            rotate([0, 0, 360/N*i])
            translate([RADIUS-inset, 0, FACET/2])
            rotate([0, 90, 0])
            hull() {
                translate([0, 0, -5/2])
                cube([FACET, d+.3, 5], center=true);

                translate([0, 0, PROTUDE])
                cube([ATOM, ATOM, ATOM], center=true);
            }
        }
    }
}

module goblet() {
    difference() {
        ring();
        ring(inset=WALL);
    }

    difference() {
        intersection() {
            hull() ring();
            translate([0, 0, H-TH])
            cylinder(r=60, h=TH);
        }

        translate([0, 0, H]) {
            intersection() {
                cylinder(d=ARM_WIDTH, h=H, center=true);
                cube([ARM_WIDTH*2, ARM_THICKNESS, H], center=true);
            }
        }
    }
}


module base() {
    l = RADIUS*2*.75;
    w_ext = 25;
    w_int = CLAW_THICKNESS;
    th = 2;
    h = 10;

    difference() {        
        translate([-l/2, -w_ext/2, 0])
        cube([l, w_ext, h]);

        translate([-CLAW_POS, -w_int/2, th])
        cube([l, w_int, h]);

        translate([-CLAW_POS - l - 5, -w_int/2, th])
        cube([l, w_int, h]);


    }

    difference() {
        intersection() {
            hull() ring(inset=WALL+TOLERANCE);
            cylinder(r=60, h=th);
        }
        
        cylinder(r=RADIUS*.70, h=th*3, center=true);
    }
}

goblet();

translate([RADIUS*2+5, 0, 0])
base();