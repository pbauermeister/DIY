DIAMETER    = 165;
THICKNESS_H =   7;
THICKNESS_V =   5 + .5;
MARGIN      =   2;
SCREW_DEPTH =   2;
HEIGHT      =  20;
TOLERANCE   =   0.3;
PLAY        =   0.8;
PLAY2       =   0.8*2.5;
SCREW_PITCH =   2;
SCREW_STEP  = $preview ? 500 : 15;
ATOM        =   0.01;

TRAVEL = 4;
HUB_DIAMETER = 20;

SWITCH_HEIGHT           =  9.6;
SWITCH_WIDTH            =  6.4;
SWITCH_LENGTH           = 19.9;

SWITCH_KNOB_POS_X       =  7.0;
SWITCH_HEIGHT_WITH_KNOB = 11.7;
SWITCH_KNOB_DIAMETER    =  2.2;

SWITCH_CONTACTS_DEPTH   =  3.5;
SWITCH_CONTACTS_WIDTH   =  3.0;

INNER_PIECE_DIAMETER    = DIAMETER - THICKNESS_H*2 - TOLERANCE*(2 + 1 + 1);
INNER_PIECE_HEIGHT      = THICKNESS_V * 1.5;

$fn = $preview ? 30 : 120;

include <util.inc.scad>

module cross_cut() {
    intersection() {
        children();

        translate([-DIAMETER, 0, -DIAMETER]) cube(DIAMETER*2);
//        cylinder(d=DIAMETER*2, h=HEIGHT-2);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Outer ring

module outer_ring() {
    h = HEIGHT - THICKNESS_V;
//    color("orange")
    difference() {
        cylinder(d=DIAMETER, h=HEIGHT+MARGIN);
        cylinder(d=DIAMETER-THICKNESS_H*2, h=HEIGHT*2, center=true);
        cylinder(d=DIAMETER-THICKNESS_H*3, h=HEIGHT*2);

        pitch = 2;
        r = DIAMETER/2 - THICKNESS_H;
        translate([0, 0, -ATOM])
        screw(SCREW_PITCH, h, r, SCREW_STEP, true);

        if(0)
        hull() {
            translate([DIAMETER/2-THICKNESS_H-PLAY, 0, -ATOM])
            cylinder(d=INNER_PIECE_HEIGHT, h=HEIGHT+ATOM);

            translate([-DIAMETER/2+THICKNESS_H+PLAY, 0, -ATOM])
            cylinder(d=INNER_PIECE_HEIGHT, h=HEIGHT+ATOM);
        }

        d = DIAMETER/24;
        step = 9;
        for (i=[step/2:step:360]) {
            rotate([0, 0, i])
            translate([DIAMETER/2 + d -THICKNESS_H/3, 0, 0])
            hull() {
                $fn=15;
                translate([0, 0, HEIGHT-d/2-THICKNESS_V/2])
                sphere(r=d);
                translate([0, 0, -d])
                sphere(r=d);
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
// Disc

module disc_outer() {
    translate([0, 0, -TRAVEL])
    cylinder(d=DIAMETER - THICKNESS_H*2 -TOLERANCE*2, h=THICKNESS_V + TRAVEL);
 }

module disc_spring(extra_h=0, extra_v=0) {
    w = 6 + extra_h*2;
    h = .5 + extra_v;

    difference() {
        intersection() {
            disc_outer();

            // cross
            union() {
                for (a=[0, 60, 120])
                    rotate([0, 0, a])
                    translate([-DIAMETER/2, -w/2])
                    cube([DIAMETER, w, h]);
            }
        }
        // hub
        if (extra_h) cylinder(d=HUB_DIAMETER, h=h);
    }
}

module disc() {
    play = PLAY2;
    wall = 2;

    difference() {
        union() {
            difference() {
                cylinder(d=DIAMETER - THICKNESS_H*2 - play*2, h=THICKNESS_V);
                translate([0, 0, -ATOM])
                disc_spring(extra_h=1.5, extra_v=TRAVEL);
            }

            disc_spring();

            r=DIAMETER*5;
            intersection() {
                translate([0, 0, r+THICKNESS_V/3])
                sphere(r=r, $fn=360);
                cylinder(d=DIAMETER - THICKNESS_H*2 - play*2, h=THICKNESS_V);
            }

        }

        // force thicker bottom layer
        for (h=[.5:.5:THICKNESS_V-1])
            translate([0, 0, h])
            cylinder(d=HUB_DIAMETER-TOLERANCE, h= .05);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Inner piece

module inner_piece() {
    h = INNER_PIECE_HEIGHT;
    d = INNER_PIECE_DIAMETER;

    difference() {
        union() {
            cylinder(d=d, h=h);
            if (!$preview)
              screw(SCREW_PITCH, h, d/2, SCREW_STEP, true, true);
        }

        translate([0, 0, HEIGHT-THICKNESS_V - SWITCH_HEIGHT_WITH_KNOB])
        minkowski() {
            switch();
            cube(TOLERANCE*2, center=true);
        }

        hollowings();
    }

    // feet
    d2 = 6;
    for (a=[0:120:240])
        rotate([0, 0, a])
        translate([DIAMETER/2 - THICKNESS_H -d2, 0, 0])
        sphere(d=d2);

    // small feet
    for (a=[0:180:180])
        rotate([0, 0, a+90])
        translate([DIAMETER/20, 0, 0])
        sphere(d=d2-1);

    // locks
    lock();
}

module switch(with_knob=false) {
    if (with_knob)
      cylinder(d=SWITCH_KNOB_DIAMETER, h=SWITCH_HEIGHT_WITH_KNOB);

    translate([-SWITCH_KNOB_POS_X, 0, 0]) {
        translate([0, -SWITCH_WIDTH/2, 0])
        cube([SWITCH_LENGTH, SWITCH_WIDTH, SWITCH_HEIGHT]);
    }
}

module hollowings() {
    hollowings_circles();
    hollowing_for_cable();
    hollowing_for_hanging();
    hollowing_for_springing();
}

module hollowings_circles() {
    h = INNER_PIECE_HEIGHT;
    d = INNER_PIECE_DIAMETER;
    n = 3;
    for (a=[0:360/n:360]) {
        r = d/8 *1.2;
        rotate([0, 0, a + 90])
        translate([0, d/4.5 + d/32, 0])
        cylinder(r=r, h=h*3, center=true);
    }
}

module hollowing_for_cable() {
    translate([SWITCH_KNOB_POS_X/2, 0, HEIGHT-THICKNESS_V - SWITCH_HEIGHT_WITH_KNOB]) {
        sl = SWITCH_LENGTH*.8;
        w = 2;
        h = THICKNESS_V * 3;
        l = sl*4 + w*2;
        translate([-l/2, -SWITCH_CONTACTS_WIDTH/2, -SWITCH_CONTACTS_DEPTH])
        cube([l, SWITCH_CONTACTS_WIDTH, SWITCH_CONTACTS_DEPTH]);

        for (x=[-sl*2:sl: sl*2])
        for (y=[-SWITCH_CONTACTS_WIDTH/2-w/2+ATOM, SWITCH_CONTACTS_WIDTH/2+w/2-ATOM])
            if(x)
                translate([x, y, 0])
                cube([w*2, w, h], center=true);
    }
}

module hollowing_for_hanging() {
    // hanging holes
    d = 5;
    aa = 9;
    h = THICKNESS_V * 4;
    r0 = (DIAMETER - THICKNESS_H*2)/2;
    r = r0 - d*3;
    for (a=[-aa, 0, aa]) {
        translate([r * cos(a), r * sin(a), 0])
        cylinder(d=d, h=h, center=true);
    }
}

SPRINGING_MARGIN = 10;

module hollowing_for_springing() {
    d = INNER_PIECE_DIAMETER - SPRINGING_MARGIN*2;
    slit = 1;
    a = 15;

    translate([0, 0, -INNER_PIECE_HEIGHT/2])
    scale([1, 1, INNER_PIECE_HEIGHT*2]) {
        difference() {
            cylinder(d=d, h=1);
            cylinder(d=d-slit*2, h=3, center=true);

            rotate([0, 0, -a])
            translate([0, 0, -1])
            cube([INNER_PIECE_DIAMETER, INNER_PIECE_DIAMETER, 3]);

            rotate([0, 0, a-90])
            translate([0, 0, -1])
            cube([INNER_PIECE_DIAMETER, INNER_PIECE_DIAMETER, 3]);

            rotate([0, 0, 90+45])
            translate([0, 0, -1])
            cube([INNER_PIECE_DIAMETER, INNER_PIECE_DIAMETER, 3]);
        }

        for (i=[45, 45+90]) {
            rotate([0, 0, i])
            translate([0, d/2-slit, 0])
            cube([1, INNER_PIECE_DIAMETER, 1]);
        }

        for (i=[-a, a-180]) {
            rotate([0, 0, i])
            translate([0, d/2-slit, 0])
            cylinder(d=slit*4, h=1);

            rotate([0, 0, i])
            hull() {
                r = d/2 + SPRINGING_MARGIN-PLAY;
                translate([0, r, 0])
                cylinder(d=slit*4, h=1);
                translate([0, r+slit*4, 0])
                cylinder(d=slit*4*2, h=1);
            }
        }
    }

    lock(grow=PLAY*1.5);
}

module ratcheting_cylinder(d1, d2, h) {
    r1 = d1/sqrt(2);
    r2 = d2/sqrt(2);
    for (a=[0:4.5:90])
        rotate([0, 0, a]) hull() {
            translate([-r1/2, -r1/2, 0])
            cube([r1, r1, h]);

            translate([-r2/2, -r2/2, h/2])
            cube([r2, r2, ATOM]);
        }
}

module lock(grow=0) {
    d = INNER_PIECE_DIAMETER - SPRINGING_MARGIN*1.95;
    w = 25;
    k = grow ? 1 : .85;
    h = INNER_PIECE_HEIGHT/2;
    slit_width = 2.5;
    slit_length = 15;

    for (i=[1, -1]) {
        rotate([0, 0, (135-7)*i])
        translate([d/2-w/2, 0, 0])
        difference() {
            union() {
                difference() {
                    translate([0, 0, -grow/2])
                    scale([k, 1, 1])
                    ratcheting_cylinder(d1=w+grow, d2=w+grow+h, h=INNER_PIECE_HEIGHT+grow);

                    translate([w-1, 0, 0])
                    cube([w, w*2, INNER_PIECE_HEIGHT*3], center=true);
                }

                if (grow) {
                    h2 = 1.5;
                    translate([0, 0, INNER_PIECE_HEIGHT/2-h2/2])
                    ratcheting_cylinder(d1=w+grow, d2=w+grow+h, h=h2);
                }
            }

            if(grow==0)
                cube([slit_width, slit_length, h*5], center=true);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////

module all() {
//    outer_ring();
//    translate([0, 0, HEIGHT-THICKNESS_V]) disc();
!    inner_piece();

    %translate([0, 0, HEIGHT-THICKNESS_V - SWITCH_HEIGHT_WITH_KNOB]) switch(true);
}

cross_cut()
all();
