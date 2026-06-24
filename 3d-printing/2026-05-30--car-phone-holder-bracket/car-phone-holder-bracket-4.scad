use <../chamferer.scad>
L  = 80 - 10;
W  = 10             -9+1;
H  = 50;

W2 = W; //W*.6 +2;

L2 = 35;
L3 = L; //44 + 20;

D  = 6;
D2 = 4.25;

RW = 8.6;
RH = 4.5    + .8;

SD = 4.5;

CH = 9-1;
CH2 = 9;

$fn  = $preview ? 20 : 80;
ATOM = 0.01;

module rail() {
    w = RW;
    h = RH;
    cube([w, 100, h], center=true);

    w2 = w / sqrt(2);
    z2 = RH*.7;
    if(0)
    translate([0, 0, z2])
    scale([1, 1, .7])
    rotate([0, 45, 0])
    cube([w2, 100, w2], center=true);

    h3 = 7-z2;
    translate([0, 0, h3/2*2 + z2*0])
    cube([w, 100, h3], center=true);
}

module rails() {
    for(x=[-L2/2, L2/2])
        translate([x, 0, 0])
        rail();
}

module plate(xh=3, with_rails) {
    difference() {
        translate([0, 0, -H+10]) {

            chamferer(CH, "cylinder-y", fn=4) {
            translate([-L/2, -W, 0])
            cube([L, W, H]);

            l = L/3 -2;
            for(x=[-L/2, L/2-l])
                translate([x, -W, -xh])
                cube([l, W, xh]);
            }

            if (!with_rails) {
                translate([0, 0, H])
                scale([2, 1, 1])
                rotate([90, 0, 0])
                cylinder(d=L/6, h=W);
            }

        }

        if (with_rails)
            rails();

        if (with_rails)
        translate([0, 2, -RH/2-D2 +4.25])
        rotate([90, 0, 0])
        cylinder(d=ATOM, h=W*2);
    }
}

module base() {
    difference() {
        plate(xh=15, with_rails=false);
        
        // hollowing
        translate([0, 1, 0])
        scale([1, 2, 1])
        chamferer(CH2, "plate-y")
        chamferer(CH2, "plate-y", grow=false)
        plate(with_rails=true);
    }
}

module piece()
difference() {
    chamferer($preview?0:W/2-ATOM, fn=4, az=90)
    union() {
        base();
        step = 12.5;

        difference() {
            w = CH2+W*2-.3;
            for (x=[-L/2, L/2-w])
                translate([x, 0, -CH2-RH/2-step*2.75+1])
                cube([w, 7, step*3.75]);


           for (i=[0:3]) {
                th = 6;
                translate([0, 0, -RH/2-.4 -i*step])
                hull() {
                    h = 6;

                    translate([0, 3/sqrt(2), 0])
                    rotate([45, 0, 0])
                    cube([L*2, 3, 3], center=true);

                    translate([0, 3*3, 0])
                    rotate([45, 0, 0])
                    cube([L*2, 3, 3], center=true);
                }
            }
        }

    }

    // spring holes
    for(x=[-L2/2, L2/2])
        translate([x, -2, -RH/2-D2/2])
        rotate([90, 0, 0])
        cylinder(d=D2, h=W*2);

    rails();
}

rotate([$preview?0:90, 0, 0])
piece();
