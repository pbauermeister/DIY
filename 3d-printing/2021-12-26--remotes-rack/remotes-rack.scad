
WIDTH     = 54 + 3;
LENGTH    = 200;
THICKNESS = 1.5*2;
THINNESS  = 1.5;
H         = 32;
R         = WIDTH * 1.1;
NB        = 5;
BASE      = 10;

h = R - sqrt(R*R - WIDTH*WIDTH/4);

ATOM = 0.01;
ATOM2 = ATOM*2;

$fn=360;

module bed() {
    intersection() {
        translate([WIDTH/2, -ATOM, R])
        rotate([270, 0, 0])
        difference() {
            RR = R*1.33;
            translate([0, -(RR-R), 0])
            cylinder(r=RR, h=LENGTH + ATOM2);
            cylinder(r=R-THINNESS, h=LENGTH+ATOM2);
        }
        
        cube([WIDTH, LENGTH, 9]);
    }
}

module beds() {
    difference() {
        for (i=[0:NB-1]) {
            translate([0, 0, H*i])
            bed();
        }
    }
}

module backside() {
    translate([0, LENGTH-THICKNESS, -(THICKNESS-THINNESS)]) {
        cube([WIDTH, THICKNESS, NB*H - H + h]);

        translate([0, 0, NB*H-H + h])
        intersection() {
            cube([WIDTH, THICKNESS, H]);
            translate([WIDTH/2, -THICKNESS, -R+h + THICKNESS])
            rotate([270, 0, 0])
            cylinder(r=R, h=THICKNESS*3);

        }
    }
}

module leftside() {
    difference() {
        cube([THICKNESS, LENGTH, NB*H - H + h]);
    }
}

module rightside() {
    translate([WIDTH-THICKNESS, 0, 0])
    cube([THICKNESS, LENGTH, h]);
}

module base() {
    translate([0, 0, -BASE - (THICKNESS-THINNESS)])
    difference() {
        cube([WIDTH, LENGTH, BASE+h]);
        
        translate([WIDTH/2, -THICKNESS, +R + THICKNESS+BASE])
        rotate([270, 0, 0])
        cylinder(r=R, h=LENGTH+THICKNESS*3);

        hull() {
            translate([WIDTH/2, WIDTH/2, -BASE])
            cylinder(d=WIDTH-THICKNESS*2, h=BASE*3);
            translate([WIDTH/2, LENGTH-WIDTH/2, -BASE])
            cylinder(d=WIDTH-THICKNESS*2, h=BASE*3);
        }
    }
}

module all() {
    intersection() {
        union() {
            beds();
            backside();
            leftside();
            rightside();
            base();
        }
        
        union() {
            translate([WIDTH/2, R, -NB*H]) cylinder(r=R, h=NB*H*2);
            translate([-WIDTH/2, R, -NB*H]) cube([WIDTH*2, LENGTH, NB*H*2]);
        }
    }
}

translate([0, 0, LENGTH]) rotate([270, 0, 0])
all();
