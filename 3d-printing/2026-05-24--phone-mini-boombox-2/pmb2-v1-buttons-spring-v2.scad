use <pmb2-v1-buttons.scad>
use <pmb2-v1-body.scad>
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
    d = (BUTTONS_POS[1]-BUTTONS_POS[0])/2;
    arr = [BUTTONS_POS[2] -d,
           BUTTONS_POS[1] +d,
           BUTTONS_POS[0] +d];
    rh = 2.4;

    translate([0, 0, TH/2])
    difference() {    
        union() {
            // base
            difference() {
                translate([POS_X-.9, -W/2, -TH])
                cube([L+1.8, W, TH]);

                // pin holes, upper
                for (i=[0:2]) {
                    xd = -.5    +.3 -.2;
                    translate([BUTTONS_POS[i], 0, 0])
                    //resize([BUTTONS_D + xd -.4, BUTTONS_D + xd - .4, TH*3])
                    cylinder(d=BUTTONS_D + xd-.2, h=TH*3, center=true);
                }
            }

            z = -TH/2 -.1+.5 -.3-.34;
            dx1 = BUTTONS_D+1.9+.3 +.40;

            // - ramps
            rl = W*.78 -1.5     -.9 +.9 +.8;
            ra = 19.75   +18 -4+3.5;

            translate([BUTTONS_POS[0] - dx1, -W/2, z])
            rotate([0, -ra, 0])
            cube([rl, W, TH]);

            translate([BUTTONS_POS[2] + dx1, -W/2, z])
            rotate([0, ra, 0])
            translate([-rl, 0, 0])
            cube([rl, W, TH]);

            // - bridge
            translate([BUTTONS_POS[0] - W/2.2 -1.5 +1, -W/2, TH + 1.15 -.1 + .5 -TH/2])
            cube([BUTTONS_POS[2] - BUTTONS_POS[0] + W*.91 +3-2, W, TH*1.5]);

            translate([BUTTONS_POS[0] - W/2.2 -1.5 +1-.5, -W/2, TH + 1.15 -.1 + .5 -TH/2])
            cube([BUTTONS_POS[2] - BUTTONS_POS[0] + W*.91 +2, W, TH*.5]);

/*
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
*/
            // - spacers
            for (x=arr)
                translate([x-TH*2, -W/2, 0])
                cube([TH*4, W, TH*0 + rh/2*2.5]);
        }

        // pin holes
        for (i=[0:2]) {
            xd = -.5 +.1;
            translate([BUTTONS_POS[i], 0, TH*1.75])
            cylinder(d=BUTTONS_D + xd+.2, h=TH*3, center=true);
        }
        
        // - slits
        for (x=arr)
            translate([x-TH*1, -W, -rh])
            cube([TH*2, W*2, rh*2]);
        
    }
}

rotate([90, 0, 0])
{
    if(1)
    %translate([0, 0, 2])
    translate([0, 0, -.6])
    rotate([180, 0, 0])
    knobs();

    spring();
}