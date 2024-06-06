/*
Stand to serve as fixture for base of TomTom GPS.
Fits for Skoda Roomster.
Snaps into the air vent in the front (facing user), and screwed at tail.
*/

L = 120;
W = 100;
H =  21;
D =  54;

CUTOUT_CIRCLE1_R = 240;
CUTOUT_CIRCLE1_Y = -W*.725;

CUTOUT_CIRCLE2_R = 100;
CUTOUT_CIRCLE2_Y = -W*.93;

BODY_ELEVATION = 5-3  -1;
BODY_THICKNESS = 10;
BODY_SCREW_PILLAR_D = 25;

CENTRAL_CUTOUT_LENGTH = 65+3;

PILLAR_Y = D * 1.25 +10;
SCREW_PILLAR_Y = W + 20;

BASE_RECESS = 1.5;

GPS_Y_POS = 25;
GPS_SIZE = [119, 20, 65];

$fn = 120*2;
ATOM = 0.01;

CROSS_CUT = false;

module cutout(inner=true) {

    scale([1, 1, .9])
    rotate([3, 0, 0]) {
        tilt=4;
        difference() {
            union() {
                rotate([tilt, 0, 0])
                translate([0, CUTOUT_CIRCLE1_R/9, -CUTOUT_CIRCLE1_R + 12])
                rotate([0, 90, 0])
                cylinder(r=CUTOUT_CIRCLE1_R, h=W*2, center=true);

                translate([0, W*.93, H*.433])
                rotate([-11, 0, 0])
                translate([-W/2, 0, -H])
                cube([W, W*2, H]);
            }

            translate([0, CUTOUT_CIRCLE1_Y, -H*3])
            cube([L*3, W*2, H*9], center=true);
        }

        difference() {
            rotate([tilt, 0, 0])
            translate([0, W+CUTOUT_CIRCLE1_Y, -CUTOUT_CIRCLE2_R + 12])
            rotate([0, 90, 0])
            cylinder(r=CUTOUT_CIRCLE2_R, h=W*2, center=true);

            if (inner)
                translate([0, CUTOUT_CIRCLE2_Y, -H*3])
                cube([L*3, W*2, H*9], center=true);
        }
    }
}

module body() {
    intersection() {
        translate([-L/2, 0, BODY_ELEVATION])
        cube([L, W*.6, H-BODY_ELEVATION]);

        k = .85;
        translate([0, 0, BODY_THICKNESS])
        scale([1, k, k])
        cutout(inner=false);            
    }
    pillar();
}

module snap_bar() {
    BODY_THICKNESS = 3.5;
    w = 3.3;
    r = 5/2;
    difference() {
        translate([-L/2, W+CUTOUT_CIRCLE2_Y-.3, BODY_ELEVATION])
        cube([L, w, BODY_THICKNESS]);

        if (!CROSS_CUT)
            central_cutout();
    }
}

module central_cutout() {
    r = 5/2;
    dh = 3;
    dz = 5+2 +2;
    th = r*2;

    translate([0, 0, dz])
    for (a=[0:1:90])
    rotate([a, 0, 0])
    translate([0, -r/2, dh])
    hull() {
        translate([-CENTRAL_CUTOUT_LENGTH/2+r, 0, 0])
        cylinder(r=r, h=H*2, center=true);

        translate([CENTRAL_CUTOUT_LENGTH/2-r, 0, 0])
        cylinder(r=r, h=H*2, center=true);

        translate([-CENTRAL_CUTOUT_LENGTH/2+r, -th, 0])
        cylinder(r=r, h=H*2, center=true);

        translate([CENTRAL_CUTOUT_LENGTH/2-r, -th, 0])
        cylinder(r=r, h=H*2, center=true);
    }
}

module pillar() {
    // fixture pillar
    translate([0, PILLAR_Y, .2])
    cylinder(d=D, h=H);

    hull() {
        // fixture pillar
        translate([0, PILLAR_Y, 0])
        cylinder(d=D+8, h=H);

        translate([0, W/2 + 8.5, 0]) {
            r = 5;
            translate([-L/2+r, 0, 0])
            cylinder(r=r, h=H);

            translate([L/2-r, 0, 0])
            cylinder(r=r, h=H);
        }

        // screw pillar
        translate([0, SCREW_PILLAR_Y, -H + BODY_THICKNESS/2 + 3.5  +6]) //-BODY_THICKNESS + BODY_THICKNESS * .74])
        cylinder(d=BODY_SCREW_PILLAR_D, h=H);
    }
}

module contour() {
    intersection() {
        // side
        hull() {
            scale([1, 1, 2])
            pillar();
            
            //cube([L, ATOM, H*3], center=true);

            r = H *.92;
            translate([0, r/2, r/2])
            rotate([0, 90, 0])
            cylinder(d=r, h=L, center=true);
        }
    }
}

module screw_hollowing() {
    translate([0, SCREW_PILLAR_Y, 0])
    cylinder(d=5.5, h=H*2);

    translate([0, SCREW_PILLAR_Y, 6+3+4])
    cylinder(d=11, h=H*2);
}

module all() {
    difference() {
        intersection() {
            body();
            contour();
        }
        
        translate([0, PILLAR_Y, H - BASE_RECESS])
        cylinder(d=D+.5, h=H);

        
        if (!CROSS_CUT)
            central_cutout();

        cutout();
        
        if (!CROSS_CUT)
            screw_hollowing();
    }

    snap_bar();
}


rotate([0, 90, 0]) {
    // GPS
    %translate([-GPS_SIZE.x/2, PILLAR_Y - D/2 - GPS_Y_POS, H+5]) cube(GPS_SIZE);

    intersection() {
        all();
        if (CROSS_CUT) cube([2, 1000, 1000], true);
    }

    translate([0, W/2, -H*.75*0])
    hull() {
        h = H*3;
        dh = H*.75;

        translate([L/2-1, 0, -h+dh-2])
        cube([1, .5, h -2]);

        translate([L/2-4, 0, -h+dh])
        cube([1, .5, h]);

        translate([-L/4, 0, -h/2+dh])
        cube([1, .5, h/2]);
    }

/*
if(0)
%
    translate([-.1, 0, 0])
    intersection() {
    rotate([3, 0, 0])
        all();
        if (CROSS_CUT) cube([2, 1000, 1000], true);
    }
*/

//%   cube([5, 500, H +4]);
//%   translate([-2, 0, 8.2]) cube([5, 500, 3]);

}

