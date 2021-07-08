$fn = 12*5;

ATOM = 0.01;
PLAY = 1;
TOLERANCE = 0.3;
AXIS_DIAMETER = 16;
SPOOL_INNER_DIAMETER = 73-TOLERANCE;
SPOOL_BORDER_DIAMETER = 90+6;
SPOOL_BORDER_THICKNESS = 6;
SPOOL_WIDTH = 65;
SPOOL_WIDTH_EXCESS = 20;

CAP_THICKNESS = 12;
CAP_RELIEF = 3;
LOCK_HEAD_DIAMETER = 4;
WALL = 2;

SPOOL_TOTAL_WIDTH = SPOOL_BORDER_THICKNESS * 2 + SPOOL_WIDTH + SPOOL_WIDTH_EXCESS;
AXIS_HOLE_DIAMETER = AXIS_DIAMETER + PLAY;

module hollowing() {
    difference() {
        cylinder(d=SPOOL_INNER_DIAMETER - WALL*2, h=SPOOL_TOTAL_WIDTH);

        cylinder(d=AXIS_HOLE_DIAMETER + WALL*2, h=SPOOL_TOTAL_WIDTH);
        n = 4;
        for (i=[0:n-1]) {
            rotate([0, 0, 360/n * i])
            translate([-SPOOL_INNER_DIAMETER/2, -WALL/2])
            cube([SPOOL_INNER_DIAMETER, WALL, SPOOL_TOTAL_WIDTH]);
        }
    }
}

module hollowing_locks() {
    step = 1;
    //from = SPOOL_TOTAL_WIDTH/2;
    from = SPOOL_WIDTH + SPOOL_BORDER_THICKNESS;
    for (h=[from: step: SPOOL_TOTAL_WIDTH]) {
        for (i=[0:2]) {
            translate([0, 0, h])
            rotate([90, 0, i*120 + h*12])
            translate([0, 0, SPOOL_INNER_DIAMETER/2-LOCK_HEAD_DIAMETER/3])
            cylinder(d=LOCK_HEAD_DIAMETER, h=WALL);
        }

        for (i=[0:2]) {
            hull() {
                translate([0, 0, h])
                rotate([90, 0, i*120 + h*12])
                translate([0, 0, SPOOL_INNER_DIAMETER/2+LOCK_HEAD_DIAMETER/3])
                sphere(d=LOCK_HEAD_DIAMETER);

                hh = h+1;
                translate([0, 0, hh])
                rotate([90, 0, i*120 + hh*12])
                translate([0, 0, SPOOL_INNER_DIAMETER/2+LOCK_HEAD_DIAMETER/3])
                sphere(d=LOCK_HEAD_DIAMETER);
            }
        }

    }
}

module holder() {
    difference() {
        union() {
            cylinder(d=SPOOL_BORDER_DIAMETER, h=SPOOL_BORDER_THICKNESS);
            cylinder(d=SPOOL_INNER_DIAMETER, h=SPOOL_TOTAL_WIDTH);
        }

        union() {
            cylinder(d=AXIS_HOLE_DIAMETER, h=SPOOL_TOTAL_WIDTH);
            hollowing();
            hollowing_locks();
        }
    }
}

module cap() {
    th = SPOOL_BORDER_DIAMETER - (SPOOL_INNER_DIAMETER+TOLERANCE);

    k = 3;
    // outer ring
    difference() {
        cylinder(d=SPOOL_BORDER_DIAMETER+CAP_RELIEF, h=CAP_THICKNESS);    
        cylinder(d=SPOOL_INNER_DIAMETER+th/2, h=CAP_THICKNESS);
        for (i=[0:12:360]) {
            rotate([0, 0, i])
            translate([SPOOL_BORDER_DIAMETER/2 + CAP_RELIEF/k, 0, 0])
            scale([1/k, 1, 1])
            cylinder(d=CAP_RELIEF*k, h=CAP_THICKNESS);
        }
    }

    // fill rings gap
    for (i=[0:2])
        for (j=[20:5:60])
            rotate([0, 0, 120*i + j ])
            translate([SPOOL_INNER_DIAMETER/2 + TOLERANCE, -CAP_THICKNESS/2, 0])
            cube([th/3, CAP_THICKNESS, CAP_THICKNESS]);

    //  inner ring
    difference() {
        cylinder(d=SPOOL_BORDER_DIAMETER-th/2-LOCK_HEAD_DIAMETER, h=CAP_THICKNESS);    
        cylinder(d=SPOOL_INNER_DIAMETER+TOLERANCE, h=CAP_THICKNESS);
        
        // radial cuts
        for (i=[0:2])
            rotate([0, 0, 120*i + 8])
            translate([0, -.5, 0])
            cube([SPOOL_INNER_DIAMETER, 1, CAP_THICKNESS]);
    }

    // locking balls
    for (i=[0:2]) {
        rotate([0, 0, 120*i])
        translate([SPOOL_INNER_DIAMETER/2, 0, CAP_THICKNESS/2])
        sphere(d=LOCK_HEAD_DIAMETER);
    }

}

//translate([-SPOOL_BORDER_DIAMETER, SPOOL_BORDER_DIAMETER, 0]) 
holder();

//cap();

%translate([0, 0, SPOOL_BORDER_THICKNESS])
cylinder(d=SPOOL_BORDER_DIAMETER+30, h=SPOOL_WIDTH);
