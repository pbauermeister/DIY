include <definitions.scad>

module servo(with_cavities=false) {
    servo_hull();
    if (with_cavities) {
        servo_screw_cavity();
        servo_cavities();
    }
}

servo(with_cavities=false);

module servo_hull(with_clearance=false, with_cable_slot=false) {
    // tab
    difference() {
        translate([SERVO_OFFSET_X-SERVO_TAB_WIDTH_EXCESS,
                   -SERVO_BODY_WIDTH/2,
                   0])
        cube([SERVO_BODY_LENGTH+2*SERVO_TAB_WIDTH_EXCESS,
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

module servo_cavities() {
    // cable pit
    offset_x = -SERVO_TAB_WIDTH_EXCESS - SERVO_CABLE_CAVITY_THICKNESS-SERVO_CABLE_CAVITY_THICKNESS_OFFSET_X;
    translate([SERVO_OFFSET_X+offset_x,
               -SERVO_BODY_WIDTH/2,
               -SERVO_BODY_HEIGHT-SERVO_TAB_OFFSET_Z - SERVO_CAVITY_BOTTOM_EXTENT])
    cube([SERVO_CABLE_CAVITY_THICKNESS,
          SERVO_BODY_WIDTH,
          SERVO_BODY_HEIGHT+SERVO_CAVITY_BOTTOM_EXTENT]);

    // cable pit 2
    /*
    translate([SERVO_OFFSET_X+offset_x+SERVO_CABLE_CAVITY_THICKNESS -ATOM,
               -SERVO_BODY_WIDTH/2,
               -SERVO_BODY_HEIGHT-SERVO_TAB_OFFSET_Z-SERVO_CABLE_CAVITY_THICKNESS])
    cube([SERVO_BODY_LENGTH,
          SERVO_BODY_WIDTH,
          SERVO_CABLE_CAVITY_THICKNESS]); */
    translate([SERVO_OFFSET_X+offset_x+SERVO_CABLE_CAVITY_THICKNESS -ATOM,
               0,
               -SERVO_BODY_HEIGHT-SERVO_TAB_OFFSET_Z-SERVO_BODY_WIDTH/2])
    rotate([0, 90, 0])
    cylinder(d=SERVO_BODY_WIDTH, h=SERVO_BODY_LENGTH);

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
