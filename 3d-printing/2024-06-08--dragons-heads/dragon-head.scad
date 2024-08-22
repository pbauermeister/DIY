// https://www.thingiverse.com/thing:4659787
include <context.inc.scad>

module raw_head() {
    scale(1.25)
    translate([0, -37, 65])
    rotate([0, 30, 0])
    rotate([180, 0, 90])
    import("Dragon_D_fixed.stl", convexity=200);
}


module end_piece() {
    difference() {
        translate([0, -WIDTH/2, 0])
        cube([HEIGHT, WIDTH, HEIGHT]);

        h = WIDTH*2;
        d = WIDTH -4;
        intersection() {
            translate([0, 0, HEIGHT])
            rotate([0, -45, 0])
            cylinder(d=d, h=h, center=true, $fn=200);

            translate([1, -WIDTH/2, -1])
            cube([HEIGHT, WIDTH, HEIGHT]);
        }
        rotate([0, -45, 0])
        translate([0, 0, -h])
        cylinder(d=d*4, h=h);
    }
}


//rotate([0, 45, 0])
{
    translate([-2, 0, 0])
    %raw_head();

    end_piece();
}