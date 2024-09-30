// Lego Geekservo 270°
// https://www.robotshop.com/products/geekservo-9g-270-servo-compatible-with-lego

////////////////////////////////////////////////////////////////////////////////

// SERVO

// - shaft
SERVO_SHAFT_CROSS_WIDTH     =  5.0;
SERVO_SHAFT_CROSS_THICKNESS =  1.8;
SERVO_SHAFT_HEIGH           = 34.5;

// - body
SERVO_BODY_WIDTH            =  16;
SERVO_L1_HEIGHT             =  9.5;
SERVO_L2_HEIGHT             =  9.5;
SERVO_L2_LENGTH             = 40;
SERVO_BODY_HEIGHT           = 26.6;
SERVO_BODY_X_SHIFT          =  7;
SERVO_BODY_LENGTH           = 24;
// - misc
SERVO_COLUMN_HEIGH          = 28.9;
SERVO_COLUMN_DIAMETER       = 12;
SERVO_HOLE_DIAMETER         =  4.5;
SERVO_HOLE_Z                = 15;
SERVO_HOLE_DIST             = 31.5;

// SERVOS POSITIONS

SERVO_UPPER_Z_POS           =  5;

// SERVO HOLDER

SERVO_HOLDER_BORDER         =  4;

// CUBE

CUBE_WIDTH                  = 60 - 5;
CUBE_WALL                   =  1;
CUBE_HEIGHT                 = 45; 
CUBE_H_GAP                  =  0.25;

SUPPORT_PLATE_RADIUS = CUBE_WIDTH - CUBE_WALL*2;

// MISC
TOLERANCE = 0.13;
ATOM = 0.02;
$fn = $preview ? 40 : 180;

////////////////////////////////////////////////////////////////////////////////

module servo_shaft() {
    translate([-SERVO_SHAFT_CROSS_WIDTH/2, -SERVO_SHAFT_CROSS_THICKNESS/2, 0])
    cube([SERVO_SHAFT_CROSS_WIDTH, SERVO_SHAFT_CROSS_THICKNESS, SERVO_SHAFT_HEIGH]);

    translate([-SERVO_SHAFT_CROSS_THICKNESS/2, -SERVO_SHAFT_CROSS_WIDTH/2, 0])
    cube([SERVO_SHAFT_CROSS_THICKNESS, SERVO_SHAFT_CROSS_WIDTH, SERVO_SHAFT_HEIGH]);
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

module servo_holes(x_shift=0) {
    d = (SERVO_BODY_LENGTH/2-SERVO_BODY_X_SHIFT);
    for (x=[-SERVO_HOLE_DIST/2+x_shift, SERVO_HOLE_DIST/2-x_shift])
        translate([x+d, 0, SERVO_HOLE_Z])
        rotate([90, 0, 0])
        scale([x_shift ? .5 : 1, 1, 1])
        cylinder(d=SERVO_HOLE_DIAMETER, h=SERVO_BODY_WIDTH*1.9, center=true);

    for (i=[1, -1])
        translate([d, i*(SERVO_BODY_WIDTH/2 + SERVO_HOLE_DIAMETER/4 + SERVO_HOLDER_BORDER*1.5), SERVO_HOLE_Z])
        rotate([0, 90, 0])
        scale([1, .5, 1])
        cylinder(d=SERVO_HOLE_DIAMETER, h=SERVO_L2_LENGTH*1.25, center=true);


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

module cube_inner_cylinder(h) {    
    difference() {
        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
        cube([CUBE_WIDTH, CUBE_WIDTH, h]);

        cylinder(d=SUPPORT_PLATE_RADIUS, h=h*3, center=true);
    }
    
    // O-ring
    translate([0, 0, CUBE_WALL*3.25 + TOLERANCE/2])
    scale([1, 1, 1.5])
    rotate_extrude(convexity=10)
    translate([CUBE_WIDTH/2 - CUBE_WALL + TOLERANCE, 0, 0])
    circle(r=CUBE_WALL*.85);
}

module upper_cube_body() {
    difference() {
        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
        cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

        translate([-CUBE_WIDTH/2 + CUBE_WALL, -CUBE_WIDTH/2 + CUBE_WALL, -ATOM])
        cube([CUBE_WIDTH - CUBE_WALL*2, CUBE_WIDTH - CUBE_WALL * 2, CUBE_HEIGHT - CUBE_WALL*1.5+ATOM]);
    }

    cube_inner_cylinder(CUBE_HEIGHT);
    // TODO: servo shaft fixture
}

module lower_cube_body() {
    difference() {
        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
        cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

        translate([-CUBE_WIDTH/2 + CUBE_WALL, -CUBE_WIDTH/2 + CUBE_WALL, -ATOM])
        cube([CUBE_WIDTH - CUBE_WALL*2, CUBE_WIDTH - CUBE_WALL * 2, CUBE_HEIGHT*2]);
    }

    cube_inner_cylinder(CUBE_HEIGHT);
    // TODO: servo shaft fixture
}

module servo_pit() {
    // servo pit
    // TODO: add tolerance
    translate([-SERVO_BODY_X_SHIFT, -SERVO_BODY_WIDTH/2, -SERVO_BODY_HEIGHT])
    cube([SERVO_BODY_LENGTH,
          SERVO_BODY_WIDTH,
          SERVO_BODY_HEIGHT*3 + SERVO_UPPER_Z_POS]);

    // side pit (for cable)
    translate([-SERVO_BODY_X_SHIFT + SERVO_HOLDER_BORDER/2,
                -SERVO_BODY_WIDTH/2 - SERVO_HOLDER_BORDER/2, -SERVO_BODY_HEIGHT])
    cube([SERVO_BODY_LENGTH - SERVO_HOLDER_BORDER,
          SERVO_BODY_WIDTH + SERVO_HOLDER_BORDER,
          SERVO_BODY_HEIGHT*3 + SERVO_UPPER_Z_POS]);
}

module upper_servo_holder() {
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
            d = SUPPORT_PLATE_RADIUS - TOLERANCE*2;

            difference() {
                union() {
                    translate([0, 0, CUBE_WALL*2])
                    cylinder(d2=d - CUBE_WALL*4, d1=d, h=CUBE_WALL*2);
                    cylinder(d=d, h=CUBE_WALL*2);

                    translate([0, 0, -CUBE_WALL])
                    cylinder(d=d, h=CUBE_WALL);

                    translate([0, 0, -CUBE_WALL*2])
                    cylinder(d1=d - CUBE_WALL, d2=d, h=CUBE_WALL);
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

module column() {
    D = SERVO_BODY_WIDTH/2;
    h = CUBE_HEIGHT*1.35;
    intersection() {
        difference() {
            translate([D, -CUBE_WIDTH - SERVO_BODY_WIDTH/2, 0])
            cube([CUBE_WIDTH, CUBE_WIDTH, h]);
            servo_pit();
        }

        cylinder(d=SUPPORT_PLATE_RADIUS-2, h=h*2, center=true);
    }
}

module reinforcement_cracks() {
    intersection() {
        union() {
            for (y=[0:-.5:-CUBE_WIDTH/2])
                translate([0, y, 0])
                cube([CUBE_WIDTH*2, .05, CUBE_HEIGHT*5], center=true);
        }
        cylinder(d=SUPPORT_PLATE_RADIUS-4, h=CUBE_HEIGHT*5, center=true);
        column();
    }
}

module lower_servo_holder() {
    difference() {
        union() {
            // holder
            difference() {
                upper_servo_holder();

                translate([-SERVO_HOLDER_BORDER*2, 0, SERVO_UPPER_Z_POS])
                servo();
            }

            // column
            column();
        }

        if(!$preview)
            reinforcement_cracks();
    }
}


difference() {
    difference() {
        upper_z = CUBE_HEIGHT + CUBE_H_GAP;
        union() {
            // upper part
            translate([0, 0, upper_z])
            union() {
                %translate([0, 0, SERVO_UPPER_Z_POS]) servo();
    //%            upper_cube_body();
                upper_servo_holder();
            }

            // lower part
            union() {
                %translate([0, 0, SERVO_UPPER_Z_POS]) servo();
    //%            lower_cube_body();
                lower_servo_holder();
            }
        }

        for (z=[0, upper_z])
        translate([0, 0, SERVO_UPPER_Z_POS+z - SERVO_HOLE_DIAMETER/3]) {
            servo_holes(x_shift=SERVO_HOLE_DIAMETER/2);
        }

    }

    if (0 && $preview)
        translate([0, 0, -CUBE_WIDTH/2])
        cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_WIDTH*10]);
}