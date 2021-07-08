$fn = 72;
ATOM = 0.01;

//LENGTH_RAW   = 163;
LENGTH_RAW    =  79-2 -1 +.5    -.5;
THICKNESS_RAW = 14       +.5    -.5;

HEIGHT     =  35;
WALL       =   1                +.9;
TAB_EXTEND =  50;
ANGLE_1    =  40;
ANGLE_2    =  15         +  3   + 2;  // smaller diagonal
ANGLE_0    =  45-10*2.5  + 15;        // bigger diagonal

// computed from raw sizes, plus margins
LENGTH     = LENGTH_RAW +4;
THICKNESS  =  THICKNESS_RAW +2;

SLIT = 0.5;

module block(d) {
    hull() {
        translate([-WALL/2-d/2, WALL/2-d/2, 0])
        cube([LENGTH+WALL+d, THICKNESS/2+WALL/2+d, HEIGHT]);

        translate([-WALL/2+THICKNESS/2+WALL/4-d/2,
                   WALL/2+THICKNESS/2+WALL/4-d/2,
                   0])
        cylinder (d=THICKNESS+WALL/2+d, h=HEIGHT);

        translate([-WALL/2+THICKNESS/2+WALL/4+d/2 + LENGTH-THICKNESS+WALL/2,
                   WALL/2+THICKNESS/2+WALL/4-d/2,
                   0])
        cylinder (d=THICKNESS+WALL/2+d, h=HEIGHT);
    }
}

module core() {
    difference() {
        union() {
            block(ATOM/2);
            tab();
        }
        block(-ATOM/2);

        r = THICKNESS/2;// + (WALL)/2;
        x = sin(ANGLE_0) * r;
        y = cos(ANGLE_0) * r;
        
        translate([-WALL/2 +THICKNESS/2 - x,
                   WALL, 0])

        cube([LENGTH+WALL -THICKNESS+x*2,
               THICKNESS*2, HEIGHT]);

        // side holes
        hull() {
            d = THICKNESS*.75;
            translate([LENGTH/2, THICKNESS/2+WALL, THICKNESS*.65])
            rotate([0, 90, 0])
            cylinder(d=d, h=LENGTH*2, center=true);
            translate([LENGTH/2, THICKNESS/2+WALL, HEIGHT-THICKNESS*.65])
            rotate([0, 90, 0])
            cylinder(d=d, h=LENGTH*2, center=true);
        }
    }

    //ends
    d = 2;
    r = THICKNESS/2 + (WALL)/2*0;
    x = sin(ANGLE_0) * r;
    y = cos(ANGLE_0) * r;

    translate([-WALL/2+THICKNESS/2-x, THICKNESS/2+WALL+y, 0])
    rotate([0, 0, 22]) scale([0.5, 1, 1])
    cylinder(d=d, h=HEIGHT);

    translate([WALL/2-THICKNESS/2 + LENGTH + x, THICKNESS/2+WALL +y, 0])
    rotate([0, 0, -22]) scale([0.5, 1, 1])
    cylinder(d=d, h=HEIGHT);
}

module tab() {
    translate([0, WALL/2, 0])
    difference() {
        // tab
        rotate([-40, 0, 0])
        difference() {
            tab_height = HEIGHT/4;
            translate([-WALL/2, -TAB_EXTEND, 0])
            cube([LENGTH+WALL, TAB_EXTEND, tab_height]);

            a0 = atan(tab_height/TAB_EXTEND);
            translate([0, 0, tab_height])
            rotate([a0, 0, 0])
            translate([-WALL/2, -TAB_EXTEND*2, 0])
            cube([LENGTH+WALL, TAB_EXTEND*2, HEIGHT]);
        }

        d = THICKNESS /4;
        // small chamfer
        translate([-WALL/2, 0, 0])
        rotate([0, 0, 180+ANGLE_1])
        translate([0, -THICKNESS/2, 0])
        cube([TAB_EXTEND, TAB_EXTEND*2, TAB_EXTEND]);

        // big chamfer
        translate([LENGTH+WALL/2, 0, 0])
        rotate([0, 0, 180-ANGLE_2])
        translate([0, -THICKNESS/2, 0])
        translate([-LENGTH, -LENGTH/2, 0])
        cube([LENGTH, LENGTH*2, TAB_EXTEND]);

        // cleanup
        cube([LENGTH, HEIGHT, HEIGHT]);
    }
}

module slit() {
    // slit
    translate([LENGTH/2, -TAB_EXTEND/2,-HEIGHT])
    cylinder(r=SLIT*2, h=HEIGHT*3);
    translate([LENGTH/2-SLIT/2, -TAB_EXTEND/2, -HEIGHT])
    cube([SLIT, TAB_EXTEND, HEIGHT*3]);
}

module all() {
    difference() {
        minkowski() {
            core();
            sphere(d=WALL, $fn=6);
        }
        slit();
    }
}

intersection() {
    all();
//    cube([200, 200, 8], center=true);
}
