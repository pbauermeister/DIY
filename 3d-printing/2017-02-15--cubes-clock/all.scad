/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

include <definitions.scad>
use <1-encoder.scad>
use <2-servo-holder.scad>
use <3-transmission.scad>

CROSS_CUT = false;
APART     = !true;

module all_transmission() {
    dist = -BODY_RADIUS + TRANSMISSION_RADIUS_OUTER - TRANSMISSION_RADIAL_SHIFT;
    move_if_apart(false, -20, 0) {
        translate([0, dist, 0])
        import("3-transmission.stl");
    }
}


module move_if_apart(upside_down, displacement, elevation) {
    translate([0, APART ? displacement : 0, APART ? elevation : 0])
    rotate([upside_down && APART ? 180 : 0, 0, 0])
    children();
    }

module transp_if_not_apart() {
    if(APART)
        children();
    else
        %children();
}



module all() {
    import("5-body.stl");
    if(!APART) all_transmission();

    // encoder
    transp_if_not_apart()
    move_if_apart(true, 70, ENCODER_HEIGHT + BODY_BASE)
    translate([0, ENCODER_DISPLACEMENT, BODY_BASE + PLAY])
    import("1-encoder-test.stl");

    // bottom
    if(0)
    transp_if_not_apart()
    move_if_apart(false, 0, -6)
    translate([0, 0, -BOTTOM_WHEELS_THICKNESS])
    import("4-bottom.stl");
}

all();

//translate([0, 0, 5]) crown_teeth();
crown_ratchet();

module crown_ratchet() {
    file_shift = -56/2;
    color("yellow")
    rotate([0, 0, -45])
    translate([file_shift, file_shift, 0])
    scale([10, 10, 1/100 * TAB_VSIZE])
    linear_extrude(h=1)
    import("crown-ratchet.dxf");
}


// crown
module crown_teeth() {
    if(0) {
        file_scale = 3.5;
        file_shift = -175.046/2/10;
        scale([file_scale, file_scale, 1])
        rotate([0, 0, 7.8])
        translate([file_shift, file_shift, 0])
        linear_extrude(h=1)
        import("gear-ring.dxf");
    }
    else {
        side = TRANSMISSION_RADIUS_OUTER;
        diag = side * sqrt(2);
        factor = 3;
        r = BODY_RADIUS + diag/4 + PLAY * factor;
        n = floor(2 * PI * BODY_RADIUS / diag) * (factor+1);
        da = 360 / n;
        echo("n = ", n);
        intersection() {
            union() for(i=[0:n-1]) {
                rotate([0, 0, da*i])
                translate([0, -r, 0])
                scale([1, 0.5, 1])
                rotate([0, 0, 45])
                translate([0, 0, 0.5])
                cube([side, side, 1], true);
            }
            translate([0, 0, 0.5])
            cylinder(r=BODY_RADIUS + diag/2, true);
        }

        color("yellow")
        translate([0, 0, 0.5])
        difference() {
            cylinder(r=CROWN_RADIUS, true);
            translate([0, 0, -ATOM*2])
            scale([1, 1, 2])
            cylinder(r=CROWN_RADIUS-CROWN_THICKNESS, true);
        }
    }
}

