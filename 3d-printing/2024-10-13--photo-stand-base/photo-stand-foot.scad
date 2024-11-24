use <lib.scad>

RADIUS = 45;
ATOM   =  0.01;

/*
GX = 7.85;
GY = 6.00;
D  = 4.2 +.5;
H2 = .3;
*/

FIRST_LAYER = .3 -.1;

H1 = FIRST_LAYER + .7;


module layer0() {
    hull() {
        for (z=[0, FIRST_LAYER, H1]) {
            k = z==H1 ? .98 : 1;
            translate([0, 0, z])
            scale([k, k, 1])
            intersection() {
                goblet();
                cylinder(r=RADIUS*2, h=ATOM);
            }
        }
    }
}

/*
module layer1(height=H1+H2, extra_r=0) {
    cylinder(r=RADIUS-3 + extra_r, h=height, $fn=100);
    
    r = RADIUS - 1;
    w = 1.8;
    translate([-r, -w/2, 0])
    cube([r*2, w, height]);
}

module raster() {
    if(0)intersection() {
        translate([0, 0, FIRST_LAYER])
        for (x=[-10:10]) {
            for (y=[-15:15]) {
                translate([x*GX + (y%2==0 ? 0 : GX/2), y*GY/2, 0])
                rotate([0, 0, 20])
                cylinder(d=D, h=(H1+H2)*2, $fn=8);
            }
        }
        layer1(H1+H2*2, 0.5);
    }

    intersection() {
        a = atan (GX/GY);
        union()
        for (i=[-9: 8]) {
            translate([GX*i, 0, 0])
            rotate([0, 0, a])
            translate([D/2, GY*i, 0])
            translate([0, -RADIUS, 0])
            cube([.1, RADIUS*2, H1+H2]);
        }
        layer1(H1+H2*2, 0.5);
    }
}

module _all() {
    difference() {
        union() {
            layer0();
            layer1();
        }
!        raster();
    }
}

*/

module all() {
    difference() {
        layer0();
        translate([0, 0, FIRST_LAYER])
        cylinder(r=RADIUS-3, h=H1*3, $fn=100);
    }
}


all();
