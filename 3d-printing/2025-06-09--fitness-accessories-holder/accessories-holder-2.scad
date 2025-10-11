D =  16;
L = 110;
H =  20;

$fn = $preview? 50 : 160;

module screw(d=5.5, head_d=16, z=10) {
    translate([0, 0, -1])
    cylinder(d=d, h=100);

    translate([0, 0, z])
    cylinder(d=head_d, h=100);

    for (d=[d:1.25:head_d]) {
        difference() {
            translate([0, 0, -1+.5])
            cylinder(d=d, h=z+1);

            translate([0, 0, -2+.5])
            cylinder(d=d-.1, h=z+2);
        }
    }
}


difference() {
    union() {
        translate([0, 0, H])
        sphere(d=D);

        translate([L, 0, H])
        sphere(d=D);

        translate([0, 0, H])
        rotate([0, 90, 0])
        cylinder(d=D, h=L);

        cylinder(d=D, h=H);

        translate([L, 0, 0])
        cylinder(d=D, h=H);
    }

    screw(head_d=10);

    translate([L, 0, 0])
    screw(head_d=10);
}