TH         =   3;
CHAMBER_H1 =  24            -2;
CHAMBER_H2 =   3 +2;
CHAMBER_W2 =  15            -3;
CHAMBER_W3 =  22            -5;
CHAMBER_L  = 160 -10        -10;

W = CHAMBER_W3 + TH;
L = CHAMBER_L + TH;
H = CHAMBER_H1 + CHAMBER_H2 + TH;

ATOM = 0.01;
$fn = 100;

module rail() {
    hull() {
        cube([W, L, 1]);
        translate([0, TH, TH])
        cube([W, CHAMBER_L, ATOM]);
    }

    hull() {
        translate([CHAMBER_W3, TH, 0])
        cube([TH, CHAMBER_L, H]);

        translate([W-1, 0, 0])
        cube([1, L, H]);
    }

    hull() {
        translate([W-CHAMBER_W2-TH, 0, H-1])
        cube([CHAMBER_W2+TH, L, 1]);

        translate([W-CHAMBER_W2-TH, TH, H-TH])
        cube([CHAMBER_W2, CHAMBER_L, ATOM]);
    }

    translate([0, CHAMBER_L, 0])
    cube([W, TH, H]);
}

module screw_hollowing() {
    d1 = 4;
    d2 = 9.7 -2;
    translate([0, 0, -1.7])
    cylinder(d=d2, h=H);
    cylinder(d=d1, h=H*2);
}

module bracket() {
    difference() {
        rail();
        x = CHAMBER_W3-CHAMBER_W2 + CHAMBER_W2/2 + TH/2;
     
        translate([x, 20, 0]) screw_hollowing();
        translate([x, L-20, 0]) screw_hollowing();
        
        // anti-stick
        if (0)
        for (z=[3.5:2:H-3])
        translate([W, L/2, z])
        rotate([0, 45, 0])
        cube([.8, L-TH*2, .8], center=true);
    }
}
//!bracket();

if (0)
intersection() {
rotate([0, 90, 0])
bracket();

cube([H*3, 20, H*3], center=true);
}

rotate([0, 90, 0])
bracket();

translate([-5, 0, 0])
scale([-1, 1, 1])
rotate([0, 90, 0])
bracket();