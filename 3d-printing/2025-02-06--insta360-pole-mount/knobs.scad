use <insta360-pole-mount.scad>

DIAMETER             = 40 + 10;
THICKNESS            = 12 + 5;
ATOM                 =  0.01;
CHAMFER              =  3.5 * 3;
SCREW_HEAD_THICKNESS =  5.5;
CROSS_CUT            = !true;

CHAMFER_        =  $preview? 0 : CHAMFER;
$fn = $preview ? 30 : 200;

module chamferer() {
    chamfer = CHAMFER_;
    intersection() {
        translate([0, 0, chamfer*.25])
        scale([.333, .333, .5])
        sphere(d=chamfer, $fn=50);
    }
}

//!chamferer();

module body() {
    minkowski() {
        difference() {
            hull() {
                dh = DIAMETER * .075;
                cylinder(d=DIAMETER, h=THICKNESS-CHAMFER_-dh);
                cylinder(d=DIAMETER/4, h=THICKNESS-CHAMFER_/2);
            }

            n = 4;
            for (i=[0:n-1]) {
                rotate([0, 0, 360/n*(i+.5)])
                translate([DIAMETER/1.3, 0, 0])
                cylinder(d=DIAMETER/1.125, h=THICKNESS*3, center=true);
            }
        }
        
        if (!$preview) chamferer();
    }
}

module knob() {
    difference() {
        body();

        translate([0, 0, THICKNESS - 18 - SCREW_HEAD_THICKNESS])
        screw_hole();

        // nut hollowing
        translate([0, 0, -ATOM])
        cylinder(d=24, h=7);
    }

    // screw head thickness
    if (CROSS_CUT) {
        translate([0, 0, THICKNESS -SCREW_HEAD_THICKNESS])
        cylinder(r=4, h=SCREW_HEAD_THICKNESS);
        cylinder(r=2, h=THICKNESS);
    }
}

module cross_cut() {
    if (CROSS_CUT)
        difference() {
            children();
            rotate([0, 90, 0])
            cylinder(d=1000, h=500);
        }
    else children();
}

cross_cut()
knob();
