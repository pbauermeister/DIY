WALL_THICKNESS = 1.5;
HEIGHT = 41;
WIDTH  = 60 + WALL_THICKNESS*2;
LENGTH = 41;

module context() {
    translate([-100, -WIDTH/2, 0])
    cube([100, WIDTH, HEIGHT]);

    translate([0, 0, HEIGHT])
    cylinder(r=150, h=.1);


    translate([0, -WIDTH/2, HEIGHT-1])
    cube([LENGTH, WIDTH, 1]);
}

%context();
