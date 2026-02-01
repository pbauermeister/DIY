use <phone-mini-boombox-v4.scad>
use <../chamferer.scad>


BUTTONS_PIN_TH = 13 + .2    -1 +.5;
BUTTONS_D      = get_buttons_d();
BUTTONS_POS    = get_buttons_pos_x();
TH2            = 1;
PLAY           = 0.5;
ATOM           = 0.01;

$fn = $preview ? 50 : 100;

module knobs() {
    for (i=[0:2]) {
        x = BUTTONS_POS[i];

        translate([x, 0, 0])
        scale([i<2 ? .8 : 1, 1, 1])
        {
            // shaft
            d0 = BUTTONS_D - PLAY*2;

            cylinder (d=d0, h=BUTTONS_PIN_TH);

            // elephant feet
            hull() {
                d1 = BUTTONS_D - .3;
                cylinder(d=d1, h=TH2/2);

                translate([0, 0, -.5])
                cylinder(d=d0-.5, h=TH2/2);

                cylinder(d=d0, h=TH2);
            }
            
            translate([0, 0, -1.5])
            cylinder(d=d0-.5, h=TH2);            
        }
    }

    // cap
    m = (BUTTONS_POS[1] - BUTTONS_POS[0]) / 2;
    l = BUTTONS_POS[2] - BUTTONS_POS[0] + m*2;
    w = BUTTONS_D * 2;
    att = .4;
    gap = .5;

    th = 2      +1;
    th2 = 0.3;

    chamferer($preview ? 0 : 1, "cone-up")
    translate([0, 0, BUTTONS_PIN_TH -.5]) {
        hull() {
            translate([BUTTONS_POS[0], 0, ])
            cylinder(d=m*2, h=th);
            translate([BUTTONS_POS[1], 0, 0])
            cylinder(d=m*2, h=th);
        }

        translate([BUTTONS_POS[2], 0, 0])
        cylinder(d=m*2, h=th);
    }
}

rotate([$preview ? 0 : 180, 0, 0])
knobs();

