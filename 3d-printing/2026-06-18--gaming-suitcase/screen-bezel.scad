include <constants.scad>

l = LID_BEZEL_L0_L - LID_BEZEL_L0_PLAY*2;
w = LID_BEZEL_L0_W - LID_BEZEL_L0_PLAY*2;
th = LID_BEZEL_L0_TH;
r = LID_BEZEL_L0_HINGE_R;

$fn = $preview ? 30 : 200;

module pillar() {
    h = LID_BEZEL_L0_TH0+LID_BEZEL_L0_PILLAR_H;
    cylinder(d1=LID_BEZEL_L0_PILLAR_D-h/2,
             d2=LID_BEZEL_L0_PILLAR_D,
             h=h*.75);
    translate([0, 0, h*.75])
    cylinder(d2=LID_BEZEL_L0_PILLAR_D-h/2,
             d1=LID_BEZEL_L0_PILLAR_D,
             h=h*.25);
}

module screw_hole() {
    translate([0, 0, LID_BEZEL_L0_TH0]) {
        cylinder(d=SCREW_D, h=LID_BEZEL_L0_PILLAR_H*2);

        for (a=[0:360/8:360])
            rotate([0, 0, a])
            cube([SCREW_D*1.5, .1, LID_BEZEL_L0_PILLAR_H*2]);
    }
}

module screen_bezel_l0() {
    difference() {
        union() {
            // plate
            difference() {
                // plate
                translate([-LID_BEZEL_L0_L/2, -LID_BEZEL_L0_W/2, 0])
                translate([LID_BEZEL_L0_PLAY, LID_BEZEL_L0_PLAY, 0])
                hull() {
                    translate([th, th, th])
                    cube([l-th*2, w-th*2,  ATOM]);

                    cube([l, w,  ATOM]);
                }

                // hinge clearance
                translate([-LID_BEZEL_L0_L/2, -LID_BEZEL_L0_W/2, 0])
                translate([0, 0, r])
                rotate([0, 90, 0]) {
                    cylinder(r=r, h=LID_BEZEL_L0_L);
%                    cylinder(r=r, h=LID_BEZEL_L0_L);
                }

                // center clearance
                lc = SCREEN_ATT_L + LID_BEZEL_L0_SIDE_CLR*3;
                cube([lc, SCREEN_ATT_W-LID_BEZEL_L0_PILLAR_D, th*10], center=true);
                
                // side clearances
                for (ky=[-1, 1]) {
                    my = 30;
                    mx = 30;
                    l_ = LID_BEZEL_L0_L-mx*2;
                    l = SCREEN_ATT_L + LID_BEZEL_L0_PILLAR_D*0;
                    translate([-l/2, -my/2 +ky*w/2, -th])
                    cube([l, my, th*10]);
                }
                
            }

            // H pillars rails
            for (ky=[-.5, .5]) {
                for (kx=[-.5, .5]) {
                    translate([kx*SCREEN_ATT_L, ky*SCREEN_ATT_W, 0])
                    pillar();
                }

                hull() for (kx=[-.5, .5]) {
                    w = LID_BEZEL_L0_W-LID_BEZEL_L0_PILLAR_D*4;
                    translate([kx*SCREEN_ATT_L, ky*w , 0])
                    pillar();
                }
            }

            // V pillars rails
            for (kx=[-.5, .5]) {
                hull() for (ky=[-.5, .5]) {
                    l = LID_BEZEL_L0_L - LID_BEZEL_L0_PILLAR_D*2;
                    w = LID_BEZEL_L0_W - LID_BEZEL_L0_PILLAR_D*3;
                    translate([kx*l, ky*w, 0])
                    pillar();
                }
            }
        }

        // screw holes
        for (ky=[-.5, .5]) {
            for (kx=[-.5, .5]) {
                translate([kx*SCREEN_ATT_L, ky*SCREEN_ATT_W, 0]) {
                    screw_hole();
                }
            }
        }
    }
}

screen_bezel_l0();