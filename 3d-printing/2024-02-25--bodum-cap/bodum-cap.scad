
DIAMETER          = 80;
H0                = 25;
H1                = 13;
TANGENT           = 30;
WALL_THICKNESS    =  3;
PATTERN_THICKNESS =  0.5;
AXIS_DIAMETER     =  5;

ATOM = .01;

$fn = 200 / 1;

R = DIAMETER/2 / cos(90-TANGENT);
H = DIAMETER/2 * tan(90-TANGENT);
echo(R);
echo(H);

module body(r, dr=0) {
    intersection() {
        translate([0, 0, -H])
        sphere(r=r-dr);
        
        if (dr==0)
            cylinder(d=DIAMETER, h=r, center=true);
    }
}

module shell(dr=0, th=1) {
    difference() {
        body(R-dr);
        body(R-dr, th);
    }
}

module arm(d, th) {
    translate([0, 0, -1])
    intersection() {
        translate([d/2 - th/2, 0, 0])
        difference() {
            cylinder(d=d, h=DIAMETER);
            translate([0, 0, -ATOM])
            cylinder(d=d-th*2, h=DIAMETER+ATOM*2);
        }
        translate([-d/2, 0, 0])
        cube([d, d, DIAMETER]);
    }
}

module pattern() {
    n = 20 -3;
    //n = 2;
    r = 80 -3;
    difference() {
        shell();
        for (i=[0:n-1]) {
            rotate([0, 0, 360/n*i])
            arm(r, 1);
        }
        for (i=[0:n-1]) {
            rotate([0, 0, 360/n*i])
            scale([-1, 1, 1])
            arm(r, 1);
        }
    }
}

module crown() {
    translate([0, 0, -H1])
    difference() {
        cylinder(d=DIAMETER, h=H1 -1);

        //translate([0, 0, -ATOM])
        //cylinder(d=DIAMETER-WALL_THICKNESS*2, h=H1+ATOM*2);
    }
}

module all() {
    difference() {
        union() {
            pattern();

            translate([0, 0, PATTERN_THICKNESS*8 - .1])
            hull() shell(PATTERN_THICKNESS*8, WALL_THICKNESS);

            crown();
        }

        cylinder(d=AXIS_DIAMETER, h=25*2, center=true);

        translate([0, 0, -DIAMETER/2 +DIAMETER-H -WALL_THICKNESS])
        cylinder(d2=0, d1=DIAMETER*1.5, h=DIAMETER/2);
    }
}


intersection() {
    all();
//    translate([0, 0, -DIAMETER/2]) cube(DIAMETER);
}