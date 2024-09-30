
use <hinge3.scad>

FLAP_WIDTH     = 45;
TRAY_WIDTH     = 125;
GLASS_DIAMETER = 65;
TRAY_LENGTH    = 250 - 5;
TRAY_HEIGHT    = 15;
WALL           = 2.5     +.75;
BWALL          = 1.4;
HSKIN           = .75;
VSKIN           = .75;

TOLERANCE       = .2;

SEMI_SEP_POS   = 96 - 1;
ATOM           = 0.01;
SP             = .3;
$fn            = 100;

// Tray
// ====

module body() {
    /*
    cube([TRAY_LENGTH, TRAY_WIDTH, WALL]);

    cube([WALL, TRAY_WIDTH, TRAY_HEIGHT]);
    
    translate([TRAY_LENGTH-WALL, 0, 0])
    cube([WALL, TRAY_WIDTH, TRAY_HEIGHT]);

    cube([TRAY_LENGTH, WALL, TRAY_HEIGHT]);

    translate([0, TRAY_WIDTH-WALL, 0])
    cube([TRAY_LENGTH, WALL, TRAY_HEIGHT]);
    */
    
    difference() {
        hull() {
            r = WALL*.8;
            
            for (x=[r, TRAY_LENGTH-r])
            for (y=[r, TRAY_WIDTH-r])
            translate([x, y, TRAY_HEIGHT-r]) {
                sphere(r=r, $fn=20);
                cube([r*2, r*2, ATOM], center=true);
            }

            cube([TRAY_LENGTH, TRAY_WIDTH, ATOM]);
        }

        translate([WALL, WALL, BWALL])
        cube([TRAY_LENGTH-WALL*2, TRAY_WIDTH-WALL*2, TRAY_HEIGHT]);
    }
}

module tray_0() {
    d = TRAY_HEIGHT*.75;
   
    // body
    body();

    // bottle holder
    translate([TRAY_LENGTH-GLASS_DIAMETER/2-WALL+d, GLASS_DIAMETER/2+WALL, 0])
    difference() {
        translate([-GLASS_DIAMETER/2, -GLASS_DIAMETER/2, 0])
        cube([GLASS_DIAMETER-d, GLASS_DIAMETER+WALL, TRAY_HEIGHT]);
    }

    // slanted side
    translate([TRAY_LENGTH-d-WALL, WALL+GLASS_DIAMETER, 0])
    hull() { 
        translate([d, 0, 0])
        cube([ATOM, TRAY_WIDTH-WALL*2 - GLASS_DIAMETER, TRAY_HEIGHT]);

        translate([0, 0, 0])
        cube([d, TRAY_WIDTH-WALL*2 - GLASS_DIAMETER, ATOM]);
    }
    
    // slanted separator
    translate([TRAY_LENGTH-GLASS_DIAMETER-WALL*2, WALL, 0])
    hull() { 
        translate([d, 0, 0])
        cube([WALL, TRAY_WIDTH-WALL*2, TRAY_HEIGHT]);

        translate([0, 0, 0])
        cube([WALL+d, TRAY_WIDTH-WALL*2, ATOM]);
    }
    
    // semi-separator
    translate([0, SEMI_SEP_POS, 0])
    cube([TRAY_LENGTH-GLASS_DIAMETER-WALL*0, WALL, WALL*2]);

    // foot
    w = 10;
    translate([0, 0, -4.5-SP])
    cube([TRAY_LENGTH, w, 4.5+SP + VSKIN], !true);

    // phone
    %translate([WALL, WALL, WALL])
    cube([170, 90, 16]);
}

module tray() {
    difference() {
        tray_0();

        // cord cutout
        m = TRAY_WIDTH/4; //WALL*6;
        translate([-WALL, WALL+m, WALL*1.6])
        cube([WALL*3, SEMI_SEP_POS-WALL-m*2, TRAY_HEIGHT]);

        // bottle hole
        translate([TRAY_LENGTH-GLASS_DIAMETER/2-WALL, GLASS_DIAMETER/2+WALL, BWALL])
        cylinder(d=GLASS_DIAMETER, h=TRAY_HEIGHT+ATOM);
    }
}

// Hinge
// =====

module hinge() {
    // hinge
    angle = 90;
    difference() {
        translate([0, WALL, 0])
        tray_hinge(TRAY_LENGTH, angle);

        translate([-10-1, -WALL, 0])
        cube([10, 6, TRAY_LENGTH]);

        th = 0.07;
        // vertical reinforcement cracks
        if(1)
        for (i=[[-1, .5], [0, .25], [1, .5]])
            translate([4.5*i[1], 4.5/2*0-th/2 + i[0]*1.125, .5])
            cube([20, th, TRAY_LENGTH-1]);

        // horizontal reinforcement cracks
        if(0)
        if ($preview) {
            for (z=[.5: 1: TRAY_LENGTH-.5])
                translate([0, 0, z])
            cube([20, 6, 0.07]);
        }

        // vertical reinforcement cracks
        if(0)
        translate([0, 4.5/2 -th/2, .5])
        cube([20, th, TRAY_LENGTH-1]);
    }

    // flap
    w = 4.5;
    w2 = 1.5;
    translate([w/2, w/2, 0])
    rotate([0, 0, -angle])
    translate([-SP, -w/2,0])
    translate([-.75, w+1, 0]) {
        hull() {
            cube([w, FLAP_WIDTH*.75 - w-1, TRAY_LENGTH]);
            translate([w-w2, FLAP_WIDTH, 0])
            cube([w2, ATOM, TRAY_LENGTH]);
        }
    }
}

// Adhesion / supports
// ===================

module mouse_ear() {
    r = TRAY_HEIGHT*2;
    h = .3;
    h2 = 5;

    difference() {
        h = .3;
        cylinder(r=r, h+.15);

        translate([0, 0, .3])
        cylinder(r=r-14, h);
    }
}

// mouse ears
module mouse_ears() {
    y = TRAY_WIDTH - TRAY_HEIGHT/4 -6;
    translate([-TRAY_HEIGHT/2 +2.5, y, 0]) {
        mouse_ear();
        scale([-1, 1, 1]) mouse_ear();
    }

    translate([-TRAY_HEIGHT/2 +2.5, + TRAY_HEIGHT/4 +6, 0])
    scale([1, -1, 1]) mouse_ear();

    translate([FLAP_WIDTH -2, y, 0])
    scale([-1, -1, 1]) mouse_ear();
}


module support() {
    translate([-BWALL-.05, GLASS_DIAMETER/2+WALL, TRAY_LENGTH-GLASS_DIAMETER/2-WALL])
    union() {
        d = GLASS_DIAMETER-TOLERANCE*2;
        w = GLASS_DIAMETER/5;
        h = TRAY_HEIGHT-BWALL;
        difference() {
            intersection() {
                rotate([0, -90, 0])
                cylinder(d=d, h=h);

                // vertical slice
                cube([TRAY_HEIGHT*3, w, GLASS_DIAMETER*2], center=true);

                // wedge
                translate([-h, 0, d/2-WALL])
                rotate([0, -45, 0])
                translate([0, -w/2, -GLASS_DIAMETER*2 + WALL*3])
                cube([TRAY_HEIGHT*2, w, GLASS_DIAMETER*2]);
            }
        
            translate([0, 0, GLASS_DIAMETER*.75+.3])
            cube([TOLERANCE*2, GLASS_DIAMETER, GLASS_DIAMETER], center=true);
        }
    }
}

// ALL
// ===

module all() {
    rotate([0, -90, 0]) tray();
    y = -3.25;
    translate([SP, TRAY_WIDTH +y, 0]) hinge();
}

all();
mouse_ears();
support();