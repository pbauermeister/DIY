
ANGLE = 16;
LENGTH = 85;
WIDTH = 75;
TAB_WIDTH = 12;
TAB_LENGTH = 1.5 + 2.5;
MIN_THICKNESS = 0.5;
WALL = .6;


module skin(thickness) {
    intersection() {
        minkowski() {
            difference() {
                INF = 1000;
                cube(INF, center=true);
                children();
            }
            sphere(d=thickness*2, $fn=6);
        }
        children();
    }
}


module body() {
    hull() {
        cube([WIDTH, LENGTH, MIN_THICKNESS]);
        rotate([ANGLE, 0, 0])
        cube([WIDTH, LENGTH, MIN_THICKNESS]);
    }
}


module all() {
    skin(WALL) body();

    rotate([ANGLE/2, 0, 0])
    translate([WIDTH/2-TAB_WIDTH/2, -TAB_LENGTH, 0])
    cube([TAB_WIDTH, TAB_LENGTH, MIN_THICKNESS]);
}


difference() {
    translate([0, 0, cos(ANGLE/2)*LENGTH])
    rotate([-90-ANGLE/2, 0, 0])
    all();

    translate([0, 0, -WIDTH+WALL*1])
    cube(WIDTH*2, center=true);
}