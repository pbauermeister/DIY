// Closed ring for shower curtain
// P. Bauermeister, 2017-02-18

$fn = 45;

R = 17;
D = 20;
r = 3;

module Ring() {
    difference()
    {
        // 2 x torus
        union() {
            translate([D/2, 0, 0])
            rotate_extrude(convexity=10) translate([R, 0, 0]) circle(r=r);

            translate([-D/2, 0, 0])
            rotate_extrude(convexity=10) translate([R, 0, 0]) circle(r=r);
        }

        // remove middle
        translate([-D/2, -D*2, -D*2])
        cube([D, D*4, D*4]);
    }

    translate([-D/2,  R, 0]) rotate([0, 90, 0]) cylinder(h=D, r=r);
    translate([-D/2, -R, 0]) rotate([0, 90, 0]) cylinder(h=D, r=r);

    // To check size
    // translate([-30, -20, 0]) cube([60,40,1]);
}

// 2 x halfs
translate([0, 30, 0])
intersection() { Ring(); translate([-30, -20, 0]) cube([60,40,10]); }

translate([0, -30, 0])
intersection() { Ring(); translate([-30, -20, 0]) cube([60,40,10]); }