
RAIL_LENGTH             =  90.0;
RAIL_GROOVE_HEIGHT      =   3.0;
RAIL_WIDTH              =  18.5;
RAIL_WALL_THICKNESS     =   2.5;
RAIL_OUTER_WIDTH        = RAIL_WIDTH + RAIL_WALL_THICKNESS*2;
RAIL_INNER_HEIGHT       =   6.5  +.5;
RAIL_HEIGHT             =  10.0  +.5;
RAIL_ROUNDING           =   3.0;
RAIL_GRIP_DIAMETER      =   6.0;

CYLINDER_DIAMETER       =  30.0;
CYLINDER_WALL_THICKNESS =   2.0;
CYLINDER_LENGTH         = 150.0;
BAR_HEIGHT              =   5.0;
BAR_WIDTH               =   8.0;

ATOM = 0.01;

module rail_hull() {
    $fn = $preview ? 8 : 30;
    hull() {
        for (x=[RAIL_ROUNDING/2, RAIL_LENGTH-RAIL_ROUNDING/2]) {
            for (y=[-1, 1]) {
                translate([x, y*(RAIL_OUTER_WIDTH/2-RAIL_ROUNDING/2), 0])
                sphere(d=RAIL_ROUNDING);
                translate([x, y*(RAIL_OUTER_WIDTH/2-RAIL_ROUNDING/2), RAIL_HEIGHT-RAIL_ROUNDING/2])
                sphere(d=RAIL_ROUNDING);
            }
        }
    }
}

module rail_gripper_cutout() {
    n = floor(RAIL_LENGTH/RAIL_GRIP_DIAMETER);
    sx = (RAIL_GRIP_DIAMETER-1)/RAIL_GRIP_DIAMETER;
    d = RAIL_GROOVE_HEIGHT/2;
    sy = d/RAIL_GRIP_DIAMETER;
    
    for (i=[0:n-1]) {
        for (y=[-RAIL_OUTER_WIDTH/2, RAIL_OUTER_WIDTH/2]) {
            translate([(i+.5)*(RAIL_LENGTH/n), y, -ATOM])
            scale([sx, sy, 1])
            cylinder(d=RAIL_GRIP_DIAMETER, RAIL_HEIGHT+ATOM*2, $fn=12);
        }
    }
}

module rail0() {
    difference() {
        translate([0, -RAIL_OUTER_WIDTH/2, 0])
        cube([RAIL_LENGTH, RAIL_OUTER_WIDTH, RAIL_HEIGHT]);

        // hollowing
        translate([-ATOM, -RAIL_WIDTH/2, -ATOM])
        cube([RAIL_LENGTH+ATOM*2, RAIL_WIDTH, RAIL_INNER_HEIGHT+ATOM]);

        // slightly thicker central hollowing
        w = RAIL_WIDTH + 1;
        translate([-ATOM + RAIL_LENGTH/4, -w/2, -ATOM])
        cube([RAIL_LENGTH/2, w, RAIL_INNER_HEIGHT+ATOM]);

        rail_gripper_cutout();
    }
}

module rail_front() {
    // makes a 45° nose, to avoid supports 
    hull() {
        t = 2;
        w = RAIL_WIDTH + RAIL_ROUNDING*.9;
        translate([RAIL_LENGTH-t, -w/2, 0])
        cube([t, w, RAIL_HEIGHT]);

        d = RAIL_HEIGHT+BAR_HEIGHT;
        translate([RAIL_LENGTH, -BAR_WIDTH/2, RAIL_HEIGHT+BAR_HEIGHT +1])
        cube([d, BAR_WIDTH, 1]);
    }
}

module rail1() {
    intersection() {
        rail0();
        rail_hull();
    }
    
    rail_front();
}

module tab(thick, scale_y, scale_z, fn) {
    d = RAIL_GROOVE_HEIGHT;
    scale([1, scale_y, scale_z])
    hull() {
        translate([thick ? -d : 0, 0, 0]) sphere(d=d, $fn=fn);
        translate([thick ? +d : 0, 0, 0]) sphere(d=d, $fn=fn);
    }
}

module tabs() {
    n = 4;
    
    // side tabs
    for (i=[0, n-2]) {
        x = (i+.5) / (n-1) * RAIL_LENGTH;
        for (y=[-RAIL_WIDTH/2, RAIL_WIDTH/2])
            translate([x, y, RAIL_GROOVE_HEIGHT/2])
            tab(true, 1, 1.5, 6);
    }

    // central tabs
    if (0) for (i=[0:n-2]) {
        x = (i+.5) / (n-1) * RAIL_LENGTH;
            translate([x, 0, RAIL_INNER_HEIGHT])
            tab(false, 2, 1, 12);
    }
}

module spacer() {
    // spacer between rail and scope
    translate([0, -BAR_WIDTH/2, RAIL_HEIGHT-RAIL_ROUNDING])
    cube([RAIL_LENGTH, BAR_WIDTH, BAR_HEIGHT+CYLINDER_WALL_THICKNESS+RAIL_ROUNDING]);
}

module rail() {
    rail1();
    tabs();
    spacer();
}

module crosshair() {
    rotate([0, 90, 0]) {
        th = .2;
        l = CYLINDER_DIAMETER/2;
        translate([-th/2, -CYLINDER_DIAMETER/2, CYLINDER_LENGTH-l -.3])
        cube([th, CYLINDER_DIAMETER, l]);

        translate([-CYLINDER_DIAMETER/2, -th/2, CYLINDER_LENGTH-l -.4])
        cube([CYLINDER_DIAMETER, th, l]);
    }
}

module scope0() {
    $fn = 60;
    rotate([0, 90, 0]) {
        difference() {
            // scope body
            cylinder(d=CYLINDER_DIAMETER, h=CYLINDER_LENGTH);

            // scope hole
            translate([0, 0, -ATOM])
            cylinder(d=CYLINDER_DIAMETER-CYLINDER_WALL_THICKNESS*2, h=CYLINDER_LENGTH+ATOM*2);

            // mid-top rounded cut-off
            hull() {
                translate([-CYLINDER_DIAMETER/2, 0, 0])
                rotate([90, 0, 0])
                cylinder(d=CYLINDER_DIAMETER, CYLINDER_DIAMETER*2, center=true);
                
                translate([-CYLINDER_DIAMETER, 0, CYLINDER_LENGTH/3])
                rotate([90, 0, 0])
                cylinder(d=CYLINDER_DIAMETER*2, CYLINDER_DIAMETER*2, center=true);
            }
        }
    }
    crosshair();
}

module scope() {
    translate([0, 0, RAIL_HEIGHT+CYLINDER_DIAMETER/2 + BAR_HEIGHT]) {
        $fn = 60;
        intersection() {
            scope0();

            // rear rounding
            union() {
                d = CYLINDER_DIAMETER - CYLINDER_WALL_THICKNESS*2;
                //translate([0, 0, CYLINDER_WALL_THICKNESS])
                hull() {
                    translate([d/2, 0, -d/2])
                    rotate([90, 0, 0])
                    cylinder(d=d, CYLINDER_DIAMETER*2, center=true);

                    translate([d/2, 0, -d])
                    rotate([90, 0, 0])
                    cylinder(d=d, CYLINDER_DIAMETER*2, center=true);

                    translate([d, 0, -d/2])
                    rotate([90, 0, 0])
                    cylinder(d=d, CYLINDER_DIAMETER*2, center=true);
                }
                translate([d, 0, 0])
                rotate([90, 0, 90])
                cylinder(d=CYLINDER_DIAMETER, CYLINDER_LENGTH);
            }
        }
    }
}

module all() {
    scope();
    rail();
}

intersection() {
    //translate([0, 0, -75]) cylinder(d=150, h=10, center=true);
    rotate([0, 90, 0])
    all();
}