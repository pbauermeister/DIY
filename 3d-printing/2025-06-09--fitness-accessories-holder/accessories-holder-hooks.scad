D =  16;
L = 110;
H =  30;

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

module hook() {
    d = 12;
    cylinder(d=d, h=H);

    translate([0, 0, H])
    sphere(d=d);

    hull() {
        w = d/4;
        translate([0, 0, H])
        sphere(d=d);

        translate([0, w, H+w])
        rotate([-45, 0, 0])
        translate([0, 0, d/4])
        cylinder(d=d, h=.01, center=!true);
    }
}

difference() {
    n = 4;
    dx = L/(n-1);

    union() {
        intersection() {
            scale([1, 1, 1.7])
            hull() {
                //cylinder(d=D, h=D/2);
                sphere(d=D);
                translate([L, 0, 0]) sphere(d=D);
            }
            cylinder(d=10000, h=D/2);
        }

        for (x=[0:dx:L])
            translate([x, 0, 0])
            hook();
    }

    for (x=[dx/2, L-dx/2])
        translate([x, 0, 0])
        screw(head_d=10, z=5.5);
}
