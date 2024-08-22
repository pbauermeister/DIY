// https://www.thingiverse.com/thing:4659787
include <context.inc.scad>

THICKNESS = 1.5;
ANGLE = 30; //45;
ATOM = 0.01;

module raw_head() {
    scale(1.25)
    translate([0, -37, 65])
    rotate([0, 30, 0])
    rotate([180, 0, 90])
    import("Dragon_D_fixed.stl", convexity=200);
}


module end_piece() {
    difference() {
        // body
        rotate([0, -ANGLE, 0])
        translate([0, -WIDTH/2, 0])
        cube([HEIGHT*3, WIDTH, HEIGHT*2]);

        // pipe
        h = WIDTH*2;
        d = WIDTH -6;
        intersection() {
            if(0)
            translate([0, 0, HEIGHT])
            rotate([0, -60, 0])
            cylinder(d=d, h=h, center=true, $fn=200);

            translate([20, 0, HEIGHT])
            rotate([0, -ANGLE, 0])
            cylinder(d=d, h=h, center=true, $fn=200);

            translate([THICKNESS, -WIDTH/2, -THICKNESS])
            cube([HEIGHT*2, WIDTH, HEIGHT]);
        }

        // skewed face
        if(0)
        rotate([0, -ANGLE, 0])
        translate([0, 0, -h])
        cylinder(d=d*4, h=h);
        
        // top base
        translate([0, 0, HEIGHT])
        cylinder(d=d*10, h=h);

        //
        translate([-HEIGHT, -WIDTH/2 + WALL_THICKNESS, ATOM])
        cube([HEIGHT, WIDTH - WALL_THICKNESS*2, HEIGHT]);
        
    }
}


rotate([0, ANGLE, 0])
{
    if (0)
    translate([-2, 0, 0])
    %raw_head();

    end_piece();
}