
use <hinge3.scad>

FLAP_WIDTH     = 45;
TRAY_WIDTH     = 125;
GLASS_DIAMETER = 65;
TRAY_LENGTH    = 250;
TRAY_HEIGHT    = 20         -5;
WALL           = 4.5      *0 + 2.5;
BWALL          = 1.2;
HSKIN           = .75;
VSKIN           = .75;


POS            = 96;
ATOM           = 0.01;
SP             = .3;
$fn            = 100;



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

module tray() {
    // body
    difference() {
        /*
        cube([TRAY_LENGTH, TRAY_WIDTH, TRAY_HEIGHT]);
        translate([WALL, WALL, WALL])
        cube([TRAY_LENGTH-WALL*2, TRAY_WIDTH-WALL*2, TRAY_HEIGHT-WALL+ATOM]);
        */
        body();
        
        // cord cutout
        m = WALL*6;
        translate([-WALL, WALL+m, WALL*1.6])
        cube([WALL*3, POS-WALL-m*2, TRAY_HEIGHT]);
    }

    // glass/bottle holder
    translate([TRAY_LENGTH-GLASS_DIAMETER-WALL, GLASS_DIAMETER+WALL, 0])
    cube([GLASS_DIAMETER, WALL, TRAY_HEIGHT]);
    translate([TRAY_LENGTH-GLASS_DIAMETER/2-WALL, GLASS_DIAMETER/2+WALL, 0])
    difference() {
        translate([-GLASS_DIAMETER/2, -GLASS_DIAMETER/2, 0])
        cube([GLASS_DIAMETER, GLASS_DIAMETER, TRAY_HEIGHT]);
        cylinder(d=GLASS_DIAMETER, h=TRAY_HEIGHT+ATOM);
    }

    // separator
    translate([TRAY_LENGTH-GLASS_DIAMETER-WALL*2, WALL, 0])
    cube([WALL, TRAY_WIDTH-WALL*2, TRAY_HEIGHT]);
    
    // semi-separator
    translate([0, POS, 0])
    cube([TRAY_LENGTH-GLASS_DIAMETER-WALL, WALL, WALL*2]);

    // foot
    w = 10;
    translate([0, TRAY_WIDTH-w, -4.5-SP])
    cube([TRAY_LENGTH, w, 4.5+SP + VSKIN], !true);

    // phone
    %translate([WALL, WALL, WALL])
    cube([170, 90, 16]);
}

module mouse_ear() {
    r = TRAY_HEIGHT*2;
    h = .3;
    h2 = 5;

    difference() {
        h = .5  -.2;
        cylinder(r=r, h);

        translate([0, 0, .3])
        cylinder(r=r-14, h);
    }

    if (0)
    for (a=[0, -90])
    rotate([0, 0, a])
    translate([-TRAY_HEIGHT/2-1, 0, 0]) {
        hull() {
            for(y=[-r+WALL*2.5, r-WALL*2.5])
                translate([-WALL*2, y, 0])
                cylinder(r=WALL, h=1);
            
            translate([-WALL*2, (a==0?1:-1)*13.5, 0])
            cylinder(r=WALL, h=10);
        }
    }
}

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
        if (!$preview) {
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
    translate([w/2, w/2,0])
    rotate([0, 0, -angle])
    translate([-w/2*0 -SP, -w/2,0])
    translate([0, w+1, 0]) {
        hull() {
            cube([w, FLAP_WIDTH*.75 - w-1, TRAY_LENGTH]);
            translate([0, FLAP_WIDTH, 0])
            cube([1.5, ATOM, TRAY_LENGTH]);
        }
    }
}

module all() {
    rotate([0, -90, 0]) tray();
    translate([SP, 2, 0]) hinge();
}



all();

// mouse ears
union() {
    translate([-TRAY_HEIGHT/2 +2.5, TRAY_WIDTH - TRAY_HEIGHT/4 -6, 0]) {
        mouse_ear();
        scale([-1, 1, 1]) mouse_ear();
    }

    translate([-TRAY_HEIGHT/2 +2.5, + TRAY_HEIGHT/4 +6, 0])
    scale([1, -1, 1]) mouse_ear();


    translate([FLAP_WIDTH -2, + TRAY_HEIGHT/4 +6, 0])
    scale([-1, -1, 1]) mouse_ear();

}