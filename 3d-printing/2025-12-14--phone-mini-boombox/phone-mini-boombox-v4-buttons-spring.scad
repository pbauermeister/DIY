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

%translate([0, 0, -.6])
rotate([180, 0, 0])
knobs();

POS_X   = -25;
L       = 100;
W       = BUTTONS_D + 1.3*2;
TH      = .5;

difference() {
    translate([POS_X, -W/2, 0])
    cube([L, W, TH]);

    // pin holes
    for (i=[0:2]) {
        xd = i==1 ? .7 : -.5;
        translate([BUTTONS_POS[i], 0, 0])
        cylinder(d=BUTTONS_D + xd, h=TH*3, center=true);
    }
    
    // elastic areas
    m = 7;
    for (x01 = [
                 [POS_X + m, BUTTONS_POS[0] - BUTTONS_D],
                 [BUTTONS_POS[1] + BUTTONS_D, BUTTONS_POS[2] - BUTTONS_D],
                 [BUTTONS_POS[2] + BUTTONS_D, L + POS_X - m],
               ]) {
        x0 = x01[0];
        x1 = x01[1];
        gap = .45;
        th = .7;
        for (x=[x0 : (gap+th)*2 : x1]) {
            translate([x, 0, 0])
            cube([gap, W - th*2, TH*3], center=true);

            translate([x + gap + th, -W/2-th/2.5, 0])
            cube([gap, W - th*2, TH*3], center=true);

            translate([x + gap + th, W/2+th/2.5, 0])
            cube([gap, W - th*2, TH*3], center=true);
        }
    }
}