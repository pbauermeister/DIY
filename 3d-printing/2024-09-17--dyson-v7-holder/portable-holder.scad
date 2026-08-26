use <../chamferer.scad>
use <dyson-accessories-holder.scad>

L   = 105;
H   =  34;
W   =  40;
TH  =   8;
Z   =  49;
D   = 50-2.5;

$fn = $preview ? 12 : 180;

module portable_holder() {
    // cup
    translate([0, TH/2-1.5, 0])
    difference() {
        chamferer($preview?0:1, "cone")
        union() {
            hull() {
                h = 28+2.5;
                intersection() {
                    holder(1);
                    cylinder(d=1000, h=h);
                }

                d = D;
                translate([-d/2, -W/2-2, 0])
                cube([d, 8, h]);
            }

            translate([-D/2, -W/2-2-TH/2, 0])
            cube([D, TH*2, 4]);
        }

        //inner(1);
        unit(false, two_holes=false);
    }

    // plate
    translate([0, -0, 0])
    rotate([-90, 0, 0])
    chamferer(1.5, "cone-up", fn=32)
    rotate([90, 0, 0]) {
        hull() {
            for (kx=[-1, 1]) {
                translate([kx*(L/2-H/2), -W/2 + TH/2, H/2 + Z])
                rotate([90, 0, 0])
                cylinder(d=H, h=TH);
            }

            translate([-D/2 -2, -W/2-2-2])
            cube([D+4, TH, 1]);
        }
    }

}


portable_holder();
