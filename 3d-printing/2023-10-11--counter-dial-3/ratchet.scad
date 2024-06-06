include <values.inc.scad>;

WHEEL_H = 5;

D1 = KNOB_DIAMETER + BOX_HEIGHT/2;
D2 = KNOB_DIAMETER + BOX_HEIGHT/2 + WHEEL_H/2;
D3 = KNOB_DIAMETER + BOX_HEIGHT/2 + WHEEL_H;
D4 = KNOB_DIAMETER + BOX_HEIGHT/2 - WHEEL_H/2;

SPRING_CAVITY_THICKNESS = 1;
SPRING_CAVITY_SIDE      = KNOB_DIAMETER *.4;
SPRING_RATCHET_INSET    = 1.5;
SPRING_RATCHET_INSET_2  = 6;

SPRING_CAVITY_DX = D1/2 - sqrt(2)*SPRING_CAVITY_SIDE/2 + WHEEL_H/2 + SPRING_RATCHET_INSET;

$fn  = $preview ? 40 : 60;


module wheel(d, h, xd) {
    hull() {
        xtra = xd ? xd/2 : 0;
        translate([0, 0, 0 - xtra]) cylinder(d=d       , h=ATOM);
        translate([0, 0, h/2     ]) cylinder(d=d+h + xd, h=ATOM);
        translate([0, 0, h + xtra]) cylinder(d=d       , h=ATOM);
    }
}


module ratchet0(for_hollowing=false) {
    xd = for_hollowing ? PLAY : 0;
    h = WHEEL_H/2 + BOX_HEIGHT/4 + WHEEL_H/2;

    // pillar
    cylinder(d=KNOB_DIAMETER + xd, h=for_hollowing ? BOX_HEIGHT + 1 : BOX_HEIGHT + (KNOB_HEIGHT-BOX_HEIGHT)*.67);

    // bottom wheel
    hull() {
        wheel(D1, WHEEL_H, xd);
        if (for_hollowing) {
            hh = D1+xd+WHEEL_H;
            translate([0, 0, WHEEL_H/2])
            cylinder(d1=hh, d2=0, h=hh/2);
        }
    }

    // median wheel
    translate([0, 0, h])
    wheel(KNOB_DIAMETER, WHEEL_H, xd);
}

module spring_cavity() {
    h = SPRING_CAVITY_THICKNESS/2 + WHEEL_H/2;

    translate([0, 0, -.1])
    hull() {
        translate([D1/2 + WHEEL_H/2 + SPRING_CAVITY_THICKNESS, 0, h/2])
        translate([-SPRING_CAVITY_SIDE/2, 0, -ATOM])
        cube([SPRING_CAVITY_SIDE, SPRING_CAVITY_THICKNESS, h], center=true);

        l = SPRING_CAVITY_THICKNESS*4;
        translate([D1/2 + WHEEL_H/2 -SPRING_CAVITY_SIDE, 0, 0])
        translate([-SPRING_CAVITY_THICKNESS, -l/2, -ATOM])
        cube([SPRING_CAVITY_THICKNESS*2, l, h]);
    }


    hull() {
        translate([D1/2 + WHEEL_H/2 -SPRING_CAVITY_SIDE+SPRING_CAVITY_THICKNESS/2, 0, WHEEL_H/2])
        cube([SPRING_CAVITY_THICKNESS, SPRING_CAVITY_SIDE*2 + SPRING_RATCHET_INSET_2, SPRING_CAVITY_THICKNESS], center=true);

        ll = SPRING_CAVITY_SIDE;
        translate([D1/2 + WHEEL_H/2 -SPRING_CAVITY_SIDE, 0, 0])
        translate([-SPRING_CAVITY_THICKNESS, -ll, -ATOM])
        cube([SPRING_CAVITY_THICKNESS*2, ll*2, ATOM]);

        th = SPRING_CAVITY_THICKNESS*1.75;
        l = SPRING_CAVITY_THICKNESS*4;
        translate([D1/2 + WHEEL_H/2 -SPRING_CAVITY_SIDE -2, 0, WHEEL_H/2 - SPRING_CAVITY_THICKNESS/2])
        translate([-th/2, -l/2, -ATOM])
        cube([th, l, SPRING_CAVITY_THICKNESS]);
    }
}


module ratchet(for_hollowing=false) {
    if (for_hollowing) {
        ratchet0(true);
    } else {
        difference() {
            ratchet0(false);
            spring_cavity();
        }
    }
}


module ratchet_cavity() {
    ratchet(true);
    for (i=[0:TURNS-1]) {
        rotate([0, 0, i*360/TURNS])
        translate([SPRING_CAVITY_DX, 0, WHEEL_H/2])
        rotate([0, 0, 45])
        cube([SPRING_CAVITY_SIDE, SPRING_CAVITY_SIDE, SPRING_CAVITY_THICKNESS*1.5], center=true);
    }
}


module ratchet_demo() {
    ratchet();

    if(1)
    difference() {
        cylinder(d=KNOB_DIAMETER+(BOX_SIZE-KNOB_DIAMETER)*.7, h=BOX_HEIGHT);
        translate([0, 0, -ATOM])
        ratchet_cavity();
    }
}


difference() {
    ratchet_demo();
    
    if (1 || $preview) {
        w = KNOB_DIAMETER*4;
        translate([-KNOB_DIAMETER*2, 0, -BOX_HEIGHT])
        cube([w, w, BOX_HEIGHT*3]);
    }
}

//%ratchet_cavity();