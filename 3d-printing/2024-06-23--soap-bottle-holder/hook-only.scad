use <soap-bottle-holder.scad>;

H = get_hook_z();
W = get_hook_w();
TH2 = get_hook_th();
TH = get_th();
ATOM = 0.01;

D = 2;

module hook0() {
    difference() {
        bar(partial=true);

        // remove existing
        translate([-ATOM, -W/2 -ATOM, -ATOM])
        cube([TH+ATOM*2, get_hook_w()+ATOM*2, H]);

        // holes for pins
        w = W * .8;
        n = 5;
        sp = n;
        for (i=[0:n-1]) {
            y = -w/2 + (i/(n-1)) * w;
            translate([0, y, H - D*.6])
            rotate([0, 45, 0])
            cube([D, D, TH2]);
        }
    }
}

module hook() {
    rotate([90, 0, 0])
    translate([0, 0, -H])
    hook0();
}

hook();


