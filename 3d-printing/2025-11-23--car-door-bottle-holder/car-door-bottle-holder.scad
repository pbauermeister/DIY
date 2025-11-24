use <../chamferer.scad>

D1      =  88-1         +5*0  +0    -1;
D2      =  95-1         +5*0  +4    +3;

H1      =  65;
H2      = 120;

WALL    =   4           -0.5;
OPENING =  64;

CH1 = $preview ? 10 : 10;
CH2 = $preview ?  0 : WALL/3;

$fn = $preview ? 10 : 100;
ATOM = 0.01;

module top_cut(dz=0) {
    translate([0, 0, WALL*2+dz])
    hull() {
        translate([-D2/2, -D2, H2])
        cube([ATOM, D2*2, H2]);
        translate([D2/2, -D2, H1])
        cube([ATOM, D2*2, H2]);
    }
    translate([0, 0, H2])
    cylinder(d=D2*2, h=H2);
}

module body(has_top_cut=true, wall=0) {
    difference() {
        chamferer(CH1, fn=16)
        translate([0, 0, wall])
        cylinder(d1=D1-wall*2, d2=D2-wall*2, h=H2+WALL*4);

        if (has_top_cut) {
            top_cut();
            //%top_cut();
        }
    }
}

module cup() {
    difference() {
        union() {
            body();
            //ring_bumps();
            sphere_bumps();
        }
        
        // carve
        body(has_top_cut=false, wall=WALL);
    }
}

module ring_bumps() {
    d = WALL*3;
    h = H1;
    for (z=[CH1*2 +d: d*2 : h-d/2]) {
        dr = (D2-D1)/2 * (z/H2) * 1.5 -WALL/4;

        translate([0, 0, z])
        rotate_extrude(convexity=10, $fn=100)
        translate([D1/2 + dr, 0, 0])
        scale([.5, 1, 1])
        hull() {
            difference() {
                circle(r=d/2, $fn = 100);
                translate([-d*2 - WALL/2, -d])
                square(d*2);
            }
            translate([-WALL/2, 0])
            square([ATOM, d*1.75], center=true);
        }
    }
}

module sphere_bumps() {
    d = WALL*3;
    h = H1;
    zs = H1/4;
    n = 14;
    for (a=[-180:360/n:180]) {
        dz = (180-abs(a))/180 * (H2-H1)*1.3;
        rotate([0, 0, a])
        for (z0=[-H1:zs:H1-zs]) {
            z = z0+dz;
            if (z>CH1*2 && z<H1+d) {
            dr = (D2-D1)/2 * (z/H2) * 1.0 -WALL/4;
                translate([-D1/2 - dr, 0, z])
                scale([.67, 1, 1])
                sphere(r=d/2, $fn=25);
            }
        }
    }
}

module side_cut() {
    hull() {
        //z1 = WALL * 0.4;
        //z2 = WALL * 2;
        z1 = WALL;
        z2 = z1;
        translate([-OPENING/2, -D2*1.5, z1])
        cube([OPENING, D2, H2*2]);
        
        translate([0, 0, z2])
        cylinder(d=1, h=H2*2);
    }
}

module holder() {
    difference() {
        // cup
        cup();

        // side opening
        rotate([0, 0, 90])
        side_cut();

        // anti-stick
        th = .5*sqrt(2);
        intersection() {
            cylinder(d=D1-WALL*6.5, h=2, center=true);
            for (x=[0:3:D1/2]) {
                for (i=[1,-1]) {
                    translate([x*i, 0, 0])
                    rotate([0, 45, 0])
                    cube([th, D1, th], center=true);
                }
            }
        }
    }

    // reaffirm base
    translate([0, 0, WALL-.5])
    cylinder(d=D1-CH1*(2.4), h=.2+.5);
}

//scale([-1, 1, 1])
holder();
