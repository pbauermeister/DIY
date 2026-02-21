use <../chamferer.scad>

N_CARDS  =  8;

PLAY_H   =  1.5;
PLAY_V   =  0.5;
GAP      =  1.0;

CARD_TH  =  4.2 / 5;
CARD_L   = 85.6 + PLAY_H;
CARD_W   = 54.9 + PLAY_H;
CARDS_T  = N_CARDS * CARD_TH + PLAY_V;

LEVER_W  = 14;
LEVER_D  = 10;
LEVER_TH =  4;
LEVER_CH =  1.6;

STOPPER_H = CARD_W / 2;

TH = .4*4;
TH2 = .4*3;

$fn = $preview ? 20 : 100;
ATOM = 0.01;

module cards_chamber(xx=0) {
    cube([CARD_L + xx, CARDS_T, CARD_W]);
}


module stopper(gap_z=false) {
    // stopper
    h = STOPPER_H + (gap_z ? PLAY_V : 0);

    translate([-TH*2, 0, CARD_W/2 - h/2])
    cube([LEVER_W + TH*2 + ATOM, CARDS_T, h]);
    
    if (gap_z) {
        translate([TH*3, 0, CARD_W/2 - h/2 + h + TH])
        cube([TH*1.5, CARDS_T, h]);

        translate([TH*3, 0, CARD_W/2 - h/2 - h - TH])
        cube([TH*1.5, CARDS_T, h]);
    }
}

module chamber() {
    translate([LEVER_W, 0, 0])
    cards_chamber(xx=TH*2);

    stopper(gap_z=true);
}

module cards_holder_0() {
    clip_x = LEVER_W + CARD_L*.5;
    clip_l = CARD_L/4;
    clip_a = 6 + 4;

    difference() {
        // block
        chamferer(TH, "cube", shrink=false)
        cards_chamber(xx=LEVER_W);

        // chamber
        chamber();

        // cards ghost
        //%translate([LEVER_W, 0, 0]) cards_chamber();
        
        // clip hollowing
        hull() {
            translate([clip_x, CARDS_T/2, CARD_W*.25])
            cube([clip_l, CARDS_T, CARD_W/2]);

            h = CARD_W*.6;
            translate([clip_x, CARDS_T/2, (CARD_W-h)/2])
            cube([clip_l/2, CARDS_T, h]);
        }
        
        // rails
        chamferer(.2, "cube", shrink=false)
        rails(extend=true);
        
        
        // finger
        translate([LEVER_W+CARD_L + TH*2, 0, CARD_W/2])
        rotate([90, 0, 0])        
        cylinder(d=CARD_W/3, h=CARD_W, center=true);
    }
    
    // clip
    translate([clip_x + clip_l + GAP*0, CARDS_T, CARD_W/4 + GAP])
    translate([0, TH, 0])
    rotate([0, 0, clip_a])
    translate([-clip_l+GAP, -TH2, 0]) {
        h = CARD_W/2 - GAP*2;

        cube([clip_l-GAP, TH2, h]);

        translate([TH2*2, TH2*.23, 0])
        rotate([0, 0, 8])
        scale([2, .65, 1]) cylinder(d=TH2*2, h=h);
    }
}

module cards_holder() {
    intersection() {
        cards_holder_0();

        chamferer($preview? 0: TH, "cylinder-y")
        //chamferer($preview? 0: TH/2)
        hull()
        cards_holder_0();
    }
}

module slider() {
    difference() {
        union() {
            intersection() {
                // steps
                for (i=[0:N_CARDS-1]) {
                    l = LEVER_W - (N_CARDS-1 -i)/N_CARDS * LEVER_W + TH;

                    hull() {
                        k = i==0 ? 1 : .7;
                        translate([-TH, PLAY_V/2 + i*CARD_TH + CARD_TH*(1-k), 0])
                        cube([l, CARD_TH*k, CARD_W]);

                        translate([-TH, PLAY_V/2 + i*CARD_TH, 0])
                        cube([l-CARD_TH/2, CARD_TH/2, CARD_W]);


                    }
                }

                // fit into stopper
                chamferer(1, fn=4)
                translate([.3*sin(45), 0, 0]) hull() {
                    stopper();
                    translate([1, 0, 0])
                    stopper();
                }
            }
            rails();
        }

        // mark
        d = CARD_W;
        translate([-TH-d/2 + .5, CARDS_T/2, CARD_W/2])
        rotate([90, 0, 0])
        cylinder(d=d, h=CARDS_T*3, center=true, $fn=60*4);
    }
}

module rails(extend=false) {
    // rails
    h = STOPPER_H - 12; //16 - 4;
    l = LEVER_W * (extend ? 2.5 : 1.5) - TH;
    difference() {
        //chamferer(extend ? 0 : TH, "cone-down")
        translate([PLAY_H/2 + TH*4, CARDS_T - PLAY_V/3 -TH*.5, CARD_W/2 - h/2])
        cube([l, TH*2 + (extend ? 1 : -TH/2+PLAY_V/3), h]);
 
        if (!extend)
            translate([LEVER_W + TH*2-ATOM, .2, 0])
            chamber();
    }

    // knob
    l2 = TH + LEVER_W/N_CARDS + (extend ? LEVER_W : 0);
    th = TH*3 + PLAY_V;
    chamferer(extend ? 0 : 1, "cylinder")
    translate([-TH, TH*2-th, CARD_W/2-h/2])
    cube([l2, th, h]);
}

module wallet() {
    cards_holder();
}

pv = false && $preview;
/*
translate([pv ? 0 : LEVER_W*0,
           pv ? 0 : 30,
           pv ? 0 : -(CARD_W - STOPPER_H)/2 - TH])
*/

translate([0, 10, 7.34])
rotate([-90, 0, 0])
slider();

intersection() {
    wallet();

    //if ($preview) cylinder(d=CARD_L*4, h=CARD_W, center=true);

    //translate([-20, 1, -10]) cube(1000);
    //translate([0, 0, -TH]) color("red") cylinder(d=CARD_L*4, h=7);
}