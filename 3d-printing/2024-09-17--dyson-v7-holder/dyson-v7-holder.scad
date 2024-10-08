/*
Holder for Dyson v7.
*/

CONTAINER_D1   = 120;
CONTAINER_H1   =  73;
CONE_D         =  54; //65;
CONE_H1        =  32;
MARGIN         =  20;

EXTENT         =  70;
SPACING        =  20;

SCREW_DIAMETER =  5;
SCREW_HEAD     = 17;
SCREW_REST     = 15;
SCREW_DISTANCE = 20;

PLATE_D        = 170;

CHAMFER        = $preview? 0 : 3;

H = CONTAINER_H1 + CONE_D + MARGIN;

ATOM = 0.01;

$fn = 60; //$preview ? 20 : 10;


module chamfer_bit(r) {
    if (1) {
        sphere(r, $fn=8);
    }
    else {
        cylinder(r, r, 00,$fn=4);
        scale([1, 1, -1])
        cylinder(r, r, 00,$fn=4);
    }
}

module chamferer(r) {
    if (!r) {
        children();
    }
    else {
        infinity = 1000;
        fn = $preview? 5 : 7; // small: chamfer, big: fillet
        minkowski() {
            // re-invert+grow = fillet
            difference() {
                sphere(d=infinity-1);

                // invert+grow = carve
                minkowski() {
                    difference() {
                        sphere(d=infinity);
                        children();
                    }
                    chamfer_bit(r);
                }
            }
            chamfer_bit(r);
        }
    }
}

module body() {
    translate([0, 0, -ATOM])
    cylinder(d=CONTAINER_D1, h=H + ATOM*2);

    hull() {
        translate([CONTAINER_D1/2, 0, CONTAINER_H1+CONE_D/2])
        rotate([0, 90, 0])
        cylinder(d=CONE_D, h=CONE_H1);

        dd = (CONTAINER_D1-CONE_D)/2;
        for (i=[-1, 1])
            translate([dd*.6, dd * i * .915, CONTAINER_H1+CONE_D/2])
            rotate([0, 90, 0])
            cylinder(d=CONE_D, h=ATOM);
    }

    translate([CONTAINER_D1/2, 0, CONTAINER_H1+CONE_D/2])
    rotate([0, 90, 0])
    cylinder(d=CONE_D, h=CONE_H1 + EXTENT);
}

module screw_hole() {
    fn = 90;
    rotate([90, 0, 0]) {
        translate([0, 0, ATOM -CONTAINER_D1])
        cylinder(d=SCREW_DIAMETER, h=CONTAINER_D1, $fn=fn);

        cylinder(d=SCREW_HEAD, h=CONTAINER_D1, $fn=fn);

        th = .1;
        for (a=[0:30:360]) {
            rotate([0, 0, a])
            translate([0, -th/2, ATOM -CONTAINER_D1])
            cube([SCREW_DIAMETER*2.5, th, CONTAINER_D1]);
        }
    }
}

module support_0() {
    hull() {
        intersection() {
            translate([0, -CONTAINER_D1/2-MARGIN])
            cube([CONTAINER_D1/2+MARGIN, CONTAINER_D1+MARGIN*2, H]);

            union() {
                cylinder(d=CONTAINER_D1+MARGIN*2, h=H);
                cube([CONTAINER_D1/2 + MARGIN, CONTAINER_D1/2 + MARGIN, H]);
            }
        }

        translate([0, CONTAINER_D1/2, 0])
        cube([CONTAINER_D1/2 + MARGIN + EXTENT, MARGIN + SPACING, H]);
    }

    translate([-CONTAINER_D1/2, CONTAINER_D1/2, 0])
    cube([CONTAINER_D1/2 + MARGIN + EXTENT, MARGIN + SPACING, H]);

}

module support_1() {
    difference() {
        support_0();
        body();
    }
}

module support_2() {
    difference() {
        support_1();

        // Freeings
        translate([-ATOM, -CONTAINER_D1, CONTAINER_H1])
        cube([CONTAINER_D1, CONTAINER_D1, CONE_D]);

        translate([-CONTAINER_D1*.75, -CONTAINER_D1, -H/2])
        cube([CONTAINER_D1, CONTAINER_D1, H*2]);
    }
}

module support_3() {
    intersection() {
        support_2();

        translate([CONTAINER_D1/2, 0, H/2])
        rotate([90, 0, 0])
        cylinder(d=PLATE_D, h=1000, center=true);
    }
}

module support() {
    difference() {
        chamferer(CHAMFER)
        support_3();

        // screw holes
        for (z=[CONTAINER_H1, CONTAINER_H1+CONE_D]) {
            translate([SCREW_DISTANCE*.67, CONTAINER_D1/2 + MARGIN+SPACING-SCREW_REST, z])
            screw_hole();
        }
        translate([CONTAINER_D1/2 + EXTENT + MARGIN - SCREW_DISTANCE*2,
                   CONTAINER_D1/2 + MARGIN+SPACING-SCREW_REST,
                   CONTAINER_H1 + CONE_D/2])
        screw_hole();

        th = 20;
        translate([0, CONTAINER_D1/2 + SPACING, 0])
        rotate([45, 0, 0])
        translate([-CONTAINER_D1/2, 0, -th])
        cube([CONTAINER_D1*2, CONTAINER_D1, th]);
    }
}

rotate([90, 180, 0])
intersection() {
    support();

    if (0) {
        translate([0, 0, CONTAINER_H1-5])
        cylinder(r=CONTAINER_D1*2, h=CONE_D+10);
        translate([-3, -150+10, 0])
        cube([100, 205, 1000]);
    }

    if (0) %
    translate([0, 0, 106-5.5])
    rotate([0, 90, 0])
    %cylinder(d=51.5, h=CONTAINER_D1);
}
