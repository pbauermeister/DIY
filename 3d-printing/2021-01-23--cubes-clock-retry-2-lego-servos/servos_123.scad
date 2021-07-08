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
//    translate([0, 0, CUBE_HEIGHT*2-SERVO_TAB_BOTTOM_TO_HORN_HEIGHT-SERVO_TOP_TO_CUBE_MARGIN])
    translate([0, 0, CUBE_HEIGHT])
    servo(with_cavities=with_cavities, short_cavity=short_cavity);
}

module servos_render(with_cavities=false) {
    color("brown")   servo1(with_cavities);
//    color("red")     servo2(with_cavities);
    color("#ff4020") servo3(with_cavities);
}

module servos_from_stl() {
    import("servos_123.stl");
}

module servos() {
    servos_render();
    //servos_from_stl();
}

servos();
