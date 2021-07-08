include <definitions.scad>
use <servos_123.scad>

difference() {
    union() {
        cylinder(d=CUBE_WIDTH - GROOVE_MARGIN*2, h=GROOVE_DEPTH+1);
        translate([0, 0, 1/2])
        cube([CUBE_WIDTH, CUBE_WIDTH, 1], center=true);
    }
    cylinder(d=CUBE_WIDTH - GROOVE_MARGIN*2 - GROOVE_THICKNESS*2, h=GROOVE_DEPTH+1);
}

translate([CUBE_WIDTH+10, 0, 0]) {
    difference() {
        translate([0, 0, GROOVE_DEPTH/2])
        cube([CUBE_WIDTH, CUBE_WIDTH, GROOVE_DEPTH+.5 +.2], center=true);
        // groove
        translate([0, 0, 0.5])
        difference() {
            cylinder(d=CUBE_WIDTH - GROOVE_MARGIN*2 + PLAY*2, h=CUBE_HEIGHT);
            cylinder(d=CUBE_WIDTH - GROOVE_MARGIN*2 - PLAY*2 - GROOVE_THICKNESS*2, h=CUBE_HEIGHT);
        }

//        cylinder(d=CUBE_WIDTH - GROOVE_MARGIN*2 - PLAY*2 - GROOVE_THICKNESS*2-5, h=CUBE_HEIGHT);
 
        servo3(with_cavities=true, short_cavity=true);

    }
}

%        servo3(with_cavities=true, short_cavity=true);
