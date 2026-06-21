use <../chamferer.scad>

INNER_L = 152;
INNER_W =  72.5;
INNER_H =  40;
TH      =  8;
GROOVE  = 17.5;
CLIP_H  = 30;
DY      = 15;

ATOM = 0.01;

module holder() {
    difference() {
        chamferer(/*$preview? 0 :*/ TH/1.9696165, fn=9, ay=90, ax2=180)
        difference() {
            union() {
                cube([INNER_L+TH*2, INNER_W+TH*2, INNER_H]);

                translate([0, 0, -CLIP_H])
                cube([INNER_L+TH*2, INNER_W+TH*2, CLIP_H]);
            }

            translate([TH, TH, -ATOM])
            cube([INNER_L, INNER_W, INNER_H + CLIP_H + ATOM*2]);
        }

        translate([-TH, DY, -CLIP_H-ATOM])
        cube([INNER_L+TH*4, GROOVE, CLIP_H+ATOM]);

        translate([TH, DY, -CLIP_H-ATOM])
        cube([INNER_L, GROOVE, CLIP_H*2]);

        // reinforcement crack
        difference() {
            translate([TH, TH, -CLIP_H-ATOM])
            cube([INNER_L, INNER_W, INNER_H + CLIP_H + ATOM*2]);

            chamferer(.2, "cube", grow=false)
            translate([TH, TH, -CLIP_H*1.5])
            cube([INNER_L, INNER_W, INNER_H + CLIP_H *2]);
        }
    }

}

//%translate([TH, TH, 0]) cube([INNER_L, INNER_W, INNER_H]);

holder();
