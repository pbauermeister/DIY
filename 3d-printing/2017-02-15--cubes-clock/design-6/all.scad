include <definitions.scad>
use <1-encoder.scad>
use <2-servo-holder.scad>
use <3-transmission.scad>

CROSS_CUT = false;
APART     = true;

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
    if(0)
    transp_if_not_apart()
    move_if_apart(true, 70, ENCODER_HEIGHT + BODY_BASE)
    translate([0, ENCODER_DISPLACEMENT, BODY_BASE + PLAY])
    import("1-encoder.stl");

    // bottom
    if(0)
    transp_if_not_apart()
    move_if_apart(false, 0, -6)
    translate([0, 0, -BOTTOM_WHEELS_THICKNESS])
    import("4-bottom.stl");
}

all();
