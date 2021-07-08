$fn = 90;
ATOM = 0.01;
PLAY = 1;
TOLERANCE = 0.3;
LAYER = 0.15;

AXIS_DIAMETER = 16;
SPOOL_INNER_DIAMETER = 53.5-TOLERANCE;
SPOOL_BORDER_THICKNESS = 6;
//OOL_WIDTH = 65 -1;
SPOOL_WIDTH = 60 - .8;
SPOOL_WIDTH_EXCESS = 20;

CAP_THICKNESS = 12;
CAP_RELIEF = 3;
WALL0 = 2 -.5;
WALL1 = 1.5 -.5;
WALL2 = 2 -.5;

SPOKES = 3;
EXCESS = 1.8;
BALLS_CUT_HEIGHT = 20;
BALLS_CUT_WIDTH = 6;
BALLS_CUT_MARGIN = 4;
BALLS_CUT_ANGLE = 7;
BALLS_CUT_THICKNESS = 0.5;

ADAPTOR_WIDTH = SPOOL_WIDTH; // + EXCESS * 2;

AXIS_HOLE_DIAMETER = AXIS_DIAMETER + PLAY;

module hollowing() {
    border = 10;
    difference() {
        cylinder(d=SPOOL_INNER_DIAMETER - WALL1*2, h=ADAPTOR_WIDTH);

        cylinder(d=AXIS_HOLE_DIAMETER + WALL0*2, h=ADAPTOR_WIDTH);
        n = SPOKES;

        for (i=[0:n-1]) {
            rotate([0, 0, 360/n * i])
            translate([0, -WALL2/2])
            cube([SPOOL_INNER_DIAMETER, WALL2, ADAPTOR_WIDTH]);
        }
    }
}

module balls() {
    for (i=[0:SPOKES-1]) {
        rotate([0, 0, 360/SPOKES*i + 360/SPOKES/2])
        translate([SPOOL_INNER_DIAMETER/2, 0, 0])
        rotate([90, 0, 0])
        cylinder(d=EXCESS, h=EXCESS*1.5,center=true);
    }
}

module balls_cut() {
    for (i=[0:SPOKES-1]) {
        rotate([0, 0, 360/SPOKES*i + 360/SPOKES/2]) {

            translate([SPOOL_INNER_DIAMETER/2 - WALL1*1.5, -BALLS_CUT_WIDTH/2, +BALLS_CUT_MARGIN])
            rotate([BALLS_CUT_ANGLE, 0, 0])
            translate([0, -BALLS_CUT_THICKNESS/2, 0])
            cube([WALL1*2, BALLS_CUT_THICKNESS, BALLS_CUT_HEIGHT]);

            translate([SPOOL_INNER_DIAMETER/2 - WALL1*1.5, +BALLS_CUT_WIDTH/2, +BALLS_CUT_MARGIN])
            rotate([-BALLS_CUT_ANGLE, 0, 0])
            translate([0, -BALLS_CUT_THICKNESS/2, 0])
            cube([WALL1*2, BALLS_CUT_THICKNESS, BALLS_CUT_HEIGHT]);
            
            translate([SPOOL_INNER_DIAMETER/2 - WALL1*1.5, -BALLS_CUT_WIDTH/2, +BALLS_CUT_MARGIN-LAYER/3])
            cube([WALL1*2, BALLS_CUT_WIDTH, LAYER]);
        }
    }

}

module holder() {
    difference() {
        union() {
            cylinder(d=SPOOL_INNER_DIAMETER, h=ADAPTOR_WIDTH);
            cylinder(d=SPOOL_INNER_DIAMETER+4, h=2);

//          balls();

            translate([0, 0, ADAPTOR_WIDTH-EXCESS*.60]) balls();
        }
        translate([0, 0, -ATOM]) scale([1, 1, (ADAPTOR_WIDTH+ATOM*2)/ADAPTOR_WIDTH])
        union() {
            cylinder(d=AXIS_HOLE_DIAMETER, h=ADAPTOR_WIDTH);
            hollowing();
        }
/*        
        balls_cut();

        translate([0, 0, ADAPTOR_WIDTH])
        scale([1, 1, -1])
        balls_cut();
*/
    }
}

intersection() {
    holder();
//    translate([0, 0, 6])    cylinder(r=SPOOL_INNER_DIAMETER, h=7);
}