GAP  =  42;
TH   =  20;
W    = 100;
WALL =  10;
D    =  28 -4;
Y    = GAP*.55;
PLAY =   0.4;

GAP2 = 5;
TH2  = 4;
$fn = $preview ? $fn : 100;

use <../chamferer.scad>

module screw_cavity() {
    cylinder(d=3.5, h=22, $fn=20);

    translate([0, 0, -20])
    cylinder(d=8, h=20, $fn=20);
}

module latch_cylinder(xd, xh=0) {
    translate([0, 0, -xh/4]) {
        cylinder(d=D+xd, h=TH+xh);


        hull() {
            intersection() {
                cylinder(d=D+xd, h=TH+xh);
     
                translate([-D, 0, -D/2])
                cube([D*2, D, D*2]);
            }

            for (k=[1, -1])
                translate([D*.47*k, -D*.12, 0])    
                cylinder(d=D/6+xd, h=TH+xh);
        }
    }
}

module back_part() {
    chamferer($preview ? 0 : 1)
    difference() {    
        union() {
            chamferer(TH*.499, "cylinder-y", fn=64)
            translate([-W/2, GAP-WALL, 0])
            cube([W, WALL, TH]);

            hull() {
                w = D*2.5;
                translate([-w/2, GAP-WALL, 0])
                cube([w, WALL, TH]);

                translate([0, Y, 0]) difference() {
                    latch_cylinder(5+1);
                    translate([-D, 0, -D/2]) cube(D*2);
                }
            }
        }

        // latch entry chamfer
        translate([0, Y-D*sqrt(2)/2 +D*.2, TH/2])
        rotate([0, 0, 45])
        cube([D, D, TH*2], center=true);

        // latch chamber
        translate([0, Y, -TH/2])
        latch_cylinder(PLAY*2, TH);

        // screw holes
        for (k=[1, -1])
            translate([W*.5*.75*k, GAP - 3, TH/2])
            rotate([-90, 0, 0])
            screw_cavity();
    }
}

module arm() {
    d = TH2*1.5;
    
    translate([GAP2/2, WALL/2, d/2])
    cube([TH2, Y-WALL, TH - d]);
    
    translate([GAP2/2+TH2/2, WALL*.55, 0]) {
        translate([0, 0, d/4])
        cylinder(d=d, h=TH-d/2, $fn=60);

        cylinder(d1=d/2, d2=d, h=d/4, $fn=60);

        translate([0, 0, TH-d/4])
        cylinder(d2=d/2, d1=d, h=d/4, $fn=60);
    }
}

module arms() {
    arm();
    scale([-1, 1, 1])
    arm();
}

module front_part() {
    difference() {
        chamferer($preview ? 0 : 1)
        difference() {
            union() {
                chamferer(TH*.499, "cylinder-y", fn=64)
                translate([-W/2, 0, 0])
                cube([W, WALL, TH]);

                // latch entry chamfer
                difference() {
                    intersection() {
                        translate([0, Y-D*sqrt(2)/2 +D*.2 -1, TH/2])
                        rotate([0, 0, 45])
                        cube([D, D, TH], center=true);

                        translate([0, D, 0])
                        cube(D*2, center=true);
                    }
                    // free center
                    translate([0, GAP/2, TH/2])
                    cube([GAP2+TH2*2+PLAY*2, GAP, TH*2], center=true);
                }
            }

            // latch chamber
            translate([0, Y, -TH/2])
            latch_cylinder(PLAY*2, TH);

            // screw holes
            for (k=[1, -1])
                translate([W*.5*.75*k, 3, TH/2])
                rotate([90, 0, 0])
                screw_cavity();
        }

        // arms chamber
        chamferer($preview ? 0 : PLAY+.1, shrink=false)
        arms();
    }
}

module mid_part() {
    translate([0, Y, 0])
    difference() {
        chamferer($preview ? 0 : 1)
        latch_cylinder(0, 0);

        // gap
        cube([GAP2, D*2, D*2], center=true);

        // spring cavity
        for (j=[0, -.6])
        for (i=[-1.25, 0, 1.25])
            translate([0, D*.28 +j*12, TH/2 + TH*i/4])
            rotate([0, 90, 0])
            cylinder(d=5.25, h=13, $fn=60, center=true);
    }

    arms();
}

////////////////////////////////////////////////////////////////////////////////

back_part();
front_part();
mid_part();
