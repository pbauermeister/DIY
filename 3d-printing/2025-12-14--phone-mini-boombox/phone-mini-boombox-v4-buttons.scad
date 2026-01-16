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
    for (x=BUTTONS_POS) {
        translate([x, 0, 0]) {
            d0 = BUTTONS_D - PLAY*2;
            cylinder (d=d0, h=BUTTONS_PIN_TH);

            for (a=[0, 90])
            hull() {
                d1 = BUTTONS_D - .3;
                cylinder(d=d1, h=TH2/2);

                cylinder(d=d0, h=TH2);

                rotate([0, 0, a])
                translate([0, 0, -1])
                cube([1, d0-.5, ATOM], center=true);
            }
        }
    }

    m = (BUTTONS_POS[1] - BUTTONS_POS[0]) / 2;
    l = BUTTONS_POS[2] - BUTTONS_POS[0] + m*2;
    w = BUTTONS_D * 2;
    att = .4;
    gap = .5;

    th = 2;
    th2 = 0.3;

    chamferer($preview ? 0 : 1, "cone-up")
    translate([0, 0, BUTTONS_PIN_TH]) {
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

rotate([180, 0, 0])
knobs();

