
NB_SIDES  = 6;
GAP       = 1; // 1.2; // .75; // .5; //.33;
BASE      = 1.25;

_OVERLAP   = 0; //.2;
_EXCESS    = GAP*2 + _OVERLAP;

OVERLAP   = GAP; // GAP/2; // 0; //.2;
EXCESS    = GAP + OVERLAP;

HEIGHT    = 4;
DIAMETER  = 30;
DIAMETER = 160;

ATOM      = .01;
CUT       = $preview;


// computed
STEP      = BASE+GAP;
RADIUS    = DIAMETER/2;


module shaver(shave=false) {
    difference() {
        children();
        if (shave)
            translate([EXCESS+BASE*.85, -ATOM*5, 0])
            cube([BASE, ATOM*10, HEIGHT]);
    }
}

module side_bottom(shave=false) {
    shaver(shave)
    hull() {
        cube([BASE, ATOM, ATOM]);
        translate([EXCESS, 0, HEIGHT/2])
        cube([BASE, ATOM, ATOM]);
    }
}

module side_top(shave=false) {
    shaver(shave)
    hull() {
        translate([0, 0, HEIGHT])
        cube([BASE, ATOM, ATOM]);
        translate([EXCESS, 0, HEIGHT/2])
        cube([BASE, ATOM, ATOM]);
    }
}

module filler(fill) {
    if (fill) {
        hull() children();
    }
    else {
        children();
    }
}

module piece(radius, shave, fill) {
    n = CUT ? NB_SIDES/2-1 : NB_SIDES-1;
    filler(fill)
    for (i=[0:n]) {

        hull() {
            rotate([0, 0, 360/NB_SIDES*i])
            translate([radius, 0, 0]) side_bottom(shave);

            rotate([0, 0, 360/NB_SIDES*(i+1)])
            translate([radius, 0, 0]) side_bottom(shave);
        }

        hull() {
            rotate([0, 0, 360/NB_SIDES*i])
            translate([radius, 0, 0]) side_top(shave);

            rotate([0, 0, 360/NB_SIDES*(i+1)])
            translate([radius, 0, 0]) side_top(shave);
        }
    }
}


rotate([0, 0, 30])
for (r=[1:STEP:RADIUS]) piece(r, false); //r > RADIUS-STEP, r<STEP);

echo(DIAMETER/2 / (BASE+GAP));
