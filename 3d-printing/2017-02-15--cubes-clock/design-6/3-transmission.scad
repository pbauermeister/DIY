include <definitions.scad>
use <1-encoder.scad>

module transmission_cavity() {
    translate([0, -BODY_RADIUS + TRANSMISSION_RADIUS_OUTER - TRANSMISSION_RADIAL_SHIFT, 0]) {
        // grippers
        intersection() {
            scale([1, 1, BODY_HEIGHT])
            cylinder(r=TRANSMISSION_RADIUS_OUTER + PLAY*2, h=1, true);
            encoder_mask2(TRANSMISSION_RADIUS_OUTER + PLAY*2);

        }
        // axis
        scale([1, 1, BODY_HEIGHT])
        cylinder(r=TRANSMISSION_RADIUS_INNER + PLAY, h=1, true);
    }

    // window
    translate([0, -BODY_RADIUS, 0])
    scale([1, 1, BODY_HEIGHT])
    cylinder(r=TRANSMISSION_RADIUS_INNER - PLAY, h=1, true);
    
    // wheel overlap
    translate([0, -BODY_RADIUS + TRANSMISSION_RADIUS_OUTER - TRANSMISSION_RADIAL_SHIFT, 0])
    scale([1, 1, TRANSMISSION_WHEEL_OVERLAP * 3])
    cylinder(r=TRANSMISSION_RADIUS_OUTER + PLAY*2, h=1, true);
}

module transmission_grip() {
    side = sqrt(2) * TRANSMISSION_RADIUS_OUTER;
    translate([0, 0, 0.5]) {
        rotate([0, 0,  0+15]) cube([side, side, 1], true);
        rotate([0, 0, 30+15]) cube([side, side, 1], true);
        rotate([0, 0, 60+15]) cube([side, side, 1], true);
    }
}

module transmission_bar() {
    intersection() {
        scale([1, 1, BODY_HEIGHT])
        transmission_grip();
        
        encoder_mask2(TRANSMISSION_RADIUS_OUTER);
    }
   
    scale([1, 1, BODY_HEIGHT])
    cylinder(r=TRANSMISSION_RADIUS_INNER, h=1, true);
}

transmission_bar();

