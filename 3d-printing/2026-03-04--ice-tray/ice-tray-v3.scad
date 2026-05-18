use <../chamferer.scad>

L       = 285               -35;
W       = 140                -3;
H       =  15               +10;
H1      =  15;
H2      =  20;
DH      = -24.75            +10;
W2      = 12;

TH      =   3;

RAIL_W  = 16.5  -1.5;
RAIL_H  = 8+1;

CH      = $preview ? 0 : 1.5;
ATOM    = 0.01;

module hook() {
    difference() {
        chamferer(CH)
        union() {
            h = RAIL_H;
            difference() {
                translate([-TH, -RAIL_W-TH*2, H2*2-h-TH + DH])
                cube([L+TH*2, RAIL_W+TH*2, h+TH]);

                translate([-L/2, -RAIL_W-TH, H2*2-h-TH-ATOM + DH])
                cube([L*2, RAIL_W, h]);
            }

            translate([-TH, -TH, +H2*.5 + DH])
            cube([L+TH*2, TH, H2*1.5]);

            r = TH/2;
            l = 15;
            for (x=[-TH, L-l +TH])
            translate([x, -TH -RAIL_W, H2*2-h-TH + DH -r/2]) hull() {
                translate([0, -r/2, 0])
                rotate([0, 90, 0])
                cylinder(r=r, h=l, $fn=50);

                translate([0, -r, r/2])
                rotate([0, 90, 0])
                cylinder(r=r, h=l, $fn=50);
            }
        }

        // shave hooks
        translate([0, -RAIL_W - TH*1.7, 0])
        rotate([0, 0, 45*1.6])
        translate([-W, -W/2, -W/2])
        cube(W);

        translate([L, -RAIL_W - TH*1.7, 0])
        rotate([0, 0, 180 -45*1.6])
        translate([-W, -W/2, -W/2])
        cube(W);
    }
}

module container() {
    l = L+TH*2;
    chamferer(CH)
    difference() {
        union() {
            chamferer(TH, "hemisphere-down")
            translate([-TH, -TH, 0])
            cube([l, W+TH*2, H+TH]);

            chamferer(CH)
            hull() {
                translate([-TH, -TH, -H2 + DH])
                cube([l, TH, H2*3]);

                translate([-TH, 0, 0])
                cube([l, W2, H]);
            }

        }

        // tray content
        chamferer(TH/2)
        cube([L, W, H*2]);

        if (0) %chamferer(TH/2)
        cube([L, W, H]);

        translate([-L/2, 0, H1])
        cube([L*2, W*2, H*2]);

        // shave foot corners

        translate([H*2, 0, -H*2])
        rotate([0, -45*1.25, 0])
        translate([-W, -W/2, -W/2])
        cube(W);

        translate([L-H*2, 0, -H*2])
        rotate([0, -45*1.25, 180])
        translate([-W, -W/2, -W/2])
        cube(W);

    }
}

module tray() {
    difference() {
        union() {
            container();

//            chamferer(CH)
            hook();
        }

        // reinforcement crack
        if (!$preview) cracker();
    }
}

module cracker() {
    chamferer(TH/2 - .05/8, grow=false)
    hook();
}

PLAY = 0.15;
JOIN = 3.5;

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

    hull() {
        translate([x, -TH*.2+xtra, -H2*.7 -xtra/2])
        cube([JOIN, TH*1.6-xtra*2., H2*.4-xtra*2]);

        translate([x, -TH*.2+xtra, -H2*1.125 -xtra/2])
        cube([JOIN, TH*.67-xtra*2, H2*.6-xtra*2]);
    }
}

module part1() {
    intersection() {
        tray();
        partitioner(true);
    }
}

//!partitioner();
module part2() {
    difference() {
        tray();
        partitioner(false);
    }
}

//            chamferer(TH/2 - .1/2, "cube", grow=false)
//            hook();

//!tray();
//!cracker();

module all() {
    translate([H+.5, 0, 0])
    rotate([0, -90, 0])
    part1();

    translate([-H-.5, 0, L])
    rotate([0, 90, 0])
    part2();

    // binder
    for (y=[-TH*.8, W+TH/2])
    translate([-11, y, 0])
    cube([22, .3, L/2*.67]);
}


intersection() {
    all();

//    cylinder(d=30, h=L*4, center=true);
}


// clamper
d = 30;
e = 20;
f = 35;

hull() for (k=[1, -1]) scale([k, 1, 1])
    translate([H+TH + .5, W-d, -TH])
    cube([1, f, .2]);

for (k=[1, -1])
scale([k, 1, 1])
hull() {
    translate([H+TH + .5, W-d, -TH])
    cube([d-TH/2, e, 1]);
    translate([H+TH + .5, W-d, -TH])
    cube([1, f, 1]);
}
