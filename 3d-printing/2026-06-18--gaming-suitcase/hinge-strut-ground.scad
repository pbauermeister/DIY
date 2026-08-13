use <../chamferer.scad>
include <constants.scad>
use <screen-bezel.scad>
use <hinge-struts.scad>

BW = LID_BEZEL_L0_W - LID_BEZEL_L0_PLAY*2;
TH = LID_BEZEL_L0_TH;
BL = LID_BEZEL_L0_L - LID_BEZEL_L0_PLAY*2;
H  = LID_BEZEL_L0_TH0 + LID_BEZEL_L0_PILLAR_H;

W  = 30;
L  = 97.5;
Y  = 90;
DY = 15;
DX =  4                 -3;

%screen_bezel_l0();

ARM_TH =  6;
ARM_D  = 11;

th = 5;
dz = 3;

module hinge() {
    %screen_bezel_l0();
    translate([-(BL/2-L-TH)-L, 0, 0]) {

        // hinge
        translate([DX, DY, 0])
        for (xth=[[th-3, 3+1, true], [th+ARM_TH, th, false]])
        translate([-th+2.5 + xth[0], BW/2 - Y, H]) difference() {
            hull() {
                translate([0, 0, ARM_D/2 + dz])
                rotate([0, 90, 0])
                cylinder(d=ARM_D, h=xth[1]);

                translate([0, -ARM_D*0.75, -dz])
                cube([xth[1], ARM_D*2.5, dz]);
            }

            // axis hole
            translate([th/2, 0, ARM_D/2 + dz])
            scale([.67, 1, 1])
            rotate([0, 90, 0])
            screw_anchor_hole(SCREW_D-.65, force=true, z=0);

            // screw head hole
            if (xth[2])
                translate([-1.5, 0, ARM_D/2 + dz])
                rotate([0, 90, 0])
                cylinder(d=3.8, h=xth[1], $fn=20);
        }


        // sleeve
        difference() {
            th = 2.5;
            w = 30;
            chamferer(th, "cube", shrink=false)
            intersection() {
                translate([(BL/2-L-TH)+L, 0, 0])
                screen_bezel_l0();

                translate([0, -11 -th, 0])
                translate([-w/4, 0, LID_BEZEL_L0_TH+.1])
                cube([w, L, H]);
            }
        }
    }

    // lock
    hull() {
        d = 18;
        dth = 3;

        translate([-BL/2 +d, SCREEN_ATT_W*.5 -2, 0])
        cylinder(d=d, h=LID_BEZEL_L0_TH + dth);

        translate([-SCREEN_ATT_L*.5 +1, SCREEN_ATT_W*.5 -2, 0])
        cylinder(d=d, h=LID_BEZEL_L0_TH + dth);
    }
}

module bracket() {
    difference() {
        hinge();
        
        // shave clip
        translate([-BL/2 + LID_BEZEL_L0_PILLAR_D + .3, SCREEN_ATT_W/2 - ARM_D*2, 0])
        cube([5, ARM_D*4, H*.75]);
        
        if ($preview)
            translate([0, 0, -ATOM])
            screen_bezel_l0();

        for (i=[-1, 1]) for (j=[-1, 1]) for (k=[-1, 1])
        translate([i*.2, j*.2, k*.2]) {
            if (!$preview)
            screen_bezel_l0();

            h = LID_BEZEL_L0_PILLAR_H-LID_BEZEL_L0_TH;
            scale([-1, 1, 1]) 
            chamferer(h, fn=6)
            translate([0, 3, LID_BEZEL_L0_TH -h -1.5])
            cube([LID_BEZEL_L0_L, CABLE_PASSAGE, h*2]);
        }

        // remove screw hole
        translate([-SCREEN_ATT_L*.5, SCREEN_ATT_W*.5, 0])
        cylinder(d=5, h=LID_BEZEL_L0_TH * 20, center=true);
    }
}
rotate([$preview ? 0 : -90, 0, 0])
for (k=[1, -1]) scale([k, 1, 1])
translate([$preview ? 0 : BL*.52, 0, 0]) 
bracket();