include <definitions.scad>
use <servo.scad>


module servo1(with_cavities=false) {
    height = CUBE_HEIGHT / 2 + CUBE_RAISE -SERVO_TAB_BOTTOM_TO_HORN_HEIGHT;
    translate([0, 0, height-CUBE_RAISE])
    servo(with_cavities=with_cavities);
}

module servo2(with_cavities=false) {
    translate([0, 0, CUBE_HEIGHT/2])
    rotate([180, 0, 0])
    translate([0, 0, -SERVO_TAB_BOTTOM_TO_HORN_HEIGHT])
    servo(with_cavities=with_cavities);
}

module servo3(with_cavities=false) {
    translate([0, 0, CUBE_HEIGHT*2-SERVO_TAB_BOTTOM_TO_HORN_HEIGHT-SERVO_TOP_TO_CUBE_MARGIN])
    servo(with_cavities=with_cavities);
}

module support_bottom() {
    height = CUBE_HEIGHT / 2 + CUBE_RAISE -SERVO_TAB_BOTTOM_TO_HORN_HEIGHT;
    difference() {
        translate([0, 0, height-CUBE_RAISE]) 
        translate([0, 0, -height])
        cylinder(d=SUPPORT_DIAMETER, h=height);

        servo1(with_cavities=true);
    }
}



module support_mid() {
    height = CUBE_HEIGHT/2 - SERVO_TAB_BOTTOM_TO_HORN_HEIGHT;
    
    difference() {
        translate([0, 0, CUBE_HEIGHT-height])
        cylinder(d=SUPPORT_DIAMETER, h=height);
        servo2(with_cavities=true);
    }

    difference() {
        translate([0, 0, CUBE_HEIGHT])
        cylinder(d=SUPPORT_DIAMETER,
                 h=CUBE_HEIGHT-SERVO_TAB_BOTTOM_TO_HORN_HEIGHT
                   -SERVO_TOP_TO_CUBE_MARGIN);
        servo3(with_cavities=true);
    }
}

module cubes() {
    %translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
    cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

    %translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, CUBE_HEIGHT])
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
        //%servos();
        //%cubes();
    }
    //rotate([0, 0, 180]) cube([100, 100, 100]);
    translate([0, 0, -10])
    cylinder(d=CUBE_WIDTH, h=40);
}