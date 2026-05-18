use <../chamferer.scad>

L       = 285; // real
//L       =  10; // test
W       = 140;
H       =  15;
H2      =  10;
DH      = -10 +5.25;

TH      =   4;

RAIL_W  = 16.5;

CH      = $preview ? 0 : 1;
ATOM    = 0.01;


module hook() {
    difference() {
        h = RAIL_W/2;
        translate([-TH, -RAIL_W-TH*2, H2*2-h-TH + DH])
        cube([L+TH*2, RAIL_W+TH*2, h+TH]);

        translate([-L/2, -RAIL_W-TH, H2*2-h-TH-ATOM + DH])
        cube([L*2, RAIL_W, h]);
    }

    translate([-TH, -TH, -H2 + DH])
    cube([L+TH*2, TH, H2*3]);
}

module tray() {
    difference() {
        union() {
            chamferer(CH)
            difference() {
                chamferer(TH, "hemisphere-down")
                translate([-TH, -TH, 0])
                cube([L+TH*2, W+TH*2, H+TH]);

                chamferer(TH/2)
                cube([L, W, H*2]);
            }

            chamferer(CH)
            for (x=[-TH, L])
            hull() {
                translate([x, -TH, -H2 + DH])
                cube([TH, TH, H2*3]);

                translate([x, 0, 0])
                cube([TH, W/4, H]);
            }

            chamferer(CH)
            hook();
        }

        // reinforcement crack
        chamferer(TH/2 - .1/2, "cube", grow=false)
        hook();
    }
}

PLAY = 0.15;
JOIN = 4;

module partitioner(inter) {
    
    translate([-TH*2 -JOIN/2, -W, -H2*3])
    cube([L/2 + TH*2, W*3, H2*6]);

    x = L/2 - (inter ? 1 : 1)*ATOM -JOIN/2;
    xtra = PLAY * (inter ? 1 : -1);

    translate([x, -TH/2+xtra, -TH/2+xtra])
    cube([JOIN, W+TH-xtra*2, H2*3]);

    translate([x, -RAIL_W-TH*3, H2*2 - TH/2+xtra + DH])
    cube([JOIN, RAIL_W+TH*4, TH]);

    translate([x, -RAIL_W-TH*3 + TH/2-xtra, H2*2 - RAIL_W + DH])
    cube([JOIN, TH, RAIL_W]);

    translate([x, -TH/2+xtra, -H2-TH-xtra/2 + DH])
    cube([JOIN, TH, H2-DH]);
}

module part1() {
    intersection() {
        tray();
        partitioner(true);
    }
}

module part2() {
    difference() {
        tray();
        partitioner(false);
    }
}

rotate([0, -90, 0])
part1();

translate([-H*2.1, W*0, L])
rotate([0, 90, 0])
part2();
