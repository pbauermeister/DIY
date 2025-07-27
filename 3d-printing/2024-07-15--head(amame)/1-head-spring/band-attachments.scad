use <head-spring.scad>

$fn = 60;

module attachment_0() {
    difference() {
        translate([80, 45.8, 0]) {
            th = .3;
            k = .33*0  + .55;

            difference() {
                translate([0, 0, -th]) union() {
                    cylinder(d=17, h=20 + th*2);

                    translate([0, 0, -th])
                    intersection() {
                        scale([1, 1, k])
                        sphere(d=17);
                        cylinder(d=50, h=17*k-1, center=true);
                    }


                    translate([0, 0, 20+th])
                    scale([1, 1, k])
                    sphere(d=17);
                }

                rotate([0, 0, 13.5])
                translate([-8, 0, 0])
                cube([3, 15, 80], center=true);
            }
        }
        
        // screws
        translate([0, 0, 0]) {
            screw_holes(d=1.3,    shift_inner=9.5  , round=true);
            screw_holes(d=2  ,  shift_inner=15   , round=true);
            //screw_holes(d=4.25, shift_inner=21.5 , round=true);
            screw_holes(d=4.25, shift_inner=13.5 , ball=true);
        }
        
       // spring cavity
        xtra = .26;
        if(0)
        translate([80, 45.8, 0])
        rotate([0, 0, 13.5 + 2.5]) {
            scale([1, 4, 1])
            translate([-.25, 0, - xtra/2])
            cylinder(d=8-.4, h=20+xtra, $fn=20);
        }

        // slits
        translate([80, 45.8, 0])
        rotate([0, 0, 13.5 + 2.5]) {
            scale([1, 4, 1])
            translate([-.25-4, 0, - xtra/2])
            cylinder(d=8, h=xtra/2, $fn=20);
        }
        translate([80, 45.8, 0])
        rotate([0, 0, 13.5 + 2.5]) {
            scale([1, 4, 1])
            translate([-.25-4, 0, 20])
            cylinder(d=8, h=xtra/2, $fn=20);
        }
                
        // mark
        translate([80, 45.8, 0])
        rotate([0, 0, 13.5 + 2.5])
        translate([-15, -.36-.5, -1.5 +.25])
        cube([9.25, 2, 2.4]);
    }
}

module attachment_1() { 
    difference() {
        rotate([0, -90, 0])
        translate([-80, -45.8, 0])
        rotate([0, 0, -13.5])
        attachment_0();

        //
        xtra = .26;
        translate([-20-xtra/2, -50, 5])
        cube([20+xtra, 50, 6.5]);
    }
}

module tab() { 
    translate([0, 0, 5])
    rotate([0, 180, 0])
    intersection() {
        attachment_1();
        xtra = .2;
        translate([-20-xtra/2, -50, 0])
        cube([20+xtra, 50, 6.5]);
    }
}

module attachment() { 
    translate([0, 20, 4.25 +.5])
    rotate([0, 90, 0])
    difference() {
        attachment_1();

        xtra = .26;
        translate([-20-xtra/2, -50, 0])
        cube([20+xtra, 50, 6.5]);
    }
    translate([-20, 20, 0]) tab();
}


if (0) {
    %head_spring(false); %screw_holes();
    attachment_0();
} else if (1) {
    attachment();

    translate([-50, 0, 0])
    rotate([0, 0, 180])
    attachment();
} else {
    attachment();
}
