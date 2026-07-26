use <../chamferer.scad>

/*
This version was never printed:
drill-handle.scad (a much simpler variant) was found to work well enough.
*/


RD = 48;
RW = 22;
RTH = 10;

HD =  25-3;
HW = 110;
HX0 = 10;
HX =  30;

SX = 6;
SD = 7;

ATOM = 0.01;

module rcylinder(d, h) {
    hull() for (k=[-1, 1])
        translate([0, 0, k*(h/2-d/8)])
        scale([1, 1, .25])
        sphere(d=d);
}


module outer_ring() {
    chamferer(2)
    translate([0, 0, -RW/2])
    cylinder(d=RD+RTH*2, h=RW*2, center=!true);
}

module inner_ring()
    cylinder(d=RD, h=RW*10, center=true);

module handle_head() {
    for (z=[0, RW])
    translate([RD/2 + RTH  -RW/2, 0, z]) {
        rotate([90, 0, 0])
        rcylinder(d=RW, h=HW + HD*2);
    }

    translate([RD/2 + RTH  -RW/2 + RTH, 0, 0]) {
        rotate([90, 0, 0])
        rcylinder(d=RW, h=HW + HD*2);
    }

}

module handle_bar()
translate([RD/2 + RTH + HD/2 + HX0 + HX, 0, RW]) {
    rotate([90, 0, 0])
    rcylinder(d=HD, h=HW + HD*2);
}

module handle() {
    difference() {
        union() {
            hull() {
                outer_ring();
                handle_head();
            }

            hull() {
                handle_head();
                handle_bar();
            }
        }
        
        hull() {
            for (k=[-1, 1])
                translate([RD/2 + RTH + HD/2 + HX0 + (HX-HD)/2, (HW/2 + HD -HX/2-HD)*k, 0])
                cylinder(d=HX, h=HD*10, center=true);

            translate([RD/2 + RTH + HD + HX0 + HX, 0, 0])
            cube([ATOM, HW, HD*2], center=true);
        }
        
        inner_ring();
        
        w = RD/2;
        th1 = 1.8;
        th2 = RD/2;

        // plates
        for (kt=[[1, th1], [-1, th2]]) {
            k = kt[0];
            th = kt[1];
            translate([RD/2 + SX, k*w/2, -ATOM])
            cube([RD + SX*2, th, RW], center=true);
        }


        for (k=[1, -1])
            scale([1, k, 1])
            translate([RD/2 + SX, -w/2, 0])
            hull() {
                rotate([90, 0, 0]) cylinder(d=RW, h=HW);
                translate([0, 0, -RW])
                rotate([90, 0, 0]) cylinder(d=RW, h=HW);
            }

        // screw axis
        translate([RD/2 + SX, 0, 0])
        rotate([90, 0, 0])
        cylinder(d=SD, h=HW*2, center=true);
    }

    handle_bar();
}

handle();