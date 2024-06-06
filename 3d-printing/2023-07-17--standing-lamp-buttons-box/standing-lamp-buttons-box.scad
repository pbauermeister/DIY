/* Buttons box for standing lamp */

BAR_DIAMETER           = 13.2;
BAR_DIAMETER2          = BAR_DIAMETER + 1;

STRUT_HEIGHT           = 10 + 7;
STRUT_WIDTH            = 15 + 3;

HOLE_DIAMETER          =  8;


SWITCH_KNOB_DIAMETER   =  7;
SWITCH_KNOB_HEIGHT     =  7;
SWITCH_THREAD_DIAMETER = 12;
SWITCH_THREAD_HEIGHT   = 12;
SWITCH_CASE_WIDTH      =  7;
SWITCH_CASE_LENGTH     = 13;
SWITCH_CASE_HEIGHT     = 16;
SWITCH_NUT_DIAMETER    = 14; //18.5;


SCREW_THREAD_DIAMETER_OUTER = 3;
SCREW_THREAD_DIAMETER_INNER = 2;
SCREW_HEAD_DIAMETER    = 8;

SWITCH_DISTANCE        =  5;
BAR_DISTANCE           = 35;
HOLE_STRUT_DISTANCE    = 10;
HOLE_CASE_DISTANCE     = 5;
SWITCH_STRUT_DISTANCE  = 10 +5;

WALL_THICKNESS         = 3; //5 +2;
ROUNDING               = 2;

PILLAR1_WIDTH          =  8 -2;
PILLAR1_HEIGHT         = 22;
PILLAR1_POS            = STRUT_HEIGHT+PILLAR1_HEIGHT/2 + 1;

PILLAR2_WIDTH          =  20 -5;
PILLAR2_HEIGHT         = SWITCH_STRUT_DISTANCE -2 + 15;
PILLAR2_POS            = -PILLAR2_HEIGHT/2 - 1;

TOLERANCE = .2;
ATOM      = .01;
$fn       = $preview ? 36 : 90;

////////////////////////////////////////////////////////////////////////////////

module threadable_hole(d, h, k) {
    cylinder(d=2, h=h, $fn=24);

    w = d * 2.5 * k;
    l = .15;
    intersection() {
        union() {
            for (a=[0:45/2:360]) {
                rotate([0, 0, a])
                translate([0, -l/2, 0])
                cube([w, l, h]);
            }
        }
        if (!$preview) cube([w, w, h*3], center=true);
    }
}

////////////////////////////////////////////////////////////////////////////////

module switch(extra=0) {
    translate([0, 0, SWITCH_CASE_HEIGHT+SWITCH_THREAD_HEIGHT/2*0 + .1])
    cylinder(d=SWITCH_NUT_DIAMETER, h=2);

    translate([0, 0, SWITCH_CASE_HEIGHT+SWITCH_THREAD_HEIGHT])
    cylinder(d=SWITCH_KNOB_DIAMETER, h=SWITCH_KNOB_HEIGHT);

    translate([0, 0, SWITCH_CASE_HEIGHT])
    cylinder(d=SWITCH_THREAD_DIAMETER+extra, h=SWITCH_THREAD_HEIGHT);
    
    translate([-SWITCH_CASE_WIDTH/2, -SWITCH_CASE_LENGTH/2, 0])
    cube([SWITCH_CASE_WIDTH, SWITCH_CASE_LENGTH, SWITCH_CASE_HEIGHT]);
}

////////////////////////////////////////////////////////////////////////////////

module cable_hole() {
    translate([0, 0, -HOLE_DIAMETER/2 - HOLE_STRUT_DISTANCE])
    rotate([0, 90, 0])
    cylinder(d=HOLE_DIAMETER, h=BAR_DISTANCE+BAR_DIAMETER, center=true);
}

module lamp_foot(extra=0) {
    difference() {
        for(i=[-1, 1]) {
            x = (BAR_DISTANCE/2+BAR_DIAMETER/2) * i;
            translate([x, 0, -500/2]) {
                cylinder(d=BAR_DIAMETER+extra, h=500);
                if (i==-1)
                    translate([0, 0, 250 + STRUT_HEIGHT+SWITCH_STRUT_DISTANCE])
                    cylinder(d=BAR_DIAMETER2+extra, h=500);
            }
        }
        %cable_hole();
    }

    translate([0, 0, STRUT_HEIGHT/2]) {
        difference() {
            cube([BAR_DISTANCE, STRUT_WIDTH, STRUT_HEIGHT], center=true);
            if (0) {
                translate([0, 2, ])
                cube([BAR_DISTANCE-4, STRUT_WIDTH, STRUT_HEIGHT+1], center=true);
            }
        }
    }

    %cable_hole();

    for (i=[-1, 1]) {
        x = ((BAR_DISTANCE-BAR_DIAMETER*2)/3/2 + BAR_DIAMETER/2) * i;
        translate([x, 0, 0])
        translate([0, 0, STRUT_HEIGHT+SWITCH_STRUT_DISTANCE])
        switch(extra=extra);
    }

}

////////////////////////////////////////////////////////////////////////////////

BOX_L  = BAR_DISTANCE + 2*BAR_DIAMETER + 2 * TOLERANCE - WALL_THICKNESS*2
         - BAR_DIAMETER*2;
BOX_W  = max(BAR_DIAMETER, SWITCH_NUT_DIAMETER, STRUT_WIDTH) + 2*TOLERANCE
         + WALL_THICKNESS*1.5;
BOX_LH = HOLE_CASE_DISTANCE + HOLE_DIAMETER + HOLE_STRUT_DISTANCE;
BOX_H  = BOX_LH + STRUT_HEIGHT + SWITCH_STRUT_DISTANCE + SWITCH_CASE_HEIGHT
         + TOLERANCE + SWITCH_THREAD_HEIGHT -2 - WALL_THICKNESS;


module inner_shape() {
    translate([0, 0, -BOX_LH]) {
        intersection() {
            resize([BOX_L*1.75, BOX_W, BOX_H])
            cylinder(d=BOX_L, h=BOX_H, $fn=90);
            translate([0, 0, BOX_H/2])
            cube([BAR_DISTANCE+BAR_DIAMETER, BOX_W, BOX_H], center=true);
        }
    }
}

module box_inner(with_pillars=false) {
    difference() {
        inner_shape();

        if (with_pillars) {
            translate([0, 0, PILLAR1_POS])
            cube([PILLAR1_WIDTH, 1000, PILLAR1_HEIGHT], center=true);

            translate([0, 0, PILLAR2_POS])
            cube([PILLAR2_WIDTH, 1000, PILLAR2_HEIGHT], center=true);
        }    
    }    
}

module box_outer() {
    minkowski() {
        minkowski() {
            box_inner();
            cube((WALL_THICKNESS-ROUNDING)*2, center=true);
        }
        sphere(r=ROUNDING);
    }
}

module box() {
    difference() {
        box_outer();
        lamp_foot(TOLERANCE*3);
        box_inner(with_pillars=true);
        screw_hollowings();
    }
}

module partitioner(extra=0) {
    s = 200;

    difference() {
        translate([-s/2, -s, -s/2])
        cube(s);

        excess = 0;
        w = s*2; //BAR_DISTANCE-4+extra*2;
        y = s/2 + BOX_H - BOX_LH -excess;
        translate([0, 0, y -extra])
        cube([w, SWITCH_THREAD_DIAMETER+25, s], center=true);
    }
}

module back_part() {
    intersection() {
        box();
        partitioner(TOLERANCE*2);
    }    
}

module front_part() {
    difference() {
        box();
        partitioner();
    }    
}

////////////////////////////////////////////////////////////////////////////////

module screw_hollowing() {
    cylinder(d=SCREW_THREAD_DIAMETER_OUTER, h=BAR_DIAMETER*3);

    d = BOX_W/2; // BAR_DIAMETER
    translate([0, 0, d+WALL_THICKNESS/2])
    cylinder(d=SCREW_HEAD_DIAMETER, h=BAR_DIAMETER*3);

    h = BAR_DIAMETER * .75;
    translate([0, 0, -h+ATOM])
    threadable_hole(SCREW_THREAD_DIAMETER_OUTER, h, .8);
}

module screw_hollowings() {
    translate([0, 0, PILLAR1_POS])
    rotate([90, 0, 0]) screw_hollowing();
    translate([0, 0, PILLAR2_POS])
    rotate([90, 0, 0]) screw_hollowing();
}

////////////////////////////////////////////////////////////////////////////////

module all() {
    translate([0, -18, 0])
    back_part();

    translate([0,  18, 0])
    front_part();
}

if (1) {
    all();
    translate([0, 18, 0])

    %lamp_foot();
} else if(0) {
    screw_hollowings();
} else if (0) {
    lamp_foot();
    %box_inner();
} else if (0){
    difference() {
        box();
        translate([-500, -1000, -500])
        cube(1000);
    }
} else if (0) {
    back_part();
    lamp_foot();
} else if (0) {
    difference() {
        front_part();
        cylinder(d=200, h=100, center=true);
    }
} else if (0) {
    box_inner();
    %inner_shape();
    %lamp_foot();
} else {
%     box();
    partitioner();
}
