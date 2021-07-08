
ANGLE = 16;
LENGTH = 85;
WIDTH = 75;
TAB_WIDTH = 12;
TAB_LENGTH = 1.5 + 2.5;
MIN_THICKNESS = 0.5;
WALL = 1;

module body() {
    hull() {
        cube([WIDTH, LENGTH, MIN_THICKNESS]);
        rotate([ANGLE, 0, 0])
        cube([WIDTH, LENGTH, MIN_THICKNESS]);
    }

}


module all() {
    difference() {
        body();
        
        difference() {
            minkowski() {
                body();
                sphere(d=WALL, $fn=6);
            }
            body();
        }


    rotate([ANGLE/2, 0, 0])
    translate([WIDTH/2-TAB_WIDTH/2, -TAB_LENGTH, 0])
    cube([TAB_WIDTH, TAB_LENGTH, MIN_THICKNESS]);
}


difference() {
    translate([0, 0, cos(ANGLE/2)*LENGTH])
    rotate([-90-ANGLE/2, 0, 0])
    all();
    
    translate([0, 0, -.25+.1])
    for (i = [2:2:sin(ANGLE)*LENGTH]) {
        translate([0, i-1.5, 0])
        cube([WIDTH, 1, 0.5]);

        translate([0, 1-i, 0])
        cube([WIDTH, 1, 0.5]);
    }
    
    translate([0, -WIDTH/2, -WIDTH+.1])
    cube(WIDTH);
}