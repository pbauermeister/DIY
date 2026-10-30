use <../chamferer.scad>

INNER_L  = 110 -2;
INNER_W  =  40 -2;
MARGIN   =  30;
BOARD_TH =  18      +3      /* delete me after corrective print */ + 3;

INNER_TH =   2;
KZ       =   0.85;

SCREW_DY =  67;
SCREW_DX =  55  - 20;
SCREW_D1 =   4;
SCREW_D2 =   8;

ATOM = 0.01;

FN = $preview? 16 : 64+32;
$fn = FN;

module board() {
    difference() {
        cube([INNER_L + 4*MARGIN, INNER_W + 2*MARGIN, BOARD_TH], center=true);
        
        chamferer(10, "cylinder-z", fn=FN)
        cube([INNER_L, INNER_W, BOARD_TH*2], center=true);
    }
}

/*
module spine() {
    e = ATOM;
    difference() {
        cube([INNER_L + MARGIN + e, INNER_W + MARGIN + e, BOARD_TH], center=true);
        cube([INNER_L + MARGIN - e, INNER_W + MARGIN - e, BOARD_TH*2], center=true);
    }
}
*/

module spine() {
    e = ATOM;
    l = INNER_L + MARGIN - INNER_TH;
    w = INNER_W + MARGIN - INNER_TH;
    ch = MARGIN * .93;
    difference() {
        chamferer(ch, "cylinder-z", fn=FN)
        cube([l+e, w+e, BOARD_TH], center=true);

        chamferer(ch, "cylinder-z", fn=FN)
        cube([l-e, w-e, BOARD_TH*2], center=true);
    }
}
//!spine();

module handle_0() {
    difference() {
        scale([1, 1, KZ])
        chamferer(MARGIN/2, fn=FN, shrink=false)
        spine();

        board();
    }
}

module screw() {
    translate([0, 0, BOARD_TH/2-1]) cylinder(d=SCREW_D1, h=MARGIN);
    translate([0, 0, BOARD_TH/2+3]) cylinder(d=SCREW_D2, h=MARGIN);

    translate([0, 0, (BOARD_TH+MARGIN)*KZ/2-SCREW_D2/1.6])
    scale([1, 1.15, 1])
        cylinder(d1=0, d2=SCREW_D2*2, h=SCREW_D2);

}

module screws() {
    for(ky=[-1, 1]) for(kx=[-1, 1]) for (k=[-1, 1]) {
        x = kx * SCREW_DX;
        y = ky * SCREW_DY/2;
        scale([1, 1, k]) {
            translate([x, y, 0])
            screw();
        }
    }
}

module scaffold() {
    th = .3;
    a = INNER_W/2+MARGIN*.8 * 1.5;
    l = INNER_L + MARGIN/2;
    x = INNER_L/2 + MARGIN - l/2;
    difference() {
        for (k=[1, -1]) {
            translate([x, a*k, 0])
            cube([l, .3, BOARD_TH*3], center=true);

            translate([x, 0, (BOARD_TH/2+.3/2)*k])
            cube([l, (a+th/2)*2, 0.3], center=true);
        }
        cube([INNER_L, INNER_W, BOARD_TH*2], center=true);
    }
}

module handle() {
    intersection() {
        difference() {
            union() {
                difference() {
                    handle_0();
                    
                    // middle cut
                    cylinder(d=INNER_L*10, h=2, center=true);
                }
                scaffold();
            }
            screws();
        }

        // side cuts
        rotate([0, 90, 0])
        cylinder(d=INNER_L*10, h=INNER_L+MARGIN*1.75, center=true);
    }
}

rotate([0, $preview ? 0 : 90, 0]) {
    handle();
    %board();

}