include <definitions.scad>


module servo1_hull() {
    servo_hull(SERVO1_AXIS_RADIUS,
               SERVO1_AXIS_SHIFT,
               SERVO1_BODY_HEIGHT,
               SERVO1_BODY_THICKNESS, //SERVO1_BODY_THICKNESS_CLEARANCE,
               SERVO1_BODY_WIDTH, //SERVO1_BODY_WIDTH_CLEARANCE,
               SERVO1_BOTTOM_BODY_HEIGHT,
               SERVO1_BOTTOM_BODY_WIDTH,
               SERVO1_HEIGHT,
               SERVO_HOLDER_THICKNESS,
               SERVO1_BOTTOM_CLEARANCE_HEIGHT,
               //SERVO1_BOTTOM_HOLE_X, 
               SERVO1_BOTTOM_HOLE_Z,
               false);
}

module servo1_hull2(extent) {
    servo_hull2(extent,
                SERVO1_AXIS_SHIFT,
                SERVO1_BODY_THICKNESS,
                SERVO1_BODY_WIDTH);
}

module servo2_hull() {
    servo_hull(SERVO2_AXIS_RADIUS,
               SERVO2_AXIS_SHIFT,
               SERVO2_HEIGHT,
               SERVO2_BODY_THICKNESS, //SERVO2_BODY_THICKNESS_CLEARANCE,
               SERVO2_BODY_WIDTH, //SERVO2_BODY_WIDTH_CLEARANCE,
               SERVO2_BOTTOM_BODY_HEIGHT,
               SERVO2_BOTTOM_BODY_WIDTH,
               SERVO2_HEIGHT,
               SERVO_HOLDER_THICKNESS,
               SERVO2_BOTTOM_CLEARANCE_HEIGHT,
               //SERVO2_BOTTOM_HOLE_X, 
               SERVO2_BOTTOM_HOLE_Z,
               true);
}

module servo2_axis() {
    servo2_axis_(SERVO2_AXIS_RADIUS,
                 SERVO2_AXIS_SHIFT,
                 SERVO2_HEIGHT,
                 SERVO2_BODY_THICKNESS, //SERVO2_BODY_THICKNESS_CLEARANCE,
                 SERVO2_BODY_WIDTH, //SERVO2_BODY_WIDTH_CLEARANCE,
                 SERVO2_BOTTOM_BODY_HEIGHT,
                 SERVO2_BOTTOM_BODY_WIDTH,
                 SERVO2_HEIGHT,
                 SERVO_HOLDER_THICKNESS,
                 SERVO2_BOTTOM_CLEARANCE_HEIGHT,
                 true);
}

module servo2_pillars() {
    servo_pillars(SERVO2_AXIS_RADIUS,
                  SERVO2_AXIS_SHIFT,
                  SERVO2_HEIGHT,
                  SERVO2_BODY_THICKNESS, //SERVO2_BODY_THICKNESS_CLEARANCE,
                  SERVO2_BODY_WIDTH, //SERVO2_BODY_WIDTH_CLEARANCE,
                  SERVO2_BOTTOM_BODY_HEIGHT,
                  SERVO2_BOTTOM_BODY_WIDTH,
                  SERVO2_HEIGHT,
                  SERVO_HOLDER_THICKNESS);
}

module servo_hull(axis_radius,
                  axis_shift,
                  body_height,
                  body_thickness,
//                  body_thickness_clearance,
                  body_width,
//                  body_width_clearance,
                  bottom_body_height,
                  bottom_body_width,
                  height,
                  holder_thickness,
                  bottom_clearance,
                  //bottom_hole_x,
                  bottom_hole_z,
                  upside_down)
{
    // body
    delta_h = body_height - bottom_body_height;

    translate([0, axis_shift,
               upside_down ? delta_h/2 : delta_h/2 + bottom_body_height])
    cube([body_thickness, body_width, delta_h], true);

    translate([0, axis_shift,
               upside_down ? height - bottom_body_height/2 +bottom_clearance/2 : bottom_body_height/2 - bottom_clearance/2])
    cube([body_thickness, bottom_body_width, bottom_body_height + bottom_clearance], true);

//    // perpendicular clearance
//    translate([0, axis_shift, height/2])
//    cube([body_thickness+holder_thickness*5,
//          body_width_clearance,
//          height], true);
//
//    // clearance along width
//    translate([0, axis_shift,
//               upside_down ? height/2 + bottom_clearance/2 : height/2 - bottom_clearance/2])
//    cube([body_thickness_clearance,
//          body_width,
//          height + bottom_clearance], true);

    // lateral hole
    translate([0, axis_shift,
               upside_down ? height - bottom_hole_z/2 + bottom_clearance: +bottom_hole_z/2 - bottom_clearance])
    scale([body_thickness*2, 1, 1])
    cube([1, bottom_body_width/2.5, bottom_hole_z], true);

    // axis
    scale([1, 1, height + ATOM])
    cylinder(r=axis_radius, h=1);
}


module servo_pillars(axis_radius,
                     axis_shift,
                     body_height,
                     body_thickness,
//                     body_thickness_clearance,
                     body_width,
//                     body_width_clearance,
                     bottom_body_height,
                     bottom_body_width,
                     height,
                     holder_thickness)
{
//    // body
//    delta_h = body_height - bottom_body_height;
//
//    difference() {
//        // support pillar
//        translate([0, axis_shift, delta_h/2])        
//        difference() {
//            cube([body_thickness_clearance+SUPPORT_THICKNESS*2, 
//                  bottom_body_width+SUPPORT_THICKNESS*2, delta_h], true);
//            cube([body_thickness, bottom_body_width, delta_h], true);
//        }
//
//        // clearance
//        translate([0, axis_shift, height/2])
//        cube([body_thickness_clearance,
//              body_width + holder_thickness*2,
//              height], true);
//    }
}

module servo_hull2(extent,
                   axis_shift,
                   body_thickness,
                   body_width,
                   ) {
                       if(0)
    translate([0, axis_shift, extent/2])
    cube([body_thickness, body_width, extent], true);
}

module servo2_axis_(axis_radius,
                    axis_shift,
                    body_height,
                    body_thickness,
                    body_thickness_clearance,
                    body_width,
                    body_width_clearance,
                    bottom_body_height,
                    bottom_body_width,
                    height,
                    holder_thickness,
                    bottom_clearance,
                    upside_down)
{
    // axis
    scale([1, 1, height + ATOM])
    cylinder(r=axis_radius, h=1);
}


module servo_holder(width, thickness) {
    width = max(SERVO1_BODY_WIDTH, SERVO2_BODY_WIDTH);
    thickness = max(SERVO1_BODY_THICKNESS, SERVO2_BODY_THICKNESS);

    translate([0, ENCODER_DISPLACEMENT, 0])
    union() {
        // guiding disc
        scale([1, 1, BODY_GUIDE + BODY_BASE])
        cylinder(r=ENCODER_RADIUS-ENCODER_THICKNESS - PLAY, h=1, true);

        // central column
        difference() {
            translate([0, SERVO1_AXIS_SHIFT, SERVO_HOLDER_HEIGHT/2])
            cube([thickness + SERVO_HOLDER_THICKNESS*2,
            width + SERVO_HOLDER_THICKNESS*5,
            SERVO_HOLDER_HEIGHT], true);
        }
    }
}

module servo1_cavity() {
    translate([0, ENCODER_DISPLACEMENT, BODY_HEIGHT - SERVO1_HEIGHT]) {
        servo1_hull();
        servo1_hull2(BODY_HEIGHT);
    }
}

module servo2_cavity() {
    translate([0, SERVO2_DISPLACEMENT, SERVO2_VERTICAL_OFFSET])
    servo2_hull();
}


module servo_all() {
    difference() {
        servo_holder();
        servo1_cavity();
        servo2_cavity();
    }
}

servo_all();
