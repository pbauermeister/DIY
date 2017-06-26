

$fn=90;

TABS = [
    // top plate
    [1, 2, 3, 3, 2, 4, 4, 3, 1, 1],
    
    // middle plate
    [1, 2, 3, 3, 3, 3, 3, 2, 3, 3],
    
    // bottom plate
    [1, 2, 3, 4, 2, 4, 1, 2, 1, 2],
];

F = 0.5;

ROTATION_STEP = 15; // degree

ENCODER_RADIUS = 25;
ENCODER_HEIGHT = 80 *F;
ENCODER_THICKNESS = 1.5;

ENCODER_ROTATION = -ROTATION_STEP * 10 * abs(sin($t*360));
ENCODER_ROTATION = -ROTATION_STEP * 0;

TAB_VSIZE = 3 *F;
TAB_HSIZE = 4;
TAB_SPACING = 4 *F;

PLAY = 0.3;
BODY_RADIUS = 30;
BODY_THICKNESS = 1;
BODY_WINDOW_MARGIN = 4;
BODY_MARGIN = 5;
BODY_GUIDE = 5;
BODY_HEIGHT = ENCODER_HEIGHT + BODY_MARGIN;

SERVO_HEIGHT = 26;
SERVO_BODY_HEIGHT = 20;
SERVO_BODY_WIDTH = 28;
SERVO_BODY_THICKNESS = 9;
//SERVO_AXIS_SHIFT = 4 -SERVO_BODY_WIDTH/2;
SERVO_AXIS_SHIFT = 4;
SERVO_AXIS_RADIUS = 2;

SERVO_CLEARANCE = 10;
SERVO_HOLDER_HEIGHT = BODY_HEIGHT - SERVO_CLEARANCE;
SERVO_HOLDER_THICKNESS = 2;

ENCODER_DISPLACEMENT = BODY_RADIUS-ENCODER_RADIUS-BODY_THICKNESS;
ATOM = 0.01;

module body() {
    difference() {
        union() {
            // body
            scale([1, 1, BODY_HEIGHT])
            cylinder(r=BODY_RADIUS, h=1, true);
            translate([0, ENCODER_DISPLACEMENT, 0])
            servo_holder();
        }
        
        // encoder cavity
        translate([0, ENCODER_DISPLACEMENT, BODY_MARGIN])
        scale([1, 1, BODY_HEIGHT])
        cylinder(r=ENCODER_RADIUS+PLAY, h=1, true);

        // window
        translate([0, 0, BODY_WINDOW_MARGIN + BODY_MARGIN])
        scale([1, 1, ENCODER_HEIGHT-BODY_WINDOW_MARGIN*2])
        translate([0, BODY_RADIUS, 0])
        cylinder(r=TAB_HSIZE/1.5, h=1, true);        
    }    
}
    
    
module encoder() {
    rotate([0, 0, ENCODER_ROTATION])
    difference() {
        // body
        scale([1, 1, ENCODER_HEIGHT])
        cylinder(r=ENCODER_RADIUS, h=1, true);
        
        // cavity
        encoder_cavity();
        
        // servo axis
        translate([0, 0, ENCODER_HEIGHT - SERVO_HEIGHT])
        servo_hull();

        // codes
        for (i=[0:9]) {
            top = TABS[0][i]+1;
            mid = TABS[1][i]+1;
            bot = TABS[2][i]+1;

            rotate([0, 0, 90 + ROTATION_STEP*i]) {
                translate([ENCODER_RADIUS, 0, ENCODER_HEIGHT/3*2 + TAB_SPACING*top])
                cube([TAB_HSIZE, TAB_HSIZE, TAB_VSIZE], true);

                translate([ENCODER_RADIUS, 0, ENCODER_HEIGHT/3*1 + TAB_SPACING*mid])
                cube([TAB_HSIZE, TAB_HSIZE, TAB_VSIZE], true);

                translate([ENCODER_RADIUS, 0, ENCODER_HEIGHT/3*0 + TAB_SPACING*bot])
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

module servo_holder() {
    difference() {
        union() {
            // guiding disc
            scale([1, 1, BODY_GUIDE + BODY_MARGIN])
            cylinder(r=ENCODER_RADIUS-ENCODER_THICKNESS - PLAY, h=1, true);
            
//            // attachment column
//            translate([0, -8-5, SERVO_HOLDER_HEIGHT/2])
//            cube([12, 40, SERVO_HOLDER_HEIGHT], true);
            
            // central column
            translate([0, SERVO_AXIS_SHIFT, SERVO_HOLDER_HEIGHT/2])
            cube([SERVO_BODY_THICKNESS + SERVO_HOLDER_THICKNESS*2,
                  SERVO_BODY_WIDTH + SERVO_HOLDER_THICKNESS*2,
                  SERVO_HOLDER_HEIGHT], true);
        }

        translate([0, 0, BODY_HEIGHT - SERVO_HEIGHT])
        servo_hull();
    }
}

module servo_hull() {    
    translate([0, SERVO_AXIS_SHIFT, SERVO_BODY_HEIGHT/2])
    cube([SERVO_BODY_THICKNESS, SERVO_BODY_WIDTH, SERVO_BODY_HEIGHT], true);

    scale([1, 1, SERVO_HEIGHT + ATOM])
    cylinder(r=SERVO_AXIS_RADIUS, h=1);
}

module move_apart(upside_down, displacement, elevation) {    
    translate([0, displacement, elevation])
    rotate([upside_down ? 180 : 0, 0, 0])
    children();
    }

body();

translate([0, ENCODER_DISPLACEMENT, 0])
servo_holder();

    
move_apart(true, 70, ENCODER_HEIGHT+BODY_MARGIN)
translate([0, ENCODER_DISPLACEMENT, BODY_MARGIN])
encoder();

