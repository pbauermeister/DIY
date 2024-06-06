include <defs.scad>

////////////////////////////////////////////////////////////////////////////////
// Helpers

module chamferer() {
    intersection() {
        sphere(r=CHAMFER, $fn=10*6);
        cylinder(r=CHAMFER*2, h=CHAMFER*2);
    }
}

module threadable_hole(d, h, k) {
    cylinder(d=2, h=h, $fn=24);

    w = d * 2.5 * k;
    l = .15;
    intersection() {
        union() {
            for (a=[0:45/2:360]) {
                rotate([0, 0, a])
                translate([0, -l/2, 0])
                cube([w, l, h]);
            }
        }
        if (!$preview) cube([w, w, h*3], center=true);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Switchbox

module switchbox(with_buttons=true) {
    hull() {
        translate([-SWITCHBOX_SIDE_BACK/2, -SWITCHBOX_SIDE_BACK/2, 0])
        cube([SWITCHBOX_SIDE_BACK, SWITCHBOX_SIDE_BACK, ATOM]);

        translate([-SWITCHBOX_SIDE_FRONT/2, -SWITCHBOX_SIDE_FRONT/2,
                  SWITCHBOX_DEPTH-ATOM])
        cube([SWITCHBOX_SIDE_FRONT, SWITCHBOX_SIDE_FRONT, ATOM]);
    }

    margin = 17;
    w = SWITCHBOX_SIDE_FRONT-margin*2;
    if (with_buttons) {
        translate([-w/2, -w/2, SWITCHBOX_DEPTH])
        difference() {
            cube([w, w, SWITCHBOX_BUTTONS_TRAVEL]);
            translate([-w/2, w/2-.5/2, 0])
            cube([w*2, .5, SWITCHBOX_BUTTONS_TRAVEL*2]);
        }
    }

    // cable canal
    translate([-SWITCHBOX_SIDE_FRONT/2-CABLE_CANAL_WIDTH, -SWITCHBOX_SIDE_BACK, 0])
    cube([CABLE_CANAL_WIDTH, SWITCHBOX_SIDE_BACK*2, CABLE_CANAL_THICKNESS]);
}
 
////////////////////////////////////////////////////////////////////////////////
// Servo

module servo_body(top_clearance=0, side_clearance=0, with_cable_clearance=true) {
    cube([SERVO_BODY_WIDTH+side_clearance, SERVO_BODY_LENGTH, SERVO_BODY_HEIGHT]);

    translate([0, -SERVO_TABS_LENGTH, SERVO_TABS_ELEVATION]) {
        cube([SERVO_BODY_WIDTH+side_clearance, SERVO_BODY_LENGTH+SERVO_TABS_LENGTH*2, SERVO_TABS_THICKNESS]);

        translate([SERVO_BODY_WIDTH/2-SERVO_TABS_THICKNESS, SERVO_TABS_LENGTH/2, SERVO_TABS_THICKNESS])
        cube([SERVO_TABS_THICKNESS*2+side_clearance, SERVO_BODY_LENGTH+SERVO_TABS_LENGTH, SERVO_TABS_THICKNESS]);
    }
    
    if (top_clearance) {
        translate([-TOLERANCE, -SERVO_TABS_LENGTH-TOLERANCE, SERVO_TABS_ELEVATION])
        cube([SERVO_BODY_WIDTH+side_clearance+TOLERANCE*2,
              SERVO_BODY_LENGTH+SERVO_TABS_LENGTH*2+TOLERANCE*2,
              top_clearance]);
    }
    
    if (with_cable_clearance) {
        translate([SERVO_BODY_WIDTH/2-SERVO_CABLE_CLEARANCE_WIDTH/2, -SERVO_TABS_LENGTH, 0])
        cube([SERVO_CABLE_CLEARANCE_WIDTH, SERVO_BODY_LENGTH+SERVO_TABS_LENGTH*2, SERVO_BODY_HEIGHT]);
    }

}

module servo(top_clearance=0, arm_lateral_clearance=0, arm_vertical_clearance=0,
             axis_clearance_diameter=0, axis_clearance_length=0, side_clearance=0, with_body=true) {

    if (with_body)
    translate([-SERVO_BODY_WIDTH/2, -SERVO_BODY_LENGTH+SERVO_AXIS_FROM_EDGE, 0]) {
        translate([side_clearance<0?side_clearance:0, 0, 0])
        servo_body(top_clearance, abs(side_clearance));
               
        if (top_clearance || arm_lateral_clearance || arm_vertical_clearance) {
            // screw holes
            extra = (SERVO_SCREWS_YDIST-SERVO_BODY_LENGTH)/2;
            for (pos=[
                        [SERVO_BODY_WIDTH/2 - SERVO_SCREWS_XDIST/2, extra],
                        [SERVO_BODY_WIDTH/2 + SERVO_SCREWS_XDIST/2, extra],

                        [SERVO_BODY_WIDTH/2 - SERVO_SCREWS_XDIST/2, -SERVO_BODY_LENGTH-extra],
                        [SERVO_BODY_WIDTH/2 + SERVO_SCREWS_XDIST/2, -SERVO_BODY_LENGTH-extra],
                    ])
            {
                x = pos[0]; //SERVO_BODY_WIDTH/2 - SERVO_SCREWS_XDIST/2;
                y = pos[1]; //SERVO_TABS_LENGTH/2;
                h = (SERVO_BODY_HEIGHT-SERVO_TABS_ELEVATION)*2 - SERVO_TABS_THICKNESS;
                translate([x, -y, SERVO_BODY_HEIGHT-h])
                threadable_hole(d=SERVO_SCREW_DIAMETER, h=h, k=1);
            }
        }
    }
    cylinder(d=SERVO_AXIS_DIAMETER, h=SERVO_ARM_ELEVATION);

    if (axis_clearance_diameter) {
        threadable_hole(d=axis_clearance_diameter,
                        h=SERVO_ARM_ELEVATION+SERVO_ARM_THICKNESS
                          +axis_clearance_length+arm_vertical_clearance,
                        k=2);
    }
    
    rotate([0, 0, SERVO_ARM_ROTATION])
    translate([-SERVO_ARM_SPAN/2, -SERVO_ARM_WIDTH/2, SERVO_ARM_ELEVATION])
    cube([SERVO_ARM_SPAN, SERVO_ARM_WIDTH, SERVO_ARM_THICKNESS]);
    
    if (arm_lateral_clearance || arm_vertical_clearance) {
        translate([0, 0, SERVO_ARM_ELEVATION-arm_vertical_clearance])
        cylinder(d=SERVO_ARM_SPAN+arm_lateral_clearance*2, SERVO_ARM_THICKNESS+arm_vertical_clearance*2);
    }
}



module servo_positioned(top_clearance=0,
                        arm_lateral_clearance=0, arm_vertical_clearance=0,
                        axis_clearance_diameter=0, axis_clearance_length=0,
                        side_clearance=0, with_body=true) {
    translate([MARGIN, 0, -SERVO_POS_SINK])
    translate([SWITCHBOX_SIDE_FRONT/2, 0, SWITCHBOX_DEPTH+SWITCHBOX_BUTTONS_TRAVEL+SERVO_ARM_WIDTH/2])
    rotate([-90, 0, 0])  // lay flat
    rotate([0, -90, 0])
    translate([0, 0, -SERVO_ARM_ELEVATION-SERVO_ARM_THICKNESS])
    rotate([0, 0, -90 + 180])
    servo(top_clearance, arm_lateral_clearance, arm_vertical_clearance,
          axis_clearance_diameter, axis_clearance_length, side_clearance, with_body);
}

////////////////////////////////////////////////////////////////////////////////
// Enclosure

module enclosure() {
    w = ENCLOSURE_WIDTH - CHAMFER*2;
    l = ENCLOSURE_LENGTH - CHAMFER*2;
    h = ENCLOSURE_HEIGHT - CHAMFER;
    difference() {
        // encosure
        translate([-w/2, -w/2, 0])
        minkowski() {
            intersection() {
                cube([l, w, h]);

                // shave rounded corners
                translate([w/2+ENCLOSURE_EXTRA/2, w/2, -ATOM])
                cylinder(d=ENCLOSURE_LENGTH*1.0, h=ENCLOSURE_HEIGHT*2, $fn=180);
            }

            chamferer();
        }

        // encosure inner hollowing
       difference() {
            th = CHAMFER*.4;
            translate([-w/2-th, -w/2-th, CHAMFER])
            intersection() {
                cube([w+th*2, w+th*2, h-CHAMFER*2]);

                // shave rounded corners
                translate([w/2+ENCLOSURE_EXTRA/2, w/2, -ATOM])
                cylinder(d=ENCLOSURE_LENGTH*1.0, h=ENCLOSURE_HEIGHT*2, $fn=180);
            }
            // opposite side reinforcement
            cube([w*2, 20, h*3], center=true);
            // servo side reinforcement
            translate([SWITCHBOX_SIDE_BACK/2, -w, -ATOM])
            cube([w, w*2, w]);
        }

        // switch box
        minkowski() {
            switchbox(with_buttons=false);
            cube(TOLERANCE*2, center=true);
        }
        
        // servo
        servo_positioned(top_clearance=22.3 + 40, arm_lateral_clearance=2, arm_vertical_clearance=4.5,
                         side_clearance=30);

        // board
        board_positioned(true);

        // buttons holes
        for (z=[-1,1]) {
            for (y=[-1,1]) {
                translate([0, y*TOLERANCE, z*TOLERANCE])
                buttons_positioned(30, BUTTONS_PROTOBOARD_THICKNESS_CLEARANCE);
            }
        }
        
        // opposite hollowing
        opposite_arm_clearance_thickness = 7+3;
        opposite_arm_axis_length = 7-3;
        translate([-SWITCHBOX_SIDE_FRONT -TOLERANCE*2 -opposite_arm_clearance_thickness, 0, 0])
        servo_positioned(arm_lateral_clearance=2, arm_vertical_clearance=4.5,
                         axis_clearance_diameter=2, axis_clearance_length=opposite_arm_axis_length,
                         with_body=false);
        
        // protoboard blocker
        protoboard_blocker(true);

        // connectors
        connectors_chamber();
    }
    
    // board platform
    difference() {
        translate([0, 0, BOARD_THICKNESS])
        board_positioned(false);
        board_positioned(true);
    }
    //%board_positioned();

}


////////////////////////////////////////////////////////////////////////////////
// Board

module board(with_screws=false) {
    cube([BOARD_LENGTH, BOARD_WIDTH, BOARD_THICKNESS]);
    
    if (with_screws)
    for (x=[BOARD_SCREW_FROM_EDGE, BOARD_LENGTH-BOARD_SCREW_FROM_EDGE]) {
        for (y=[BOARD_WIDTH/2-BOARD_SCREW_SPACING/2, BOARD_WIDTH/2+BOARD_SCREW_SPACING/2]) {
            translate([x, y, BOARD_THICKNESS-ATOM])
            threadable_hole(d=BOARD_SCREW_DIAMETER, h=BOARD_SCREW_DEPTH, k=.9);
        }
    }
}

module board_positioned(with_screws=false) {
    translate([SWITCHBOX_SIDE_BACK/2+(ENCLOSURE_EXTRA+MARGIN-BOARD_WIDTH)/2 + MARGIN + .5, -ENCLOSURE_WIDTH/2+BOARD_LENGTH, -ATOM])
    rotate([0, 0, -90])
    board(with_screws);
}    

////////////////////////////////////////////////////////////////////////////////
// Buttons

module button() {
    cube([BUTTON_CASE_SIDE, BUTTON_CASE_SIDE, BUTTON_CASE_HEIGHT]);
    translate([BUTTON_CASE_SIDE/2, BUTTON_CASE_SIDE/2, BUTTON_CASE_HEIGHT])
    cylinder(d=BUTTON_KNOB_DIAMETER, h=BUTTON_KNOB_THICKNESS);

    translate([-BUTTON_CONTACT_EXCESS, 0, 0])
    cube([BUTTON_CASE_SIDE+BUTTON_CONTACT_EXCESS*2, BUTTON_CASE_SIDE, BUTTON_CONTACT_EXCESS]);
}

module buttons_positioned(extra_protoboard_x=0, thickness_clearance=0) {
    dy = -(BUTTON_CASE_SIDE*BUTTONS_NB+BUTTONS_SPACING*(BUTTONS_NB-1))/2;
    dx = -BUTTON_CASE_SIDE/2;
    dh = (ENCLOSURE_HEIGHT-BUTTONS_PROTOBOARD_WIDTH)/2;

    translate([(ENCLOSURE_LENGTH-ENCLOSURE_EXTRA)/2+ENCLOSURE_EXTRA, 0, BUTTONS_PROTOBOARD_WIDTH/2 + dh])
    rotate([0, 90, 0])
    translate([dx, dy, -BUTTON_CASE_HEIGHT+ATOM]) {
        for (i=[0:BUTTONS_NB-1]) {
            translate([0, i*(BUTTONS_SPACING+BUTTON_CASE_SIDE), 0])
            button();
        }

        // protoboard
        translate([-BUTTONS_PROTOBOARD_MARGIN_W, -BUTTONS_PROTOBOARD_MARGIN_L, -BUTTONS_PROTOBOARD_THICKNESS-+thickness_clearance])
        cube([BUTTONS_PROTOBOARD_WIDTH+extra_protoboard_x, BUTTONS_PROTOBOARD_LENGTH, BUTTONS_PROTOBOARD_THICKNESS+thickness_clearance]);
    }
}

module protoboard_blocker(is_hollowing=true) {
    extra = is_hollowing ? TOLERANCE/2 : 0;

    h = is_hollowing ? SWITCHBOX_DEPTH-PROTOBOARD_BLOCKER_MARGIN : SWITCHBOX_DEPTH/2;
    l = BUTTONS_PROTOBOARD_LENGTH+PROTOBOARD_BLOCKER_MARGIN + 8*extra;

    dx = -PROTOBOARD_BLOCKER_THICKNESS -BUTTON_CASE_HEIGHT - BUTTONS_PROTOBOARD_THICKNESS -extra;

    

    translate([(ENCLOSURE_LENGTH-ENCLOSURE_EXTRA)/2+ENCLOSURE_EXTRA + dx,
               -l/2, -ATOM ])

    cube([PROTOBOARD_BLOCKER_THICKNESS+extra*3, l, h]);
}

////////////////////////////////////////////////////////////////////////////////
// Binding

module binding() {
    difference() {
        minkowski() {
            union() {
                d = BINDING_DIAMETER-CHAMFER*2;
                h = BINDING_HEIGHT-CHAMFER;
                cylinder(d=d, h=h, $fn=60);
                translate([-d/2, 0, 0])
                cube([d, d/2, h]);
            }
            chamferer();
        }
        cylinder(d=BINDING_SCREW_DIAMETER, h=BINDING_HEIGHT*3, center=true, $fn=16);

        translate([0, 0, BINDING_HEIGHT-5])
        cylinder(d=BINDING_SCREW_HEAD_DIAMETER, h=BINDING_HEIGHT, $fn=32);
    }
}

module bindings() {
    x = ENCLOSURE_EXTRA/2;
    y = -SWITCHBOX_SIDE_BACK/2 - THICKNESS - BINDING_SCREW_HEAD_DIAMETER/2;

    translate([x, y, 0]) binding();
    translate([x, -y, 0]) rotate([0, 0, 180]) binding();
}

module connectors_chamber() {
    translate([ENCLOSURE_EXTRA/2 + BINDING_DIAMETER/2, -ENCLOSURE_WIDTH/2 +5, -ATOM ]) {
        cube([21, 4, 9]);
        translate([(21-14)/2, -20, 0])
        cube([14, 20, 5.5]);
        
        translate([21/4, 5, 5])
        rotate([0, 90, 0])
        cylinder(d=5, h=20);
    }
}

////////////////////////////////////////////////////////////////////////////////
// All

module cutout() {
    difference() {
        children();
        rotate([0, 0, 0]) translate([0, 0, -ATOM]) cube(1000);
    }
}

module all() {
    if (1) {
        %servo_positioned();
//        %switchbox();
        
        enclosure();
        %buttons_positioned();

        if (0)
            translate([-60, 0, 0])
            protoboard_blocker(false);
        
        bindings();

    } else if (0) {
        servo(top_clearance=40*1, arm_lateral_clearance=5);
    } else {
        connectors_chamber();
    }
}

//rotate([0, 180, 0])
//cutout()
all();
