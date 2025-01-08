// Lego Geekservo 270°
// https://www.robotshop.com/products/geekservo-9g-270-servo-compatible-with-lego

////////////////////////////////////////////////////////////////////////////////

// SERVO

// - shaft
SERVO_SHAFT_CROSS_WIDTH      =  5.0;
SERVO_SHAFT_CROSS_THICKNESS  =  1.8;
SERVO_SHAFT_HEIGH            = 34.5;

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

// CUBE
CUBE_WIDTH                   = 60 - 3;
CUBE_WALL                    =  1;
CUBE_HEIGHT                  = 45; 
CUBE_H_GAP                   =  0.25;

SUPPORT_PLATE_DIAMETER_LOWER = CUBE_WIDTH - CUBE_WALL*2;
SUPPORT_PLATE_DIAMETER_UPPER = SUPPORT_PLATE_DIAMETER_LOWER - CUBE_WALL*2;

// COMPUTED
UPPER_Z                      = CUBE_HEIGHT + CUBE_H_GAP;

// MISC
TOLERANCE = 0.13;
ATOM      = 0.02;
$fn       = $preview ? 40 : 60;
FINE_FN   = $preview ? 40 : 360;

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
    //translate([CUBE_WIDTH/2 - CUBE_WALL + TOLERANCE, 0, 0])
    translate([support_plate_diameter/2 + TOLERANCE, 0, 0])
    circle(r=section);
}

module cube_inner_cylinder(h, support_plate_diameter) {    
    difference() {
        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
        cube([CUBE_WIDTH, CUBE_WIDTH, h]);

        cylinder(d=support_plate_diameter,
                 h=h*3, center=true, $fn=FINE_FN);
    }
    
    // O-ring
    translate([0, 0, CUBE_WALL*3.25 + TOLERANCE/2])
    o_ring(CUBE_WALL*.85, support_plate_diameter);
}

module upper_cube_body() {
    cavity_h = CUBE_HEIGHT - CUBE_WALL*1.5;
    difference() {
        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
        cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

        translate([-CUBE_WIDTH/2 + CUBE_WALL, -CUBE_WIDTH/2 + CUBE_WALL, -ATOM])
        cube([CUBE_WIDTH - CUBE_WALL*2, CUBE_WIDTH - CUBE_WALL * 2, cavity_h + ATOM]);
    }

    cube_inner_cylinder(CUBE_HEIGHT, SUPPORT_PLATE_DIAMETER_UPPER);
}

module servo_shaft_fixture(size, h, z, step, arm_w) {
    border = 1;
    d = (size - border*2) / sqrt(2);
    union() {
        // outer crown
        translate([0, 0, z])
        difference() {
            cylinder(d=size+ATOM*4, h=h);
            for(a=[0:step:360-1])
                rotate([0, 0, a])
                cube([d, d, h*3], center=true);
        }

        // inner wheel
        color("red")
        translate([0, 0, z]) {
            difference() {
                union() {
                    // teeth
                    translate([0, 0, h/2])
                    cube([d, d, h], center=true);

                    // crown
                    cylinder(d=size - border*2.75, h=h);
                }
                cylinder(d=size - border*4.5, h=h*3, center=true);
            }
            
            difference() {
                // cross
                intersection() {
                    union() {
                        l = size - border*(4.5-ATOM*2);
                        translate([0, 0, h/2])
                        cube([arm_w, l, h], center=true);
                        translate([0, 0, h/2])
                        cube([l, arm_w, h], center=true);
                    }
                    cylinder(d=size - border*4.5 + ATOM, h=h*3, center=true);
                }

                // shaft
                for(i=[-1, 1]) {
                    for(j=[-1, 1]) {
                        translate([i*TOLERANCE,j*TOLERANCE, -h*2])
                        servo_shaft();
                    }
                }
            }
        }
    }
}

module upper_servo_shaft_fixture() {
    servo_shaft_fixture(SUPPORT_PLATE_DIAMETER_UPPER, 7, -7, 1, 8);
}

module lower_cube_body() {
    difference() {
        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
        cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

        translate([-CUBE_WIDTH/2 + CUBE_WALL, -CUBE_WIDTH/2 + CUBE_WALL, -ATOM])
        cube([CUBE_WIDTH - CUBE_WALL*2, CUBE_WIDTH - CUBE_WALL * 2, CUBE_HEIGHT*2]);
    }

    cube_inner_cylinder(CUBE_HEIGHT, SUPPORT_PLATE_DIAMETER_LOWER);

    intersection() {
        translate([0, 0, CUBE_HEIGHT])
        o_ring(CUBE_WALL*1.67, SUPPORT_PLATE_DIAMETER_LOWER+CUBE_WALL);

        translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
        cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);
    }

    // servo shaft fixture
    h = 4;
    extra_h = 1;
    extra_h2 = 4;
    w = 12;
    marg = 5;
    d = 30 - 6;
    translate([0, 0, CUBE_HEIGHT-h-marg]) {
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
            }
            cylinder(d=d, h=h*3, center=true);
        }
        servo_shaft_fixture(d, h, 0, 2, 5.5);
        
        translate([0, 0, h])
        cylinder(d=d, h=extra_h);
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
        cylinder(d=COLUMN_RADIUS-4, h=CUBE_HEIGHT*5, center=true);
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
        union() {
            // upper part
            translate([0, 0, UPPER_Z])
            union() {
                translate([0, 0, SERVO_UPPER_Z_POS]) servo();

                upper_cube_body();

                translate([0, 0, CUBE_HEIGHT - CUBE_WALL*1.5])
                upper_servo_shaft_fixture();

                upper_servo_holder();
            }
        }

        // servo holes
        translate([0, 0, SERVO_UPPER_Z_POS + UPPER_Z - SERVO_HOLE_DIAMETER/4])
        servo_support_holes();
        
        // reinforcement
        if(!$preview)
            reinforcement_cracks();
    }
}

module holder_lower() {
    difference() {
        upper_z = CUBE_HEIGHT + CUBE_H_GAP;
        union() {
            // lower part
            union() {
                translate([0, 0, SERVO_UPPER_Z_POS]) servo();
                lower_cube_body();
                lower_servo_holder();
            }
        }

        // servo holes
        translate([0, 0, SERVO_UPPER_Z_POS - SERVO_HOLE_DIAMETER/4])
        servo_support_holes();
        
        // reinforcement
        if(!$preview)
            reinforcement_cracks();
    }
}

module holders() {
    holder_upper();
    holder_lower();
}

module crosscut() {
    difference() {
        children();
        if ($preview) {
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

//crosscut() holders();
crosscut() holder_lower();
