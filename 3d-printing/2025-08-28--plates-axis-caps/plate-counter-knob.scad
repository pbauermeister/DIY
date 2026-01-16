use <../chamferer.scad>

DIAMETER_1 = 27;
DIAMETER_2 = 57;
DIAMETER_3 = DIAMETER_2 + 3;
WALL       =  1.6;
DEPTH      =  5;
ATOM       =  0.01;

$fn = $preview ? 30 : 200;

module rod() {
    difference() {
        chamferer(2, "cone-down")
        cylinder(d=DIAMETER_3, h=DEPTH+WALL);

        // cross
        intersection() {
            translate([0, 0, WALL])
            cylinder(d=DIAMETER_2, h=DEPTH+WALL);

            l = DIAMETER_3;
            w = DIAMETER_1 / sqrt(2) *.48;
            d = .5;
            union() for (a=[0 , 90, 180, 270])
                rotate([0, 0, a])
                translate([d, d, WALL])
                cube(DIAMETER_3);
        }

        // central hole
        translate([0, 0, WALL])
        cylinder(d1=DIAMETER_1, d2=DIAMETER_1+1.5, h=DEPTH*2);

        //%cylinder(d=DIAMETER_1, h=DEPTH*10);
    }
    translate([0, 0, -ATOM])
    cylinder(d=DIAMETER_1, h=DEPTH*10);
}

D      = 120.0;
HOLE_D =  27.6;
CAP_D  =  60.2;
LIP_TH =   9.5;
LIP_D  =  85.0; 
H      = DEPTH*3.75;

if ($preview) %rod();

module knob() {
    difference() {
        chamferer($preview ? 0 : 4, fn=12) difference() {
            cylinder(d=D, h=H);

            // grippers
            for (a=[0 : 360/6 : 360])
                rotate([0, 0, a])
                translate([D*.925, 0, 0])
                cylinder(d=D, h=H*3, center=true);

            // plate lip
            translate([0, 0, H-LIP_TH])
            chamferer(6)
            cylinder(d=LIP_D, h=H*2);
        }

        // axis
        translate([0, 0, -ATOM])
        cylinder(d=HOLE_D, h=DEPTH*10);

        // cap
        cylinder(d=CAP_D, h=6.6+.1);
    }
}

module cut1() {
intersection() {
    knob();

    // cross-cut
    if ($preview && 1) translate([0, -500, -500]) cube(1000);

    if (1)
    union() {
        cube([1, 1000, 1000], center=true);
        cylinder(d=HOLE_D+2, h=H);
    }
}
}