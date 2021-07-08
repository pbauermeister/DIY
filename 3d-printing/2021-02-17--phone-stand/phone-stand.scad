$fn = 72;
ATOM = 0.01;

//LENGTH_RAW   = 163;
LENGTH_RAW    =  79-2;
THICKNESS_RAW = 14;

HEIGHT     =  35;
WALL       =   3       -1;
TAB_EXTEND =  45;
ANGLE_1    =  40;
ANGLE_2    =  15;
ANGLE_0    =  45-10;

// computed from raw sizes, plus margins
LENGTH     = LENGTH_RAW +4;
THICKNESS  =  THICKNESS_RAW +2;


module core() {
    difference() {
        // rounded sides
        union() {
            translate([THICKNESS/2, THICKNESS/2+WALL, 0])
            difference() {
                cylinder (d=THICKNESS+WALL+ATOM, h=HEIGHT);
                translate([0, 0, -ATOM])
                cylinder(d=THICKNESS+WALL-ATOM, h=HEIGHT+ATOM*2);
            }

            translate([-THICKNESS/2 + LENGTH, THICKNESS/2+WALL, 0])
            difference() {
                cylinder(d=THICKNESS+WALL+ATOM, h=HEIGHT);
                translate([0, 0, -ATOM])
                cylinder(d=THICKNESS+WALL-ATOM, h=HEIGHT+ATOM*2);
            }
        }

        // phone body clearance
        translate([THICKNESS/2, 0, 0])
        cube([LENGTH-THICKNESS, THICKNESS*2, HEIGHT]);
        
        translate([THICKNESS/2, THICKNESS/2+WALL, 0])
        rotate([0, 0, ANGLE_0])
        cube([THICKNESS, THICKNESS, HEIGHT]);

        translate([-THICKNESS/2 + LENGTH, THICKNESS/2+WALL, 0])
        rotate([0, 0, -ANGLE_0])
        translate([-THICKNESS, 0, 0])
        cube([THICKNESS, THICKNESS, HEIGHT]);

        hull() {
            d = THICKNESS*.75;
            translate([LENGTH/2, THICKNESS/2+WALL, THICKNESS*.55])
            rotate([0, 90, 0])
            cylinder(d=d, h=LENGTH*2, center=true);
            translate([LENGTH/2, THICKNESS/2+WALL, HEIGHT-THICKNESS*.55])
            rotate([0, 90, 0])
            cylinder(d=d, h=LENGTH*2, center=true);
        }
    }
    // wall
    translate([THICKNESS/2, WALL/2 - ATOM/2, 0])
    cube([LENGTH-THICKNESS, ATOM, HEIGHT]);   

    //ends
    d = 2;
    r = THICKNESS/2 + (WALL+d*0)/2;
    x = sin(ANGLE_0) * r;
    y = cos(ANGLE_0) * r;
    translate([THICKNESS/2-x, THICKNESS/2+WALL+y, 0])
    cylinder(d=d, h=HEIGHT);

    translate([-THICKNESS/2 + LENGTH + x, THICKNESS/2+WALL +y, 0])
    cylinder(d=d, h=HEIGHT);
}

module tab() {
    translate([0, WALL/2, 0])
    difference() {
        // tab
        rotate([-45, 0, 0])
        difference() {
            tab_height = HEIGHT/4;
            translate([0, -TAB_EXTEND, 0])
            cube([LENGTH, TAB_EXTEND, tab_height]);

            a0 = atan(tab_height/TAB_EXTEND);
            translate([0, 0, tab_height])
            rotate([a0, 0, 0])
            translate([0, -TAB_EXTEND*2, 0])
            cube([LENGTH, TAB_EXTEND*2, HEIGHT]);
        }

        // small chamfer
        d1 = sin(ANGLE_1) * THICKNESS/2;
        translate([d1*2, 0, 0])
        rotate([0, 0, 180+ANGLE_1])
        translate([0, -THICKNESS/2, 0])
        cube([TAB_EXTEND, TAB_EXTEND*2, TAB_EXTEND]);

        // big chamfer
        d2 = sin(ANGLE_2) * THICKNESS/2;
        translate([-d2*2, 0, 0])
        translate([LENGTH, 0, 0])
        rotate([0, 0, 180-ANGLE_2])
        translate([0, -THICKNESS/2, 0])
        translate([-LENGTH, -LENGTH/2, 0])
        cube([LENGTH, LENGTH*2, TAB_EXTEND]);

        // cleanup
        cube([LENGTH, HEIGHT, HEIGHT]);
    }
}

module all() {
    core();
    tab();
}

minkowski() {
    all();
    sphere(d=WALL, $fn=8);
}
