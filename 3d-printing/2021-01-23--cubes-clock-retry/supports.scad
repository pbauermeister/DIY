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

    translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, CUBE_HEIGHT+.1])
    cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);
}

module servos() {
    color("brown") servo1();
    color("red") servo2();
    color("red") servo3();
}


intersection() {
    union() {
        support_bottom();
        support_mid();
        %servos();
        %cubes();
    }    
    translate([-250, 0, -50]) cube(500);  // cross-cut
}
