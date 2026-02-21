use <../chamferer.scad>

N_CARDS  = 7;

PLAY_H   =  0.5;
PLAY_V   =  0.5;
GAP      =  1.0;

CARD_TH  =  4.2 / 5;
CARD_L   = 85.6 + PLAY_H;
CARD_W   = 54.9 + PLAY_H;
CARDS_T  = N_CARDS * CARD_TH + PLAY_V;

LEVER_W  = 12;
LEVER_D  = 10;
LEVER_TH =  4;
LEVER_CH =  1.6;

TH = .4*3;

$fn = $preview ? 20 : 100;

module cards_chamber(xx=0) {
    cube([CARD_L + xx, CARDS_T, CARD_W]);
}

module cards_holder() {
    clip_x = LEVER_W + CARD_L/4;
    difference() {
        // block
        chamferer(TH, "cube", shrink=false)
        cards_chamber(xx=LEVER_W);

        // chamber
        cards_chamber(xx=LEVER_W + TH*2);

        // cards ghost
        %translate([LEVER_W, 0, 0]) cards_chamber();
        
        // clip hollowing
        translate([clip_x, CARDS_T/2, CARD_W/4])
        cube([CARD_L/2, CARDS_T, CARD_W/2]);

        // lever axis
        translate([LEVER_W/2, 0, LEVER_W/2])
        rotate([-90, 0, 0])
        cylinder(d=LEVER_D+PLAY_V, h=CARDS_T*3, center=true);
    }
    
    // clip
    a = 6;
    clip_l = CARD_L/2;
    dx = sin(a) * TH;
    translate([clip_x + clip_l + GAP, CARDS_T + dx/2, CARD_W/4 + GAP])
    rotate([0, 0, a]) translate([-clip_l, 0, 0]) {
        h = CARD_W/2 - GAP*2;

        cube([clip_l, TH, h]);

        translate([TH*2, 0, 0]) scale([2, 1, 1]) cylinder(d=TH*2, h=h);
    }
    
    // lever: axis
    play = .2;
    translate([LEVER_W/2, -TH-play, LEVER_W/2])
    rotate([-90, 0, 0])
    cylinder(d=LEVER_D, h=CARDS_T + TH*2 + play);

    // lever: cams
    span = N_CARDS * 5;
    for(i=[0: N_CARDS-1]) {
        translate([LEVER_W/2, PLAY_V/2+i*CARD_TH, LEVER_W/2])
        rotate([-90, 0, 0]) hull() {
            d0 = LEVER_W - GAP;
            cylinder(d=d0, h=CARD_TH);

            d1 = d0 / 2;
            translate([0, -(i+1)*(span/N_CARDS), 0])
            cylinder(d=d1, h=CARD_TH);
        }
    }
    
    // lever: handle
    translate([LEVER_W/2, -play, LEVER_W/2])
    difference() {
        chamferer($preview ? 0: LEVER_CH) hull() {
            rotate([-90, 0, 0])
            cylinder(d=LEVER_W, h=LEVER_TH*2, center=true);

            translate([0, 0, CARD_W-LEVER_W])
            rotate([-90, 0, 0])
            cylinder(d=LEVER_W*.6, h=LEVER_TH*2, center=true);
        }
        translate([-LEVER_W/2, -TH, -LEVER_W/2])
        cube([LEVER_W, LEVER_W, CARD_W]);
    }
    
}


module wallet() {
    cards_holder();
}


intersection() {
    wallet();

    //cylinder(d=CARD_L*4, h=CARD_W, center=true);

    //translate([0, 0, -TH]) color("red") cylinder(d=CARD_L*4, h=7);
}