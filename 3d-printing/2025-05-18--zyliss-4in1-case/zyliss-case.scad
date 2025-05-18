L = 120;
W =  55;
H = 225;
R =   4*0 +2;
HOLE_D = 45;

ATOM   = 0.01;
$fn    = 12;

module rcube(r, l, w, h, shift=0) {
    hull()
    for (x=[-shift, l+shift]) {
        for (y=[-shift, w+shift]) {
            for (z=[-shift, h+shift]) {
                translate([x, y, z])
                sphere(r=r);
            }
        }
    }
}

module hole(extra=0, h=R, z=0) {
    k = .71;
    w = W * k + extra;
    l = L * k + extra;
    translate([L/2, W/2, z])
    translate([-l/2, -w/2]) cube([l, w, h]);

    d = HOLE_D+extra;
    //cylinder(d=d, h=h, $fn=100);
}

module box() {
    difference() {
        // outer body
        rcube(R*.75, L, W, H, R*.25);

        // body main cavity
        r = R/4;
        translate([r, r, r])
        rcube(r, L-r*2, W-r*2, H*2);

        // angle window (if filament is translucent)
        translate([-R/2, -R/2, r+H/4])
        rcube(r, L/2, W/2, H/2.5);

        //%rcube(ATOM, L, W, H+20);

        d = R/2.2;
        s1 = W/16;

        // outer stripes
        for (y=[s1/2:s1:W-s1/2]) {
            translate([s1/4, y, -R])
            rotate([45, 0, 0])
            translate([0, -d/2, -d/2])
            cube([L-s1/2, d, d]);
        }

        // inner stripes
        s2 = L/32;
        for (x=[s2/2:s2:L]) {
            translate([x, 0, d/2*0])
            rotate([0, 45, 0])
            translate([-d/2, 0, -d/2])
            cube([d, W, d]);
        }

        // hole
        hole(0, 50, -25);
    }

    // hole border
    difference() {
        hole(3, R/2, -R); // hole border
        hole(0, 50, -25);
    }
}

box();
