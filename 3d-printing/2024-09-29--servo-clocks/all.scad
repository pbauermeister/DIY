// Lego Geekservo 270°
// https://www.robotshop.com/products/geekservo-9g-270-servo-compatible-with-lego

////////////////////////////////////////////////////////////////////////////////

// SERVO

// - shaft
SERVO_SHAFT_CROSS_WIDTH      =  5.0;
SERVO_SHAFT_CROSS_THICKNESS  =  1.8;
SERVO_SHAFT_HEIGHT           = 34.5;

// - body
SERVO_BODY_WIDTH             =  16;
SERVO_L1_HEIGHT              =  9.5;
SERVO_L2_HEIGHT              =  9.5;
SERVO_L2_LENGTH              = 40;
SERVO_BODY_HEIGHT            = 26.6;
SERVO_BODY_X_SHIFT           =  7;
SERVO_BODY_LENGTH            = 24;
// - misc
SERVO_COLUMN_HEIGH           = 28.9;
SERVO_COLUMN_DIAMETER        = 12;
SERVO_HOLE_DIAMETER          =  4.5;
SERVO_HOLE_Z                 = 15;
SERVO_HOLE_DIST              = 31.5;

// SERVOS POSITIONS
SERVO_UPPER_Z_POS            =  5;

// SERVO HOLDER
SERVO_HOLDER_BORDER          =  4;
SERVO_FIXTURE_ARM_W          = 12 -4;
SERVO_FIXTURE_ARM_D          = 30.6  - 14 - 3;
SERVO_FIXTURE_ARM_H          = 4;

// CUBE
CUBE_WIDTH                   = 60 - 3;
CUBE_WALL                    =  1;
CUBE_HEIGHT                  = 45; 
CUBE_H_GAP                   =  0.25;
DIAMETER_TOLERANCE           = .2;

SUPPORT_PLATE_DIAMETER_LOWER = CUBE_WIDTH - CUBE_WALL*2;
SUPPORT_PLATE_DIAMETER_UPPER = SUPPORT_PLATE_DIAMETER_LOWER - CUBE_WALL*2;

// COMPUTED
UPPER_Z                      = CUBE_HEIGHT + CUBE_H_GAP;

// MISC
TEETH_EXTRA = .1;
TOLERANCE   = 0.13;
ATOM        = 0.02;
$fn         = $preview ? 40 : 60;
FINE_FN     = $preview ? 40 : 360;

function get_cube_width() = CUBE_WIDTH;

////////////////////////////////////////////////////////////////////////////////

module servo_shaft(extra=0, chamfer=0) {
    w = SERVO_SHAFT_CROSS_WIDTH+extra*2;
    l = SERVO_SHAFT_CROSS_THICKNESS+extra*2;
    w2 = SERVO_SHAFT_CROSS_WIDTH+extra*2 + chamfer*2;
    l2 = SERVO_SHAFT_CROSS_THICKNESS+extra*2 + chamfer*2;
    for (a=[0, 90])
        hull()
        rotate([0, 0, a]) {
            translate([-w/2, -l/2, 0])
            cube([w, l, SERVO_SHAFT_HEIGHT]);

            translate([-w2/2, -l2/2, 0])
            cube([w2, l2, SERVO_SHAFT_HEIGHT-chamfer]);
        }
}

module servo_body() {
    // bottom and top
    translate([-SERVO_BODY_X_SHIFT, -SERVO_BODY_WIDTH/2, 0])
    cube([SERVO_BODY_LENGTH, SERVO_BODY_WIDTH, SERVO_BODY_HEIGHT]);

    // middle arms, w/o Lego knobs
    x2 = (SERVO_L2_LENGTH - SERVO_BODY_LENGTH) / 2 + SERVO_BODY_X_SHIFT;
    translate([-x2, -SERVO_BODY_WIDTH/2, SERVO_L1_HEIGHT])
    cube([SERVO_L2_LENGTH, SERVO_BODY_WIDTH, SERVO_L2_HEIGHT]);
    
    // column, w/o secondary cylinder
    cylinder(d=SERVO_COLUMN_DIAMETER, h=SERVO_COLUMN_HEIGH);
}

module servo_holes() {
    d = (SERVO_BODY_LENGTH/2-SERVO_BODY_X_SHIFT);
    for (x=[-SERVO_HOLE_DIST/2, SERVO_HOLE_DIST/2])
        translate([x+d, 0, SERVO_HOLE_Z])
        rotate([90, 0, 0])
        cylinder(d=SERVO_HOLE_DIAMETER, h=SERVO_BODY_WIDTH*1.9, center=true);
}

module servo_support_holes() {
    d = (SERVO_BODY_LENGTH/2-SERVO_BODY_X_SHIFT);
    r = sqrt(pow(SERVO_HOLE_DIST/2, 2) + pow(SERVO_BODY_WIDTH/2, 2)) - SERVO_HOLE_DIAMETER/4;

    translate([d, 0, SERVO_HOLE_Z])
    rotate_extrude(convexity = 10)
    translate([r, 0, 0])
    scale([.5, 1, 1])
    circle(d=SERVO_HOLE_DIAMETER);
}

module servo() {
    color("blue") {
        difference() {
            servo_body();
            servo_holes();
        }
        servo_shaft();
    }
}

module o_ring(section, support_plate_diameter) {
    scale([1, 1, 1.5])
    rotate_extrude(convexity=10, $fn=FINE_FN)
    translate([support_plate_diameter/2 + TOLERANCE, 0, 0])
    circle(r=section);
}

module cube_inner_cylinder(h, support_plate_diameter, tolerance=0) {    
    z = CUBE_WALL*3.25 + TOLERANCE/2;
    difference() {
        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
        cube([CUBE_WIDTH, CUBE_WIDTH, h]);

        cylinder(d=support_plate_diameter,
                 h=h+ATOM, $fn=FINE_FN);

        translate([0, 0, z-h])
        cylinder(d=support_plate_diameter+tolerance*2,
                 h=h+ATOM, $fn=FINE_FN);

    }
    
    // O-ring
    translate([0, 0, z])
    o_ring(CUBE_WALL*.85, support_plate_diameter);
}

module upper_cube_body() {
    cavity_h = CUBE_HEIGHT - CUBE_WALL*1.5;
    // wall
    difference() {
        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
        cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

        translate([-CUBE_WIDTH/2 + CUBE_WALL, -CUBE_WIDTH/2 + CUBE_WALL, -ATOM])
        cube([CUBE_WIDTH - CUBE_WALL*2, CUBE_WIDTH - CUBE_WALL * 2, cavity_h + ATOM]);
    }

    // cube with cavity
    cube_inner_cylinder(CUBE_HEIGHT, SUPPORT_PLATE_DIAMETER_UPPER, DIAMETER_TOLERANCE);
    
    // lip
    d = SUPPORT_PLATE_DIAMETER_UPPER + DIAMETER_TOLERANCE*2;
    h = .2;
    th = .5;
    translate([0, 0, -h])
    difference() {
        cylinder(d=d+th*4, h=h);
        cylinder(d=d+th*2, h=h*3, center=true);
    }
}

module shaft_hollowing(chamfer=0) {
    servo_shaft(extra=TOLERANCE, chamfer=chamfer);
}

module servo_shaft_wrench() {
    l = CUBE_WIDTH*.6;
    w = SERVO_FIXTURE_ARM_W * .75;
    d = SERVO_FIXTURE_ARM_D*.8;
    difference() {
        union() {
            hull() for (y=[0, -l])
                translate([0, y, 0])
                cylinder(d=w, h=SERVO_FIXTURE_ARM_H);
            cylinder(d=d, h=SERVO_FIXTURE_ARM_H);
        }

        translate([0, 0, -ATOM*100])
        shaft_hollowing();
    }
}

module lower_cube_body() {
    difference() {
        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
        cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

        translate([-CUBE_WIDTH/2 + CUBE_WALL, -CUBE_WIDTH/2 + CUBE_WALL, -ATOM])
        cube([CUBE_WIDTH - CUBE_WALL*2, CUBE_WIDTH - CUBE_WALL * 2, CUBE_HEIGHT*2]);

        // shave for tolerance
        z = (CUBE_WALL*3.25 + TOLERANCE/2);
        translate([0, 0, -ATOM])
        cylinder(d=SUPPORT_PLATE_DIAMETER_LOWER+DIAMETER_TOLERANCE*2, h=z);

    }

    cube_inner_cylinder(CUBE_HEIGHT, SUPPORT_PLATE_DIAMETER_LOWER, DIAMETER_TOLERANCE);

    intersection() {
        translate([0, 0, CUBE_HEIGHT])
        o_ring(CUBE_WALL*1.67, SUPPORT_PLATE_DIAMETER_LOWER+CUBE_WALL + DIAMETER_TOLERANCE*2);

        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
        cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);
    }

    // fixture
    lower_servo_fixture_arm();
}

module lower_servo_fixture_arm(dropped=false) {
    // servo shaft fixture - arm
    h = SERVO_FIXTURE_ARM_H;
    extra_h = 1;
    extra_h2 = 4;
    w = SERVO_FIXTURE_ARM_W;
    marg = 5;
    d = SERVO_FIXTURE_ARM_D;
    translate([0, 0, dropped ? 0 : CUBE_HEIGHT-h-marg]) {
        difference() {
            union() {
                translate([0, -w/2, 0])
                cube([CUBE_WIDTH/2-ATOM, w, h+extra_h]);

                translate([-ATOM*2, 0, 0])
                hull() {
                    translate([d/2, -w/2, 0])
                    cube([ATOM, w, h+extra_h]);

                    translate([CUBE_WIDTH/2, -w/2, -extra_h2])
                    cube([ATOM, w, h+extra_h]);
                }
                cylinder(d=d, h=extra_h+h);
            }
            chamfer = 1;
            translate([0, 0, -SERVO_SHAFT_HEIGHT + chamfer])
            shaft_hollowing(chamfer=1);
            
            translate([0, 0, -SERVO_SHAFT_HEIGHT + h])
            shaft_hollowing();
            
            
            
        }
    }
}

module lower_servo_fixture(inner=true, outer=true, dropped=false, enveloppe=false) {
    h = SERVO_FIXTURE_ARM_H;
    d = SERVO_FIXTURE_ARM_D;
    marg = 5;

    if (enveloppe) {
        cylinder(d=d+3, h=h);
        
    }
    else translate([0, 0, dropped ? 0 : CUBE_HEIGHT-h-marg]) {
        if (inner)
            servo_shaft_fixture_inner(d, h, 0, 2, 5.5-1);
        if (outer)
            servo_shaft_fixture_outer(d, h, 0, 2, 5.5-1);
    }
}

module lower_servo_fixture_arm_passage() {
    union() {
        linear_extrude(CUBE_HEIGHT)
        offset(1)
        projection(cut=false) {
            lower_servo_fixture(enveloppe=true);
            lower_servo_fixture_arm(dropped=true);
        }
    }
}

module servo_pit() {
    // servo pit
    // TODO: add tolerance
    translate([-SERVO_BODY_X_SHIFT, -SERVO_BODY_WIDTH/2, -SERVO_BODY_HEIGHT])
    cube([SERVO_BODY_LENGTH,
          SERVO_BODY_WIDTH,
          SERVO_BODY_HEIGHT*30 + SERVO_UPPER_Z_POS]);

    // side pit (for cable)
    translate([-SERVO_BODY_X_SHIFT + SERVO_HOLDER_BORDER/2,
                -SERVO_BODY_WIDTH/2 - SERVO_HOLDER_BORDER/2, -SERVO_BODY_HEIGHT])
    cube([SERVO_BODY_LENGTH - SERVO_HOLDER_BORDER,
          SERVO_BODY_WIDTH + SERVO_HOLDER_BORDER,
          SERVO_BODY_HEIGHT*30 + SERVO_UPPER_Z_POS]);
}

module servo_holder(support_plate_diameter) {
    difference() {
        // body
        union() {
            dh = SERVO_L1_HEIGHT/2;
            translate([-SERVO_BODY_X_SHIFT - SERVO_HOLDER_BORDER,
                        -SERVO_BODY_WIDTH/2 - SERVO_HOLDER_BORDER, 0])
            cube([SERVO_BODY_LENGTH + SERVO_HOLDER_BORDER*2,
                  SERVO_BODY_WIDTH + SERVO_HOLDER_BORDER *2,
                  SERVO_UPPER_Z_POS + SERVO_BODY_HEIGHT - dh]);

            r = sqrt(pow(SERVO_BODY_LENGTH/2, 2) + pow(SERVO_BODY_WIDTH/2+SERVO_HOLDER_BORDER/2, 2));
            translate([SERVO_BODY_X_SHIFT - SERVO_HOLDER_BORDER/2, 0, 0])
            cylinder(r=r, h=SERVO_UPPER_Z_POS+SERVO_BODY_HEIGHT - dh);

            // round base
            d = support_plate_diameter - TOLERANCE*2;
            fn = FINE_FN;
            difference() {
                union() {
                    translate([0, 0, CUBE_WALL*2])
                    cylinder(d2=d - CUBE_WALL*4, d1=d, h=CUBE_WALL*2, $fn=fn);
                    cylinder(d=d, h=CUBE_WALL*2, $fn=fn);

                    translate([0, 0, -CUBE_WALL])
                    cylinder(d=d, h=CUBE_WALL, $fn=fn);

                    translate([0, 0, -CUBE_WALL*2])
                    cylinder(d1=d - CUBE_WALL, d2=d, h=CUBE_WALL,  $fn=fn);
                }
            }
        }

        // servo
        translate([0, 0, SERVO_UPPER_Z_POS]) {
            servo();
        }

        // pit
        servo_pit();

        // servo half pit
        // TODO: add tolerance
        x2 = (SERVO_L2_LENGTH - SERVO_BODY_LENGTH) / 2 + SERVO_BODY_X_SHIFT;
        translate([-x2, -SERVO_BODY_WIDTH/2, SERVO_L1_HEIGHT+SERVO_UPPER_Z_POS])
        cube([SERVO_L2_LENGTH, SERVO_BODY_WIDTH, SERVO_L2_HEIGHT*3]);
    }
    
    // TODO: add clip
}

module upper_servo_holder() {
    servo_holder(SUPPORT_PLATE_DIAMETER_UPPER);
}

COLUMN_RADIUS = SUPPORT_PLATE_DIAMETER_UPPER - CUBE_WALL*4;

module column() {
    D = SERVO_BODY_WIDTH/2;
    h = CUBE_HEIGHT*1.35;
    intersection() {
        difference() {
            translate([D, -CUBE_WIDTH - SERVO_BODY_WIDTH/2, 0])
            cube([CUBE_WIDTH, CUBE_WIDTH, h]);
            servo_pit();
        }

        cylinder(d=COLUMN_RADIUS, h=h*2, center=true);
    }
}

module reinforcement_cracks() {
    intersection() {
        union() {
            for (y=[0:-.5:-CUBE_WIDTH/2])
                translate([0, y, 0])
                cube([CUBE_WIDTH*2, .05, CUBE_HEIGHT*5], center=true);
        }
        cylinder(d=COLUMN_RADIUS-.3, h=CUBE_HEIGHT*5, center=true);
        column();
    }
}

module lower_servo_holder() {
    difference() {
        union() {
            // holder
            difference() {
                servo_holder(SUPPORT_PLATE_DIAMETER_LOWER);

                translate([-SERVO_HOLDER_BORDER*2, 0, SERVO_UPPER_Z_POS])
                servo();
            }

            // column
            column();
        }
    }
}

module holder_upper() {
    difference() {
        translate([0, 0, UPPER_Z])
        union() {
            if ($preview)
                translate([0, 0, SERVO_UPPER_Z_POS]) servo();

            cube_upper();

            upper_servo_holder();
        }

        // servo holes
        translate([0, 0, SERVO_UPPER_Z_POS + UPPER_Z - SERVO_HOLE_DIAMETER/4])
        servo_support_holes();
    }
}

module holder_lower() {
    difference() {
        upper_z = CUBE_HEIGHT + CUBE_H_GAP;
        union() {
            if ($preview)
                translate([0, 0, SERVO_UPPER_Z_POS]) servo();
            lower_cube_body();
            lower_servo_holder();
        }

        // servo holes
        translate([0, 0, SERVO_UPPER_Z_POS - SERVO_HOLE_DIAMETER/4])
        servo_support_holes();
        
        // reinforcement
        if(!$preview)
            reinforcement_cracks();
    }
}

module all() {
    holder_upper();
    holder_lower();
}

module crosscut(force=false) {
    rotate([0, 0, 90]) 
    difference() {
        children();
        if ($preview || force) {
            // cut quarter
            if (1)
                translate([-CUBE_WIDTH*.75, -CUBE_WIDTH, -CUBE_WIDTH/2])
                cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_WIDTH*10]);
            // cut bottom
            if (0)
                cylinder(r=CUBE_WIDTH, h=CUBE_HEIGHT*.87, center=true);
        }
    }
}

module printing_cube_lower() {
    translate([0, 0, CUBE_HEIGHT])
    rotate([180, 0, 0])
    lower_cube_body();
}

module printing_servos_holder() {
    difference() {
        union() {
            lower_servo_holder();
            translate([0, 0, UPPER_Z]) upper_servo_holder();
        }

        // servo holes (rings)
        translate([0, 0, SERVO_UPPER_Z_POS - SERVO_HOLE_DIAMETER/4])
        servo_support_holes();
        translate([0, 0, SERVO_UPPER_Z_POS + UPPER_Z - SERVO_HOLE_DIAMETER/4])
        servo_support_holes();

        // passage
        translate([0, 0, CUBE_HEIGHT*.9])
        rotate([0, 0, 90*2]) {
            lower_servo_fixture_arm_passage();
        }

        // reinforcement
        if(!$preview)
            reinforcement_cracks();
    }
}

module cube_upper() {
    h = 7;
    chamfer = 1;
    difference() {
        union() {
            upper_cube_body();

            // thick ceiling
            translate([0, 0, CUBE_HEIGHT - CUBE_WALL*1.5 - h])
            cylinder(d=CUBE_WIDTH - ATOM, h=h);
        }

        // shaft hollowing
        translate([0, 0, CUBE_HEIGHT - SERVO_SHAFT_HEIGHT -CUBE_WALL*1.5])
        shaft_hollowing();

        translate([0, 0, CUBE_HEIGHT - CUBE_WALL*1.5 - h - SERVO_SHAFT_HEIGHT + chamfer])
        shaft_hollowing(chamfer=chamfer);
    }
}

module printing_cube_upper() {
    // cube
    rotate([180, 0, 0])
    translate([0, 0, -CUBE_HEIGHT])
    cube_upper();

    // corner pads
    r = 10;
    for(i=[0:3])
        rotate([0, 0, (i+.5)*90])
        translate([CUBE_HEIGHT*.915 + r, 0, 0])
        cylinder(r=r, h=.4);
}

////////////////////////////////////////////////////////////////////////////////

!printing_servos_holder();
//!printing_cube_lower();

crosscut(true) all();

//!crosscut() holder_upper();
//!crosscut() holder_lower();

//!crosscut(true) printing_cube_lower();
//!crosscut(true) printing_cube_upper();
