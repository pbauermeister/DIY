/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

include <definitions.scad>

module crown() {
    file_shift = -56/2;
    thickness = (TAB_VSIZE-PLAY*2);
    color("yellow")
    translate([file_shift, file_shift, 0])
    scale([10, 10, 1/100 * thickness])
    linear_extrude(h=1)
    import("crown-ratchet3.dxf");
}


//// crown
//module crown_teeth() {
//    if(0) {
//        file_scale = 3.5;
//        file_shift = -175.046/2/10;
//        scale([file_scale, file_scale, 1])
//        rotate([0, 0, 7.8])
//        translate([file_shift, file_shift, 0])
//        linear_extrude(h=1)
//        import("gear-ring.dxf");
//    }
//    else {
//        side = TRANSMISSION_RADIUS_OUTER;
//        diag = side * sqrt(2);
//        factor = 3;
//        r = BODY_RADIUS + diag/4 + PLAY * factor;
//        n = floor(2 * PI * BODY_RADIUS / diag) * (factor+1);
//        da = 360 / n;
//        echo("n = ", n);
//        intersection() {
//            union() for(i=[0:n-1]) {
//                rotate([0, 0, da*i])
//                translate([0, -r, 0])
//                scale([1, 0.5, 1])
//                rotate([0, 0, 45])
//                translate([0, 0, 0.5])
//                cube([side, side, 1], true);
//            }
//            translate([0, 0, 0.5])
//            cylinder(r=BODY_RADIUS + diag/2, true);
//        }
//
//        color("yellow")
//        translate([0, 0, 0.5])
//        difference() {
//            cylinder(r=CROWN_RADIUS, true);
//            translate([0, 0, -ATOM*2])
//            scale([1, 1, 2])
//            cylinder(r=CROWN_RADIUS-CROWN_THICKNESS, true);
//        }
//    }
//}


//module crown() {
////    translate([0, 0, 8]) crown_teeth();
//
//    crown_ratchet();
//}

//rotate([0, 0, -45])
translate([0, 0, 6+PLAY])
crown();
