use <target-round.scad>

module test() {
    intersection() {
        inner_piece();

        translate([0, 0, -25 + 5*1.5])
        union() {
            difference() {
                cylinder(d=165 - 7,      50, center=true);
                cylinder(d=165 - 7-8 -6, 60, center=true);
            }
        }
    }

    for (a=[0:60:360]) {
        rotate([0, 0, a])
        translate([0, 0, 1.5/2])
        cube([145, 8, 1.5], center=true);
    }
}

//test();
rotate([180, 0, 0])
inner_piece();
