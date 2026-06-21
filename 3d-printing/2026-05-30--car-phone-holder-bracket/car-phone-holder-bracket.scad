use <../chamferer.scad>
L = 70;
W = 10              -4;
H = 18              -4;

L2 = 35;

D = 6;
D2 = 4.25;
$fn = 20;


module rail() {
    w = 8.6;
    translate([-w/2, 0, 0]) cube([w, 100, 4.5]);
}

//!rail();

module body(ds, with_gripper=true, with_pinholes=false, with_groove=true) {
    difference() {
        chamferer(1, fn=8)
        chamferer(6, "cylinder-y", fn=4)
        translate([0, 0, 2]) {
            cube([L, W, H], center=true);

            if (with_gripper)
                translate([0, W/4, H/4])
                cube([L*.75, W/2, H], center=true);
        }

        // pin holes
        if (with_pinholes)
        for(x=[-L2/2, L2/2])
            translate([x, W, -1])
            rotate([90, 0, 0])
            cylinder(d=D2, h=W*2);

        // spring holes
        for(i=[-3, -1, 1, 3])
            translate([i*L/8, W, -1])
            rotate([90, 0, 0])
            cylinder(d=D, h=W);

        // rails
        for(x=[-L2/2, L2/2])
            translate([x, -20, 2.5])
            scale([with_groove?1:1.05, 1, with_groove?1:1.03])
            rail();

        // groove
        d = 3.6;
        if (with_groove)
        hull() for (y=[-d/2 -1, -d*3])
            translate([0, -W/2+d/2 + y, d*.45]) {
            //rotate([45, 0, 0])
            cube([L*2, d, d*.5], center=true);
            }
        
        // screw
        translate([0, 0, -H*.25])
        cylinder(d=ds, h=H*3, center=!true);

        translate([0, 0, H*.55])
        cylinder(d=ds+4, h=H*3, center=!true);

        // bite
        if (!with_groove)
        translate([0, 0, -10])
        rotate([90, 0, 0])
        cylinder(d=15, h=20, center=true);

    }
}

module body_back(ds) {
        body(ds, with_gripper=false, with_pinholes=true, with_groove=false);
}


module partitioner(extra=0) {
    translate([0, 0, 2.5 + 3 -1.8]) {
        translate([0, 0, H/2])
        cube([L*2, W*2, H], center=true);
        
        scale([1, 1, .5]) {
            d = 3;
            rotate([45, 0, 0])
            cube([L*2, d+extra, d+extra], center=true);

            translate([0, 0, -d*.25])
            rotate([0, 0, 90])
            cube([L*2, d*3+extra, d+extra], center=true);
        }
    }
}

module front_piece() { 
    difference() {
        body(ds=3);
        partitioner(.4);
    }

    translate([0, 0, 5])
    intersection() {
        body(ds=4.5);
        partitioner();
    }
}


module back_piece() { 
    difference() {
        body_back(ds=3);
        partitioner(.4);
    }

    translate([0, 0, 5])
    intersection() {
        body_back(ds=4.5);
        partitioner();
    }
}



rotate([$preview ? 0 : -90, 0, 0]) front_piece();

translate([0, 40, 0])
rotate([$preview ? 0 : -90, 0, 0]) back_piece();
