include <definitions.scad>

module servo(with_cavities=false, short_cavity=false) {
    servo_hull();
    if (with_cavities) {
        servo_screw_cavity();
        servo_cavities(short_cavity=short_cavity);
    }
}

servo(with_cavities=!false);

module servo_hull(with_clearance=false, with_cable_slot=false) {
    // tab
    difference() {
        translate([SERVO_OFFSET_X-SERVO_TAB_WIDTH_EXCESS_2,
                   -SERVO_BODY_WIDTH/2,
                   0])
        cube([SERVO_BODY_LENGTH + SERVO_TAB_WIDTH_EXCESS_1 + SERVO_TAB_WIDTH_EXCESS_2,
              SERVO_BODY_WIDTH,
              SERVO_TAB_HEIGHT]);
        servo_screw_cavity();
    }

    // main body
    translate([SERVO_OFFSET_X,
               -SERVO_BODY_WIDTH/2,
               -SERVO_BODY_HEIGHT -SERVO_TAB_OFFSET_Z])
    cube([SERVO_BODY_LENGTH,
          SERVO_BODY_WIDTH,
          SERVO_BODY_HEIGHT]);

    // axis
    translate([0, 0, -SERVO_BODY_HEIGHT-SERVO_TAB_OFFSET_Z])
    cylinder(r=SERVO_AXIS_RADIUS,
             h=SERVO_TOTAL_HEIGHT);
    
    // horn
    translate([-SERVO_HORN_DIAMETER/2,
               -SERVO_AXIS_RADIUS,
               SERVO_TAB_BOTTOM_TO_HORN_HEIGHT-SERVO_HORN_HEIGHT])
    cube([SERVO_HORN_DIAMETER, SERVO_AXIS_RADIUS*2, SERVO_HORN_HEIGHT]);
}

module servo_cavities(short_cavity=false) {
    // servo
    difference() {
        translate([SERVO_OFFSET_X-SERVO_TAB_WIDTH_EXCESS_2,
                   -SERVO_BODY_WIDTH/2,
                   0])
        cube([SERVO_BODY_LENGTH + SERVO_TAB_WIDTH_EXCESS_1 + SERVO_TAB_WIDTH_EXCESS_2,
              SERVO_BODY_WIDTH,
              -SERVO_TAB_OFFSET_Z]);
        servo_screw_cavity();
    }

    
    // cable vertical pit
    translate([-SUPPORT_DIAMETER/2 + SERVO_CABLE_CAVITY_OFFSET_FROM_BORDER,
               -SERVO_CABLE_CAVITY_WIDTH/2,
               -SERVO_BODY_HEIGHT-SERVO_TAB_OFFSET_Z - SERVO_CAVITY_BOTTOM_EXTENT])
    cube([SERVO_CABLE_CAVITY_THICKNESS,
          SERVO_CABLE_CAVITY_WIDTH,
          SERVO_BODY_HEIGHT+SERVO_CAVITY_BOTTOM_EXTENT]);

    // cable horizontal gallery
    shift = CUBE_WIDTH/2 - SUPPORT_DIAMETER/2;
    cavity_2_len = SUPPORT_DIAMETER/2 - (short_cavity
                                         ? SERVO_CABLE_CAVITY_OFFSET_FROM_BORDER
                                         : -shift);
    translate([-SUPPORT_DIAMETER/2 + (short_cavity ? SERVO_CABLE_CAVITY_OFFSET_FROM_BORDER : -shift),
               -SERVO_CABLE_CAVITY_WIDTH/2,
               -SERVO_BODY_HEIGHT-SERVO_TAB_OFFSET_Z]) {
        rotate([0, 90, 0])
        cube([SERVO_CABLE_CAVITY_THICKNESS, SERVO_CABLE_CAVITY_WIDTH, cavity_2_len]);
    }

    // main body
    translate([SERVO_OFFSET_X - PLAY,
               -SERVO_BODY_WIDTH/2 - PLAY,
               -SERVO_BODY_HEIGHT -SERVO_TAB_OFFSET_Z 
                - SERVO_CAVITY_BOTTOM_EXTENT])
    cube([SERVO_BODY_LENGTH + PLAY*2,
          SERVO_BODY_WIDTH + PLAY*2,
          SERVO_BODY_HEIGHT + SERVO_CAVITY_BOTTOM_EXTENT]);

    // side space
    translate([SERVO_OFFSET_X + SERVO_BODY_CAVITY_OFFSET_X,
               -SERVO_BODY_WIDTH/2 - SERVO_BODY_CAVITY_OFFSET_Y,
               -SERVO_BODY_HEIGHT -SERVO_TAB_OFFSET_Z - SERVO_CAVITY_BOTTOM_EXTENT])
    cube([SERVO_BODY_LENGTH - SERVO_BODY_CAVITY_OFFSET_X*2,
          SERVO_BODY_WIDTH + SERVO_BODY_CAVITY_OFFSET_Y*2,
          SERVO_BODY_HEIGHT + SERVO_CAVITY_BOTTOM_EXTENT]);
}

module servo_screw_cavity(is_clearance_hole=false) {
    servo_screw(SERVO_SCREW1_H_DISPLACEMENT,
                -ATOM,
                SERVO_SCREW_HEAD_EXTENT, is_clearance_hole);
    servo_screw(SERVO_SCREW2_H_DISPLACEMENT,
                -ATOM,
                SERVO_SCREW_HEAD_EXTENT, is_clearance_hole);
}

module servo_screw(distance_to_axis, z, head_extent, is_clearance_hole) {   
    translate([distance_to_axis, 0, z])
    screw(head_extent, is_clearance_hole, SERVO_SCREW_IS_HEADLESS);
}
