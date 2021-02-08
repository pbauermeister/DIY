include <definitions.scad>
use <servo.scad>

module servo1(with_cavities=false, short_cavity=false) {
    height = CUBE_HEIGHT / 2 + CUBE_RAISE -SERVO_TAB_BOTTOM_TO_HORN_HEIGHT;
    translate([0, 0, height-CUBE_RAISE])
    servo(with_cavities=with_cavities, short_cavity=short_cavity);
}

module servo2(with_cavities=false, short_cavity=false) {
    translate([0, 0, CUBE_HEIGHT/2])
    rotate([180, 0, 0])
    translate([0, 0, -SERVO_TAB_BOTTOM_TO_HORN_HEIGHT])
    servo(with_cavities=with_cavities, short_cavity=short_cavity);
}

module servo3(with_cavities=false, short_cavity=false) {
    translate([0, 0, CUBE_HEIGHT*2-SERVO_TAB_BOTTOM_TO_HORN_HEIGHT-SERVO_TOP_TO_CUBE_MARGIN])
    servo(with_cavities=with_cavities, short_cavity=short_cavity);
}

module support_bottom() {
    height = CUBE_HEIGHT / 2 + CUBE_RAISE -SERVO_TAB_BOTTOM_TO_HORN_HEIGHT;
    echo("support_bottom height", height);
    difference() {
        translate([0, 0, -CUBE_RAISE]) 
        cylinder(d=SUPPORT_DIAMETER, h=height);

        servo1(with_cavities=true);
    }
}

module adhesion() {
    // ribbed bottom surface for moderate adhesion
    rotate([0, 0, 45])
    difference() {
        cylinder(d=SUPPORT_DIAMETER-2, h=.3);
        for (i=[-CUBE_WIDTH/2:1:CUBE_WIDTH/2]) {
            translate([-CUBE_WIDTH/2, i, -CUBE_HEIGHT/2])
            cube([CUBE_WIDTH, 0.5, CUBE_HEIGHT]);
        }
    }
}

module support_mid() {
    height = CUBE_HEIGHT/2 - SERVO_TAB_BOTTOM_TO_HORN_HEIGHT;
    
    difference() {
        union() {
            translate([0, 0, CUBE_HEIGHT-height])
            cylinder(d=SUPPORT_DIAMETER, h=height);
            translate([0, 0, CUBE_HEIGHT])
            cylinder(d=SUPPORT_DIAMETER,
                     h=CUBE_HEIGHT-SERVO_TAB_BOTTOM_TO_HORN_HEIGHT
                       -SERVO_TOP_TO_CUBE_MARGIN);
        }
        servo2(with_cavities=true, short_cavity=true);
        servo3(with_cavities=true, short_cavity=true);
    }
}

module cubes() {
    translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, ])
    cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

//    translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, CUBE_HEIGHT+.1])
    //cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);
}

module cube_upper() {
    inner_width = CUBE_WIDTH - CUBE_WALL_THICKNESS*2;
    inner_height = CUBE_HEIGHT - CUBE_WALL_THICKNESS;

    // walls
    color("#eeeeee")
    difference() {
        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, CUBE_HEIGHT])
        cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

        translate([-inner_width/2, -inner_width/2, CUBE_HEIGHT])
        cube([inner_width, inner_width, inner_height]);
    }
    
    r1 = CUBE_WIDTH/2 - WALL_THICKNESS - (SPACING/2);
    r2 = CUBE_WIDTH/2 * sqrt(2) - WALL_THICKNESS;
    h = (r2 - r1) * 1.5;

    horn_heigh = SERVO_TOTAL_HEIGHT - SERVO_BODY_HEIGHT;
    ceiling_thickness = horn_heigh/2;

    // bottom chamfer
    thickness = 1;
    difference() {
        translate([-inner_width/2, -inner_width/2, CUBE_HEIGHT])
        cube([inner_width, inner_width, h+thickness]);

        translate([0, 0, CUBE_HEIGHT+thickness])
        cylinder(r1=r1, r2=r2, h=h+ATOM);

        translate([0, 0, CUBE_HEIGHT-ATOM])
        cylinder(r1=r1, r2=r1, h=thickness+ATOM*2);
    }
    
    // top chamfer
    translate([0, 0, CUBE_HEIGHT-h-WALL_THICKNESS-ceiling_thickness])
    difference() {
        translate([-inner_width/2, -inner_width/2, CUBE_HEIGHT])
        cube([inner_width, inner_width, h]);

        translate([0, 0, CUBE_HEIGHT])
        cylinder(r1=r2, r2=r1, h=h+ATOM);
    }

    // ceiling
    difference() {
        translate([-CUBE_WIDTH/2,
                   -CUBE_WIDTH/2,
                   CUBE_HEIGHT*2 - SERVO_TOP_TO_CUBE_MARGIN-ceiling_thickness])
        cube([CUBE_WIDTH, CUBE_WIDTH,
              SERVO_TOP_TO_CUBE_MARGIN+ceiling_thickness]);
        translate([0,
                   0,
                   CUBE_HEIGHT*2 - SERVO_TOP_TO_CUBE_MARGIN-ceiling_thickness-ATOM])
        horn_cross(.3, ceiling_thickness+PLAY);
    }
}

module horn_cross(d, h) {
    rotate([0, 0, 90])
    translate([-HORN_CROSS_WIDTH/2-d/2, -HORN_ARM_THICKNESS/2-d/2, 0])
    cube([HORN_CROSS_WIDTH+d, HORN_ARM_THICKNESS+d, h]);

    translate([-HORN_CROSS_WIDTH/2-d/2, -HORN_ARM_THICKNESS/2-d/2, 0])
    cube([HORN_CROSS_WIDTH+d, HORN_ARM_THICKNESS+d, h]);
}

module servos() {
    color("brown") servo1();
    color("red") servo2();
    color("#ff4020") servo3();
}


intersection() {
    union() {
        support_bottom();
        support_mid();
        %servos();
        //%cubes();
        translate([0, 0, .2]) cube_upper();
    }
    
    //rotate([0, 0, 45]) 
    translate([-75, 0, -20]) cube(150);  // vertical cross-cut
    //translate([-75, -75, -75]) cube(150);  // vertical cross-cut

}
