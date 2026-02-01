use <../chamferer.scad>

SHAFT_D =  5;
HAND_L  = 15;
HAND_D  =  4;
SHAFT_L =  5;
HAND_TH =  3;

TH      =  2;
CH      =  0.5;
M       =  0.08;
SLIT    =  0.7;

HAND_M  =  5;

$fn = $preview ? $fn*2 : 50;
ATOM = 0.01;

module indicator() {
    chamferer($preview ? 0 : CH) {
        difference() {
            union() {
                cylinder(d=SHAFT_D +TH*2, h=SHAFT_L);

                // teardrop shape
                hull() {
                    cylinder(d=SHAFT_D +TH*2, h=HAND_TH);

                    translate([HAND_L, 0, 0])
                    cylinder(d=HAND_D, h=HAND_TH);
                }

                // spring
                chamferer(CH+ATOM, "cylinder", shrink=false)
                translate([-SHAFT_D/2, 0, 0])
                scale([0.9, 1.1, 1])
                difference() {
                    cylinder(d=SHAFT_D +TH*2, h=HAND_TH);
                    cylinder(d=SHAFT_D +TH*2 -ATOM, h=HAND_TH*4, center=true);
                }
            }
            
            // hole
            cylinder(d=SHAFT_D + M*2, h=SHAFT_L*3, center=true);

            // slit
            translate([-SHAFT_D/2-TH, -SLIT/2, -ATOM])
            cube([SHAFT_D/2 + TH + HAND_L - HAND_M, SLIT, HAND_L*2]);

            // holes
            translate([HAND_L - HAND_M, 0, 0])
            cylinder(d=1.4, h=SHAFT_L*3, center=true);
        }

        // shaft flat
        translate([-SHAFT_D/2, SHAFT_D*.35 -.5, 0])
        cube([SHAFT_D, SHAFT_D/4 + .5, SHAFT_L]);
    }
}


indicator();