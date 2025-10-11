/* Raisers for shelf tabs */

// raising
TH   =  5;

// Tab size
H    = 10;
W1   =  9;
W2   =  7;
L    = 13.5;
WALL =  1.5;

// pin
PX   =  4;
D    = 2-1;

ATOM = 0.01;

module shape(xtra=0, h=1) {
    w1 = W1 + xtra*2;
    w2 = W2 + xtra*2;
    hull() {
        translate([0, -w1/2, 0])
        cube([ATOM, w1, h]);

        translate([L+xtra, -w2/2, 0])
        cube([ATOM, w2, h]);
    }
}

module raiser() {
    difference() {
        shape(xtra=WALL, h=H);
        translate([-ATOM, 0, TH])
        shape(xtra=0, h=H);
    }

%    translate([PX, 0, 0])
    cylinder(d=D, h=TH + .5, $fn=20);
}

for (i=[0:3])
    rotate([0, 0, 90*i])
    translate([W1/2 + WALL + .17, 0, 0])
    raiser();
