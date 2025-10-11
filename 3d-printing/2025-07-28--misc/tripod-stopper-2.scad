use <../chamferer.scad>

LENGTH       = 35;
HEIGHT       = 12.5;
EXTRA_HEIGHT =  8;
DIAMETER     = 12.5;
GROUND       =  3;
CHAMFER      =  3;
WIDTH        =  9;

SCREW_DIAMETER       = 3.5;
SCREW_HEAD_DIAMETER  = 7.5;

ATOM = 0.01;
$fn  = 100;

module stopper() {
    difference() {
        chamferer(CHAMFER, tool="cylinder", fn=4) {
            difference() {
                translate([-CHAMFER+1, -WIDTH/2, -GROUND])
                cube([LENGTH+CHAMFER, WIDTH, HEIGHT + EXTRA_HEIGHT + GROUND]);

                translate([10, 0, HEIGHT+EXTRA_HEIGHT*2])
                rotate([0, 30, 0])
                translate([0, -WIDTH, 0])
                cube([LENGTH*2, WIDTH*2, HEIGHT + EXTRA_HEIGHT]);
            }
            cylinder(r2=CHAMFER, r1=0, h=CHAMFER);
        }

        // back
        translate([-50, -25, -25])
        cube(50);

        // axis
        hull() {
            translate([-DIAMETER, 0, -GROUND-1])
            cylinder(d=DIAMETER, GROUND+2);

            translate([12, 0, -GROUND-1])
            cylinder(d=DIAMETER, GROUND+2);
        }
        //%translate([12, 0, -GROUND-1]) cylinder(d=D, GROUND+2);
        
        // h screw
        translate([0, 0, HEIGHT/2])
        rotate([0, 90, 0])
        cylinder(d=SCREW_DIAMETER, h=50);
        translate([21+4+2.5, 0, HEIGHT/2])
        sphere(d=SCREW_HEAD_DIAMETER);

        translate([21+4+2.5, 0, HEIGHT/2])
        rotate([0, 90, 0])
        cylinder(d=SCREW_HEAD_DIAMETER, h=50);

        // v screw
        translate([SCREW_DIAMETER*1.5, 0, 0]) {
            translate([0, 0, HEIGHT/2])
            cylinder(d=SCREW_DIAMETER, h=50);

            translate([0, 0, HEIGHT +EXTRA_HEIGHT -2.5]) {
                sphere(d=SCREW_HEAD_DIAMETER);
                cylinder(d=SCREW_HEAD_DIAMETER, h=50);
            }
        }

        // central
        translate([-ATOM, -WIDTH, 0])
        cube([22, WIDTH*2, HEIGHT]);
    }
}

difference() {
    rotate([$preview ? 0 : 90, 0, 0])
    stopper();

//    if ($preview) translate([-500, 0, -500]) cube(1000);
}