use <../chamferer.scad>
//use <plate-counter-knob.scad>

DIAMETER_1 = 27;
DIAMETER_2 = 57;
DIAMETER_3 = DIAMETER_2 + 3;
WALL       =  1.6;
DEPTH      =  5;
ATOM       =  0.01;

$fn = $preview ? 30 : 100;

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

D      = 108;
HOLE_D =  27.6;
CAP_D  =  60.2              + 0.5;
LIP_TH =   9.5              - 1.5;
LIP_D  =  85.0 - 15; 
H      = DEPTH*3.75         - 1.5 +2;
CAP_TH =   6.7;

//if ($preview) %rod();

module knob() {
    intersection() {
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

            translate([0, 0, CAP_TH - .5])
            cylinder(d1=HOLE_D+2, d2=HOLE_D-2, h=2);

            // cap
            translate([0, 0, -ATOM])
            cylinder(d=CAP_D, h=CAP_TH+ATOM);

            // hollowings
            for (a=[0 : 360/6 : 360])
                rotate([0, 0, a + 30])
                translate([D*.39 -2+1, 0, 0])
                scale([1, 1, 1.5])
                sphere(d=D*.15);

            for (a=[0 : 360/6 : 360])
                rotate([0, 0, a])
                translate([D*.35 -1, 0, 0])
                scale([1, 1, 2])
                sphere(d=D*.15*.69);
        }
        
        recess = 11.5;
        translate([0, 0, -ATOM])
        cylinder(d2=D-recess*2, d1=D + H, h=H+ATOM*2);
    }        
}

//translate([1, 0, 0])%cut1();

intersection() {
    knob();

    // cross-cut
    if ($preview && 1) translate([0, -500, -500]) cube(1000);

    // slice cut
    if (0)
    union() {
        cube([1.2, 1000, 1000], center=true);
        cylinder(d=HOLE_D+2, h=H);
    }
}
