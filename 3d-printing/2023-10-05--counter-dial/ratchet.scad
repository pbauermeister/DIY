include <values.inc.scad>;

H = 5;
D1 = KNOB_DIAMETER + BOX_HEIGHT/2;
D2 = KNOB_DIAMETER + BOX_HEIGHT/2 + H/2;
D3 = KNOB_DIAMETER + BOX_HEIGHT/2 + H;
D4 = KNOB_DIAMETER + BOX_HEIGHT/2 - H/2;
SLIT_SIZE = 2;

$fn  = $preview ? 40 : 60/2;


module wheel(d, h, xd) {
    hull() {
        cylinder(d=d + xd, h=ATOM);
        translate([0, 0, h/2 - (xd?ATOM:0)]) cylinder(d=d+h + xd, h=ATOM);
        translate([0, 0, h + (xd?ATOM:0)]) cylinder(d=d   + xd, h=ATOM);
    }
}

module bottom_hollowing(for_hollowing=false) {
    xd = for_hollowing ? PLAY : 0;
    h = H/2 + BOX_HEIGHT/4 + H/2;
    hull() {
        translate([0, 0, H/2]) cylinder(d=D1+H + xd, h=ATOM);
        translate([0, 0, h]) cylinder(d=KNOB_DIAMETER + xd, h=ATOM);
    }
}

module ratchet0(for_hollowing=false) {
    xd = for_hollowing ? PLAY : 0;
    h = H/2 + BOX_HEIGHT/4 + H/2;

    // pillar
    cylinder(d=KNOB_DIAMETER + xd, h=for_hollowing ? BOX_HEIGHT + 1 : KNOB_HEIGHT);

    // bottom wheel
    wheel(D1, H, xd);

    // hollowing
    if (for_hollowing) bottom_hollowing(true);

    // median wheel
    translate([0, 0, h])
    wheel(KNOB_DIAMETER, H, xd);
}

RATCHET_X = KNOB_DIAMETER/2 * 1.06;
RATCHET_D = KNOB_DIAMETER/4;
PIN_D = RATCHET_D * .6;
echo(PIN_D);

module pin(for_hollowing=false) {
    d = PIN_D;
    xd = for_hollowing ? PLAY : 0;
    intersection() {
        translate([RATCHET_X, 0, for_hollowing?-ATOM:0]) {
            cylinder(d=d+xd, h=H*1.5);
        }
        if (!for_hollowing) bottom_hollowing(false);
    }

    translate([RATCHET_X, 0, for_hollowing?-ATOM:0]) {
        cylinder(d=d+xd, h=H);
    }
}


module ratchet_wheel(for_hollowing=false, for_hollowing2=false) {
    xd = for_hollowing ? PLAY : 0;
    d = RATCHET_D;
    h = H + (for_hollowing ? PLAY : 0); 

    if (for_hollowing2) {
        translate([RATCHET_X, 0, 0]) {
            wheel(d, h+PLAY/2, xd);
        }
    }
    else {
        difference() {
            translate([RATCHET_X, 0, 0]) {
                dd = d + (for_hollowing ? PLAY : 0);
                wheel(dd, h, xd);
            }
            if (!for_hollowing)
                pin(true); 
        }
    }
}


module ratchet(for_hollowing=false) {
    if (for_hollowing) {
        ratchet0(true);
        ratchet_wheel(true, true);
    } else {
        difference() {
            ratchet0(false);
            ratchet_wheel(true);
            //translate([KNOB_DIAMETER/4, 0, 0])
            rotate([0, 45, 0])
            cube([SLIT_SIZE, KNOB_DIAMETER*3, BOX_HEIGHT*2*sqrt(2)], true);
        }
        ratchet_wheel(false);
        d = RATCHET_D;
        pin(false);
        }
}


module all() {
    ratchet();

    difference() {
        cylinder(d=KNOB_DIAMETER*2, h=BOX_HEIGHT);
        for (i=[0:TURNS-1]) {
            rotate([0, 0, i*360/TURNS])
            ratchet(true);
        }
    }
}

difference() {
    all();
    
    if ($preview) {
        w = KNOB_DIAMETER*4;

        translate([-KNOB_DIAMETER*2, 0, -BOX_HEIGHT])
        cube([w, w, BOX_HEIGHT*3]);
    }
}