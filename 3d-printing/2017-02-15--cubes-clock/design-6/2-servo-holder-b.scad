

$fn=90;
CROSS_CUT = false;

Z_SHRINK_FACTOR = 3;

TABS = [
    // top plate
    [1, 2, 3, 3, 2, 4, 4, 3, 1, 1],

    // middle plate
    [1, 2, 3, 3, 3, 3, 3, 2, 3, 3],

    // bottom plate
    [1, 2, 3, 4, 2, 4, 1, 2, 1, 2],
];

F = 0.5;
F = 1;

APART = false;

PLAY = 0.4;

ROTATION_STEP = 15; // degree

ENCODER_RADIUS = 20 - PLAY/2;

ENCODER_HEIGHT = 80 *F;
ENCODER_THICKNESS = 1.5 - PLAY/2;

ENCODER_ROTATION = -ROTATION_STEP * 10 * abs(sin($t*360));
//ENCODER_ROTATION = -ROTATION_STEP * 0;

TAB_VSIZE = 4 *F;
TAB_HSIZE = 3.5;
TAB_SPACING = 4.5 *F;

BODY_RADIUS = 25;
BODY_THICKNESS = 1;
BODY_WINDOW_MARGIN = 2;
BODY_MARGIN = 2;
BODY_GUIDE = 2; // <== TODO: Snapping ring
BODY_HEIGHT = ENCODER_HEIGHT + BODY_MARGIN;

SERVO1_HEIGHT = 26;
SERVO1_BODY_HEIGHT = 20;
SERVO1_BODY_WIDTH = 28;
SERVO1_BODY_WIDTH_CLEARANCE = 0; //2;
SERVO1_BODY_THICKNESS = 8.4;
SERVO1_BODY_THICKNESS_CLEARANCE = 4;
SERVO1_AXIS_SHIFT = 8 - SERVO1_BODY_WIDTH/2;
SERVO1_AXIS_RADIUS = 1.95;
SERVO1_CLEARANCE = 6.5;
SERVO1_HOLDER_HEIGHT = BODY_HEIGHT - SERVO1_CLEARANCE;
SERVO1_HOLDER_THICKNESS = 2;
SERVO1_BOTTOM_BODY_HEIGHT = 15;
SERVO1_BOTTOM_BODY_WIDTH = 19.8;

SERVO2_HEIGHT = 30;
SERVO2_BODY_HEIGHT = 22.5;
SERVO2_BODY_WIDTH = 32.3;
SERVO2_BODY_WIDTH_CLEARANCE = 0;
SERVO2_BODY_THICKNESS = 12.6;
SERVO2_BODY_THICKNESS_CLEARANCE = 5;
SERVO2_AXIS_SHIFT = SERVO2_BODY_WIDTH/2 -10;
SERVO2_AXIS_RADIUS = 2.5;
SERVO2_CLEARANCE = 12.5;
SERVO2_HOLDER_HEIGHT = BODY_HEIGHT - SERVO2_CLEARANCE;
SERVO2_HOLDER_THICKNESS = 2;
SERVO2_DISPLACEMENT = -7+1;
SERVO2_BOTTOM_BODY_HEIGHT = 15.5;
SERVO2_BOTTOM_BODY_WIDTH = 23.2;

ENCODER_DISPLACEMENT = BODY_RADIUS-ENCODER_RADIUS-BODY_THICKNESS -PLAY/2;

SUPPORT_THICKNESS = 1.5;

ATOM = 0.01;


module body_encoder_cavity() {
    translate([0, ENCODER_DISPLACEMENT, BODY_MARGIN])
    scale([1, 1, BODY_HEIGHT])
    cylinder(r=ENCODER_RADIUS+PLAY, h=1, true);
}

module body_window() {
    translate([0, 0, BODY_WINDOW_MARGIN + BODY_MARGIN])
    scale([1, 1, ENCODER_HEIGHT-BODY_WINDOW_MARGIN*2])
    translate([0, BODY_RADIUS, 0])
    cylinder(r=TAB_HSIZE/1.5, h=1, true);
}

module body_servo_holder() {
    translate([0, ENCODER_DISPLACEMENT, 0])
    servo_holder(max(SERVO1_BODY_WIDTH, SERVO2_BODY_WIDTH),
                 max(SERVO1_BODY_THICKNESS, SERVO2_BODY_THICKNESS));
}

module body_servo1_cavity() {
    translate([0, ENCODER_DISPLACEMENT, BODY_HEIGHT - SERVO1_HEIGHT]) {
        servo1_hull();
        servo1_hull2(BODY_HEIGHT);
    }
}

module body_encoder_border_cavity() {
    translate([0, ENCODER_DISPLACEMENT - PLAY/2, BODY_MARGIN])
    scale([1, 1, BODY_HEIGHT])
    difference() {
        cylinder(r=ENCODER_RADIUS+PLAY, h=1, true);
        cylinder(r=ENCODER_RADIUS-ENCODER_THICKNESS-PLAY, h=1, true);
    }
}

module body_spine() {
    spine_width = ENCODER_THICKNESS*3;
    if(1)
    translate([0, -ENCODER_RADIUS + ENCODER_DISPLACEMENT + ENCODER_THICKNESS/2, 0])
    scale([1, spine_width , BODY_HEIGHT - SERVO1_HEIGHT])
    translate([0, 0, 0.5])
    cube(1, true);                
}

module body_servo2_cavity() {
    translate([0, SERVO2_DISPLACEMENT, 0]) {
        servo2_hull();
    }        
}

module body_servo2_pillars() {
    translate([0, SERVO2_DISPLACEMENT, 0]) {
        servo2_pillars();
    }        
}

module body() {
    difference() {
        union() {
            difference() {
                union() {
                    %
                    difference() {
                        // body
                        scale([1, 1, BODY_HEIGHT])
                        cylinder(r=BODY_RADIUS, h=1, true);

                        body_encoder_cavity();
                        body_window();
                    }
                    body_servo_holder();
                }
                body_servo1_cavity();
                body_encoder_border_cavity();
            }
            body_spine();
        }
        body_servo2_cavity();
    }
    body_servo2_pillars();
}


module encoder() {
    rotate([0, 0, ENCODER_ROTATION])
    difference() {
        // body
        scale([1, 1, ENCODER_HEIGHT - PLAY])
        cylinder(r=ENCODER_RADIUS, h=1, true);

        // cavity
        encoder_cavity();

        // servo axis
        translate([0, 0, ENCODER_HEIGHT - SERVO1_HEIGHT])
        servo1_hull();

        // codes
        for (i=[0:9]) {
            top = TABS[0][i]+1;
            mid = TABS[1][i]+1;
            bot = TABS[2][i]+1;

            rotate([0, 0, 90 + ROTATION_STEP*i]) {
                translate([ENCODER_RADIUS, 0, ENCODER_HEIGHT/6*5 + TAB_SPACING*(top-3)])
                cube([TAB_HSIZE, TAB_HSIZE, TAB_VSIZE], true);

                translate([ENCODER_RADIUS, 0, ENCODER_HEIGHT/6*3 + TAB_SPACING*(mid-4)])
                cube([TAB_HSIZE, TAB_HSIZE, TAB_VSIZE], true);

                translate([ENCODER_RADIUS, 0, ENCODER_HEIGHT/6*1 + TAB_SPACING*(bot-4)])
                cube([TAB_HSIZE, TAB_HSIZE, TAB_VSIZE], true);
            }
        }
    }

}


module encoder_cavity() {
    // remove center
    translate([0, 0, -ATOM])
    scale([1, 1, ENCODER_HEIGHT-ENCODER_THICKNESS + ATOM*2])
    cylinder(r=ENCODER_RADIUS-ENCODER_THICKNESS, h=1, true);

    // remove quarter 1
    rotate([0, 0, -ROTATION_STEP*1.5])
    translate([0, -ATOM, -ATOM])
    scale([ENCODER_RADIUS*2, ENCODER_RADIUS*2+ATOM, ENCODER_HEIGHT-ENCODER_THICKNESS+ATOM*2])
    cube(1);

    // remove quarter 2
    rotate([0, 0, -ROTATION_STEP*7.5])
    translate([0, 0, -ATOM])
    scale([ENCODER_RADIUS*2, ENCODER_RADIUS*2, ENCODER_HEIGHT-ENCODER_THICKNESS+ATOM*2])
    cube(1);
}

module servo_holder(width, thickness) {
    union() {
        // guiding disc
        scale([1, 1, BODY_GUIDE + BODY_MARGIN])
        cylinder(r=ENCODER_RADIUS-ENCODER_THICKNESS - PLAY, h=1, true);

        // central column
        translate([0, SERVO1_AXIS_SHIFT, SERVO1_HOLDER_HEIGHT/2])
        cube([thickness + SERVO1_HOLDER_THICKNESS*2,
              width + SERVO1_HOLDER_THICKNESS*5,
              SERVO1_HOLDER_HEIGHT], true);
    }
}


module servo1_hull() {
    servo_hull(SERVO1_AXIS_RADIUS,
               SERVO1_AXIS_SHIFT,
               SERVO1_BODY_HEIGHT,
               SERVO1_BODY_THICKNESS, SERVO1_BODY_THICKNESS_CLEARANCE,
               SERVO1_BODY_WIDTH, SERVO1_BODY_WIDTH_CLEARANCE,
               SERVO1_BOTTOM_BODY_HEIGHT,
               SERVO1_BOTTOM_BODY_WIDTH,
               SERVO1_HEIGHT,
               SERVO1_HOLDER_THICKNESS,
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
               SERVO2_BODY_THICKNESS, SERVO2_BODY_THICKNESS_CLEARANCE,
               SERVO2_BODY_WIDTH, SERVO2_BODY_WIDTH_CLEARANCE,
               SERVO2_BOTTOM_BODY_HEIGHT,
               SERVO2_BOTTOM_BODY_WIDTH,
               SERVO2_HEIGHT,
               SERVO2_HOLDER_THICKNESS,
               true);
}

module servo2_pillars() {
    servo_pillars(SERVO2_AXIS_RADIUS,
                  SERVO2_AXIS_SHIFT,
                  SERVO2_HEIGHT,
                  SERVO2_BODY_THICKNESS, SERVO2_BODY_THICKNESS_CLEARANCE,
                  SERVO2_BODY_WIDTH, SERVO2_BODY_WIDTH_CLEARANCE,
                  SERVO2_BOTTOM_BODY_HEIGHT,
                  SERVO2_BOTTOM_BODY_WIDTH,
                  SERVO2_HEIGHT,
                  SERVO2_HOLDER_THICKNESS);
}


module servo_hull(servo_axis_radius,
                  servo_axis_shift,
                  servo_body_height,
                  servo_body_thickness,
                  servo_body_thickness_clearance,
                  servo_body_width,
                  servo_body_width_clearance,
                  servo_bottom_body_height,
                  servo_bottom_body_width,
                  servo_height,
                  servo_holder_thickness,
                  upside_down)
{
    // body
    delta_h = servo_body_height - servo_bottom_body_height;

    translate([0, servo_axis_shift,
               upside_down ? delta_h/2 : delta_h/2 + servo_bottom_body_height])
    cube([servo_body_thickness, servo_body_width, delta_h], true);

    translate([0, servo_axis_shift,
               upside_down ? servo_height - servo_bottom_body_height/2 : servo_bottom_body_height/2])
    cube([servo_body_thickness, servo_bottom_body_width, servo_bottom_body_height], true);

    // clearances
    translate([0, servo_axis_shift, servo_height/2])
    cube([servo_body_thickness+servo_holder_thickness*5,
          servo_body_width_clearance,
          servo_height], true);
    translate([0, servo_axis_shift, servo_height/2])
    cube([servo_body_thickness_clearance,
          servo_body_width + servo_holder_thickness*2,
          servo_height], true);

    // axis
    scale([1, 1, servo_height + ATOM])
    cylinder(r=servo_axis_radius, h=1);
}


module servo_pillars(servo_axis_radius,
                     servo_axis_shift,
                     servo_body_height,
                     servo_body_thickness,
                     servo_body_thickness_clearance,
                     servo_body_width,
                     servo_body_width_clearance,
                     servo_bottom_body_height,
                     servo_bottom_body_width,
                     servo_height,
                     servo_holder_thickness)
{
    // body
    delta_h = servo_body_height - servo_bottom_body_height;

    difference() {
        // support pillar
        translate([0, servo_axis_shift, delta_h/2])        
        difference() {
            cube([servo_body_thickness_clearance+SUPPORT_THICKNESS*2, 
                  servo_bottom_body_width+SUPPORT_THICKNESS*2, delta_h], true);
            cube([servo_body_thickness, servo_bottom_body_width, delta_h], true);
        }

        // clearance
        translate([0, servo_axis_shift, servo_height/2])
        cube([servo_body_thickness_clearance,
              servo_body_width + servo_holder_thickness*2,
              servo_height], true);
    }
}


module servo_hull2(extent,
                   servo_axis_shift,
                   servo_body_thickness,
                   servo_body_width,
                   ) {
                       if(0)
    translate([0, servo_axis_shift, extent/2])
    cube([servo_body_thickness, servo_body_width, extent], true);
}


module move_apart(upside_down, displacement, elevation) {
    translate([0, APART ? displacement : 0, APART ? elevation : 0])
    rotate([upside_down && APART ? 180 : 0, 0, 0])
    children();
    }

module all() {
    body();

    if(0)
    move_apart(true, 70, ENCODER_HEIGHT + BODY_MARGIN - PLAY)
    translate([0, ENCODER_DISPLACEMENT, BODY_MARGIN])
    encoder();
}



scale([1, 1, 1/Z_SHRINK_FACTOR])
{
    intersection() {
        all();

        if(CROSS_CUT)
            scale(200)
            translate([0.5, 0, 0])
            cube(1, true);
    }

    if(0) color("yellow") body_servo2_cavity();
}
