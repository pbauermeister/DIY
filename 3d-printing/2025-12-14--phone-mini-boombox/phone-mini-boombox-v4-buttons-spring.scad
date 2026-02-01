use <phone-mini-boombox-v4-buttons.scad>
use <phone-mini-boombox-v4.scad>
use <../chamferer.scad>


BUTTONS_PIN_TH = 13 + .2    -1 +.5;
BUTTONS_D      = get_buttons_d();
BUTTONS_POS    = get_buttons_pos_x();
TH2            = 1;
PLAY           = 0.5;
ATOM           = 0.01;

$fn = $preview ? 50 : 100;

POS_X   = -20                   +5   +2.5   +2.5    +9   +3 +.5 -1.5    -.2;
L       =  90                   -15  -5     -5      -18  -6 -1  +3      +.4;
TH      =   0.80;
W       = BUTTONS_D + 1.3*2;
EXT_H   =   5.5;
EXT_L   =  10                   +5;
EXT_A   = atan(EXT_H/EXT_L);

module spring() {
    // base
    difference() {
        union() {
            translate([POS_X, -W/2, 0])
            cube([L, W, TH]);

            if (0)
            translate([POS_X-1, -W/2, -TH/2])
            cube([L+2, W, TH]);

            // round spring
            r = L/2;
            th = TH/2;

            difference() {
                translate([POS_X+r, 0, 0])
                difference() {
                    translate([0, 0, r-TH*3])
                    rotate([90, 0, 0])
                    chamferer(th*.7, "cylinder", shrink=false)
                    difference() {
                        cylinder(r=r, h=W, $fn=30, center=true);
                        cylinder(r=r-ATOM, h=W*2, $fn=30, center=true);
                    }
                    cylinder(r=r*2, h=r*3);
                    if (0) translate([0, -r/2, -.3])
                    cube(r);
                }
                xd = -.5    +.3;
                translate([BUTTONS_POS[1], 0, -TH*2.5])
                scale([1.25, 1, 1])
                cylinder(d=BUTTONS_D + xd, h=TH*4, center=true);

            }

        }

        // pin holes, upper
        for (i=[0:2]) {
            xd = -.5    +.3 -.2;
            translate([BUTTONS_POS[i], 0, 0])
            resize([BUTTONS_D + xd, BUTTONS_D + xd - .4, TH*3])
            cylinder(d=BUTTONS_D + xd, h=TH*3, center=true);
        }
    }

    // bridge
    rl = W*.78 -1.5     -.9;
    ra = 19.75   +18;
    rh = 2.4    ;
    difference() {
    
        union() {
            z = -TH/2 -.1+.5;
            dx1 = BUTTONS_D+1.9+.3;

            // - ramps
            translate([BUTTONS_POS[0] - dx1, -W/2, z])
            rotate([0, -ra, 0])
            cube([rl, W, TH]);

            translate([BUTTONS_POS[2] + dx1, -W/2, z])
            rotate([0, ra, 0])
            translate([-rl, 0, 0])
            cube([rl, W, TH]);

            // - bridge
            translate([BUTTONS_POS[0] - W/2.2 -1.5, -W/2, TH + 1.15 -.1])
            cube([BUTTONS_POS[2] - BUTTONS_POS[0] + W*.91 +3, W, TH]);

            // - bumps
            dx = W/2 + .45;
            for (x=[BUTTONS_POS[0] - dx,
                    BUTTONS_POS[1] + dx,
                    BUTTONS_POS[2] - dx,
                    BUTTONS_POS[2] + dx])
                translate([x, 0, TH*2+1.2 -.1])
                scale([1, 1, .7])
                rotate([90, 0, 0])
                cylinder(d=1.25, h=W, center=true);
        }

        // pin holes
        for (i=[0:2]) {
            xd = -.5 +.1;
            translate([BUTTONS_POS[i], 0, TH*3])
            cylinder(d=BUTTONS_D + xd, h=TH*3, center=true);
        }
        
        // slits
        d = BUTTONS_POS[1]-BUTTONS_POS[0];
        if (0)
        for (k=[-1, 1]) {
            x = (BUTTONS_POS[0]+BUTTONS_POS[1])/2 + k*(d*.5 + BUTTONS_D*.66);
            translate([x, 0, rh])
            cube([TH*.5, W*2, TH*2], center=true);
        }
    }

    // - spacers
    for (x=[(BUTTONS_POS[2]+BUTTONS_POS[1])/2-TH/2,
            (BUTTONS_POS[0]+BUTTONS_POS[1])/2-TH/2])
        translate([x, -W/2, TH])
        cube([TH, W, TH*0 + rh/2]);
    
    // spring
    sl = 10;
    sa = 16;    
    x = (BUTTONS_POS[2]+BUTTONS_POS[1])/2;
    if (0)
    translate([x, 0, -sin(sa)*sl*.5 +.5])
    rotate([0, -sa, 0])
    cube([sl, W, TH/2], center=true);

}

rotate([90, 0, 0])
{
    if(0)
    %translate([0, 0, 2])
    translate([0, 0, -.6])
    rotate([180, 0, 0])
    knobs();

    spring();
}