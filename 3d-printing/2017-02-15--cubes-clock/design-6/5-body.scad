include <definitions.scad>
use <1-encoder.scad>
use <2-servo-holder.scad>
use <3-transmission.scad>

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

module body_servo2_axis() {
    translate([0, SERVO2_DISPLACEMENT, SERVO2_VERTICAL_OFFSET])
    servo2_axis();
}

module body_screws_cavity() {    
    for(a=[-60, 60]) {
        rotate([0, 0, a])
        translate([0, -BODY_RADIUS + SCREW_DISTANCE_TO_BORDER, 0]) {
            scale([1, 1, SCREW_MAX_LENGTH*2])
            translate([0, 0, -0.5])
            cylinder(r=SCREW_DIAMETER/2 - 0.25, h=1, true);

            translate([0, 0, -BOTTOM_THICKNESS])
            scale([1, 1, BOTTOM_THICKNESS])
            cylinder(r=SCREW_DIAMETER/2, h=1, true);

            translate([0, 0, -BOTTOM_THICKNESS - SCREW_PROTRUSION])
            scale([1, 1, BOTTOM_THICKNESS])
            cylinder(r=SCREW_DIAMETER/2 + 1, h=1, true);
        }
    }
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
        servo1_cavity();
        servo2_cavity();
        body_screws_cavity();
    }
    body_ribs();
    servo2_pillars();

    if(0)
        body_servo2_axis();
}


body();
