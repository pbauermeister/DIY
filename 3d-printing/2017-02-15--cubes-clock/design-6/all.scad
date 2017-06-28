include <definitions.scad>
use <1-encoder.scad>
use <2-servo-holder.scad>
use <3-transmission.scad>

CROSS_CUT = false;
APART     = false;

module body_rib() {
    translate([0, BODY_RADIUS - RIB_RADIUS + RIB_RADIAL_SHIFT, 0])
    scale([1, 1, BODY_HEIGHT])
    cylinder(r=RIB_RADIUS, h=1, true);
}

module body_ribs() {
    difference() {
        union() {
            rotate([0, 0, 60])  body_rib();
            rotate([0, 0, -60])  body_rib();
        }
        encoder_mask();
    }
}

module body_encoder_cavity() {
    translate([0, ENCODER_DISPLACEMENT, BODY_BASE])
    scale([1, 1, BODY_HEIGHT])
    cylinder(r=ENCODER_RADIUS+PLAY, h=1, true);
}

module body_window() {
    translate([0, 0, BODY_WINDOW_MARGIN + BODY_BASE])
    scale([1, 1, ENCODER_HEIGHT-BODY_WINDOW_MARGIN*2])
    translate([0, BODY_RADIUS, 0])
    cylinder(r=TAB_HSIZE/1.5, h=1, true);
}

module body_encoder_border_cavity() {
    translate([0, ENCODER_DISPLACEMENT - PLAY/2, BODY_BASE])
    scale([1, 1, BODY_HEIGHT])
    difference() {
        cylinder(r=ENCODER_RADIUS+PLAY, h=1, true);
        cylinder(r=ENCODER_RADIUS-ENCODER_THICKNESS-PLAY, h=1, true);
    }
}

module body_spine() {
    spine_width = ENCODER_THICKNESS*3;
    translate([0, -ENCODER_RADIUS + ENCODER_DISPLACEMENT + ENCODER_THICKNESS/2, 0])
    scale([1, spine_width, SERVO_HOLDER_HEIGHT])
    translate([0, 0, 0.5])
    cube(1, true);                
}

module body_servo_holder() {
    import("2-servo-holder.stl");
}

module body_transmission() {
    dist = -BODY_RADIUS + TRANSMISSION_RADIUS_OUTER - TRANSMISSION_RADIAL_SHIFT;
    move_apart(false, -20, 0) {
        translate([0, dist, 0])
        import("3-transmission.stl");
    }
    
    // attachments
    if(!APART) {
        color("yellow")
        intersection() {
            translate([TRANSMISSION_RADIUS_INNER + PLAY*2 + 0.5, dist-TRANSMISSION_RADIUS_INNER+1, BODY_HEIGHT/2])
            scale([1, 1, BODY_HEIGHT])
            cube([TRANSMISSION_RADIUS_OUTER, 0.5, 1], true);
            encoder_mask3(1);
        }
    }
}

module body_servo2_axis() {
    translate([0, SERVO2_DISPLACEMENT, SERVO2_VERTICAL_OFFSET])
    servo2_axis();
}

module body() {
    difference() {
        union() {
            difference() {
                union() {
//                    %
                    difference() {
                        // trunk
                        scale([1, 1, BODY_HEIGHT])
                        cylinder(r=BODY_RADIUS, h=1, true);

                        body_encoder_cavity();
                        body_window();
                    }
                    body_servo_holder();
                }
                body_encoder_border_cavity();
            }
            body_spine();
        }
        transmission_cavity();
        servo2_cavity();
    }
    body_ribs();

    if(0)
        body_servo2_axis();

    body_transmission();
}

module move_apart(upside_down, displacement, elevation) {
    translate([0, APART ? displacement : 0, APART ? elevation : 0])
    rotate([upside_down && APART ? 180 : 0, 0, 0])
    children();
    }

module all() {
    // trunk
    body();

    // encoder
    move_apart(true, 70, ENCODER_HEIGHT + BODY_BASE)
    translate([0, ENCODER_DISPLACEMENT, BODY_BASE + PLAY])
    import("1-encoder.stl");

    // bottom
    %
    translate([0, 0, -BOTTOM_WHEELS_THICKNESS -15])
    import("4-bottom.stl");
}


scale([1, 1, 1/Z_SHRINK_FACTOR]) {
    intersection() {
        all();

        if(CROSS_CUT)
            scale(200)
            translate([0.5, 0, 0])
            cube(1, true);
    }
}
