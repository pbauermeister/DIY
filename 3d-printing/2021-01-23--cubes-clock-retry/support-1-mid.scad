include <definitions.scad>
use <tower.scad>

difference() {
    support_mid();
    
    height = CUBE_HEIGHT/2 - SERVO_TAB_BOTTOM_TO_HORN_HEIGHT;
    translate([0, 0, CUBE_HEIGHT-height]) 
    adhesion();

    //translate([0, -250, 0]) cube(500);  // cross-cut
}
