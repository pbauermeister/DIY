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

POS_X   = -20                   +5   +2.5   +2.5;
L       =  90                   -15  -5     -5;
TH      =   0.80;
W       = BUTTONS_D + 1.3*2;
EXT_H   =   5.5;
EXT_L   =  10                   +5;
EXT_A   = atan(EXT_H/EXT_L);

module spring() {
    // base
    difference() {
        translate([POS_X, -W/2, 0])
        cube([L, W, TH]);

        // pin holes
        for (i=[0:2]) {
            xd = -.5    +.3 -.2; //i==1 ? .7 : -.5;
            translate([BUTTONS_POS[i], 0, 0])
            cylinder(d=BUTTONS_D + xd, h=TH*3, center=true);
        }
    }
    
    // slanted ends
    dx = sin(EXT_A)*TH;
    translate([POS_X + L - dx, -W/2, 0])
    rotate([0, EXT_A, 0])
    cube([EXT_L, W, TH]);

    translate([POS_X + dx, -W/2, 0])
    rotate([0, -EXT_A, 0])
    translate([-EXT_L, 0, 0])
    cube([EXT_L, W, TH]);

    // bridge
    
    // - ramps
    rl = W*.78;
    ra = 19.75;
    rh = 2.4;
    translate([BUTTONS_POS[0] - BUTTONS_D*1.75, -W/2, 0])
    rotate([0, -ra, 0])
    cube([rl, W, TH]);

    translate([BUTTONS_POS[2] + BUTTONS_D*1.75, -W/2, 0])
    rotate([0, ra, 0])
    translate([-rl, 0, 0])
    cube([rl, W, TH]);

    // - bridge
    difference() {
        translate([BUTTONS_POS[0] - W/2.2, -W/2, TH + 1.15])
        cube([BUTTONS_POS[2] - BUTTONS_POS[0] + W*.91, W, TH]);

        // pin holes
        for (i=[0:2]) {
            xd = i==1 ? .7 : -.5;
            translate([BUTTONS_POS[i], 0, TH*2])
            cylinder(d=BUTTONS_D + xd, h=TH*3, center=true);
        }
    }

    // - spacers
    translate([(BUTTONS_POS[2]+BUTTONS_POS[1])/2-TH/2, -W/2, 0])
    cube([TH, W, TH + rh/2]);
    translate([(BUTTONS_POS[0]+BUTTONS_POS[1])/2-TH/2, -W/2, 0])
    cube([TH, W, TH + rh/2]);
}

rotate([90, 0, 0])
{
    %translate([0, 0, 2])
    translate([0, 0, -.6])
    rotate([180, 0, 0])
    knobs();

    spring();
}