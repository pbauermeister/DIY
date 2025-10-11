use <../chamferer.scad>

D_IN = 43;
H_IN = 28;
R = 10;
N = 12;

DR = 10;
DZ = 3;
R_EXT = 50*2;
N_EXT = 6-1;

CH = 3;

$fn = $preview ? 30 : 100;
ATOM = 0.01;

module dome(d, h, r, no_chamfer=false) {
    cylinder(d=d, h=h - r);
    cylinder(d=d - r*2, h=h);

    if (!no_chamfer) {
        translate([0, 0, h - r])
        rotate_extrude(convexity = 10)
        translate([d/2 - r, 0, 0])
        circle(r=r);
    }
}

module cap() {
    dome(D_IN, H_IN, R, true);

    translate([0, 0, H_IN-R])
    difference() {
        rotate_extrude(convexity = 10)
        translate([D_IN/2 - R, 0, 0])
        circle(r = R);

        d = 3;
        r = D_IN/2 - R;
        m = 1;
        m2 = -.1;
        for (i=[0:N])
            rotate([0, 0, 360/N*i])
            translate([r-m-m2, 0, -m-m2])
            rotate([90, 0, 0])
            rotate_extrude(convexity = 10)
            translate([r+d/2 + m, 0, 0])
            circle(r = d, $fn=30);
    }
}

module handle() {
    intersection() {
        difference() {
            dome(D_IN+DR*2, H_IN+DZ, R);

            // grips
            for (i=[0:N_EXT])
                rotate([0, 0, 360/N_EXT*i])
                translate([D_IN/2 + DR/1.5 + R_EXT, 0, -DZ])
                cylinder(r=R_EXT, h=H_IN+DZ*10, $fn=30);

            // hole
            translate([0, 0, -ATOM])
            cap();
        }

        // bottom chamfer
        d = D_IN*1.5;
        translate([0, 0, d/2 -d*.25])
        sphere(d=d);
    }
}


handle();