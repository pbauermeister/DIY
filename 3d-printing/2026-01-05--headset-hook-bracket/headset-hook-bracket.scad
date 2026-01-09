use <../chamferer.scad>

INNER_W = 41;
INNER_L = 40;
INNER_H = 11;
TH      =  7;
EXT     = 15;
ATOM    =  0.01;
D       =  4.5;
CH      =  3.5;

module bracket0(ch=CH, grow=true) {
    difference() {
        chamferer(ch, grow=grow)
        difference() {
            union() {
                cube([INNER_W+TH*2, INNER_L, INNER_H+TH]);

                translate([-EXT, 0, -CH])
                cube([INNER_W+TH*2+EXT*2, INNER_L, TH +CH]);
            }

            // cavity
            translate([TH, -ATOM, -ATOM])
            cube([INNER_W, INNER_L+ATOM*2, INNER_H+ATOM]);

        }
        
        // shave bottom chamfer
        translate([-EXT-ATOM, -ATOM, -CH*2])
        cube([INNER_W+TH*2+EXT*2+ATOM*2, INNER_L+ATOM*2, CH*2]);

        // screw holes
        for (x=[-EXT/2, INNER_W++TH*2+EXT/2])
            translate([x, INNER_L/2, -ATOM])
            cylinder(d=D, h=TH*2, $fn=50);
    }
}

module bracket() {
    difference() {
        bracket0();

        // reinforcement cracks
        difference() {
            // y-planes
            intersection() {
                bracket0(1.5, grow=false);
                union() for (y=[INNER_L*.40: .2: INNER_L*.60])
                    translate([0, y, 0])
                    cube([INNER_L*6, .1, INNER_H*3], center=true);
            }

            // z-planes
            for (z=[0: 1: INNER_H + TH])
                translate([0, 0, z])
                cube([INNER_L*6, INNER_W*4, .9], center=true);
        }
        
    }
}

intersection() {
    rotate([90, 0, 0])
    bracket();
}