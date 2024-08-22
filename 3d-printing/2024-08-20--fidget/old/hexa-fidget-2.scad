
NB_SIDES   = 6;
GAP        = 1; // 1.5;
BASE       = 1.25;


HEIGHT     = 8;
SHIFT      = HEIGHT / 4; // 2

_DIAMETER   = 30;
DIAMETER  = 160;

ATOM       = .01;
CUT        = $preview;


// computed
RADIUS_MAX = DIAMETER/2;
RADIUS_MIN = 4; //3;

module side_bottom(base, height, shift) {
    hull() {
        cube([base, ATOM, ATOM]);
        translate([shift, 0, height/2])
        cube([base, ATOM, ATOM]);
    }
}

module side_top(base, height, shift) {
    hull() {
        translate([0, 0, height])
        cube([base, ATOM, ATOM]);
        translate([shift, 0, height/2])
        cube([base, ATOM, ATOM]);
    }
}

module piece(radius, base, height, shift) {
    n = CUT ? NB_SIDES/2-1 : NB_SIDES-1;
    for (i=[0:n]) {

        hull() {
            rotate([0, 0, 360/NB_SIDES*i])
            translate([radius, 0, 0]) side_bottom(base, height, shift);

            rotate([0, 0, 360/NB_SIDES*(i+1)])
            translate([radius, 0, 0]) side_bottom(base, height, shift);
        }

        hull() {
            rotate([0, 0, 360/NB_SIDES*i])
            translate([radius, 0, 0]) side_top(base, height, shift);

            rotate([0, 0, 360/NB_SIDES*(i+1)])
            translate([radius, 0, 0]) side_top(base, height, shift);
        }
    }
}

module fidget(radius_min, radius_max, base, height, shift, gap) {
    step = base + gap;
    rotate([0, 0, 30])
    for (r=[radius_min:step:radius_max]) piece(r, base, height, shift);
}

fidget(RADIUS_MIN, RADIUS_MAX, BASE, HEIGHT, SHIFT, GAP);
