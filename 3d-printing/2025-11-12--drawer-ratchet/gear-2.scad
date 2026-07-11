/*

Extra BOM:
- Compression spring:
  - Diameter ca. 10 mm
  - Length ca. 60 mm
  - Cut in 2 halves
  - Together with the arm, produces ca. 10 N
*/

LENGTH       = 70;
WIDTH        = 12                 +1;
PLATE_TH     =  1;
ARM_TH       =  1.15  +.5  + .5;

SCREW_D      =  2;

WHEEL_D      = 16;
WHEEL_H      =  6;
WHEEL_D2     = SCREW_D + 0.5;

HUB_D        =  5;
HUB_D2       = SCREW_D -.1;
AXIS_POS     = 14;

REST_L       =  6;
REST_R       =  2;
REST_MARG    =  1.5;

FLEX         = AXIS_POS-WHEEL_D/2;

PLATE_WIDTH  = 26;
ANGLE        =  9;
TOP_SPACE    = PLATE_WIDTH - WIDTH;

SCREW_POS    = LENGTH/2.7;

SPRING_POS   = LENGTH - WHEEL_D/2 -WHEEL_D;
SPRING_D_OUT = 11.5;
SPRING_D_IN  =  8.0;

PLAY         =   0.3;
TOL          =   0.25;

$fn          = 100;
ATOM         =   0.01;

module wheel(play=false, clearance=0, ch=.5) {
    h = WHEEL_H + (play ? PLAY*2 : 0);
    d = WHEEL_D + clearance*2;
    translate([0, 0, -(play ? PLAY : 0)])
    difference() {
        hull() {
            translate([0, 0, ch])
            cylinder(d=d, h=h-ch*2);
            cylinder(d=d-ch*2, h=h);
        }

        if (!play)
        cylinder(d=WHEEL_D2, h=h*3, center=true);
    }
}

module arm() {
    // slanted base
    th = 10;
    difference() {
        translate([0, -th, 0])
        cube([LENGTH, th, WIDTH*3]);

        // shave slanted side
        translate([0, -PLATE_TH, 0])
        rotate([ANGLE, 0, 0])
        translate([-LENGTH/2, -th, 0])
        cube([LENGTH*2, th, WIDTH*3]);

        // shave top
        translate([-LENGTH/2, -th*50, WIDTH+TOP_SPACE])
        cube([LENGTH*2, th*100, WIDTH*3]);

        // screw holes
        d = 3.8;
        for (x=[LENGTH*.15, LENGTH*.85]) {
            hull() for (z=[-1.5, 1.5]) {
                translate([x, 0, WIDTH+d/2+3 + z])
                rotate([90, 0, 0])
                cylinder(d=d, h=LENGTH, center=true, $fn=20);
            }
        }
    }

    // wheel (ghost)
    hub_x = LENGTH - WHEEL_D/2;
    %translate([hub_x, AXIS_POS, WIDTH/2 - WHEEL_H/2]) wheel();

    // arm
    difference() {
        union() {
            // arm
            l = hub_x-TOL-REST_MARG - REST_L/2;
            echo(l);
            translate([REST_L/2, FLEX, 0])
            cube([l, ARM_TH, WIDTH]);

            // hub
            l1 = HUB_D*2.5;
            hull() {
                // axis
                translate([hub_x, AXIS_POS, 0])
                cylinder(d=HUB_D, h=WIDTH);

                translate([hub_x-l1, AXIS_POS-WHEEL_D/2, 0])
                cube([l1, ATOM, WIDTH]);
                
                translate([hub_x-l1, AXIS_POS, 0])
                cube([l1, ATOM, WIDTH]);
            }

            l2 = HUB_D * 7;
            hull() {
                translate([hub_x-l1-l2, AXIS_POS-WHEEL_D/2, 0])
                cube([l2, ATOM, WIDTH]);

                l3 = WHEEL_D / 2; //l2 - WHEEL_D/2;
                translate([hub_x-l1-l3, AXIS_POS, 0])
                cube([l3, ATOM, WIDTH]);
            }            

            // spring holder
            translate([SPRING_POS, 0, WIDTH/2])
            rotate([-90, 0, 0])
            cylinder(d=SPRING_D_IN, h=2);
        }

        // wheel hollowing
        translate([hub_x, AXIS_POS, WIDTH/2 - WHEEL_H/2])
        wheel(PLAY, 1, 0);

        // spring holder
        translate([SPRING_POS, FLEX-ATOM, WIDTH/2])
        rotate([-90, 0, 0])
        cylinder(d=SPRING_D_OUT, h=WHEEL_D/2-2);

        // hub axis
        translate([hub_x, AXIS_POS, WIDTH/2 - WHEEL_H/2])
        cylinder(d=HUB_D2, h=WIDTH*3, center=true);
    }

    // elbow
    difference() {
        intersection() {
            cube([REST_L, FLEX+ARM_TH, WIDTH]);
            hull() {
                translate([REST_L/2, FLEX+ARM_TH-REST_L/2, 0])
                cylinder(d=REST_L, h=WIDTH);
                translate([REST_L/2, 0, 0])
                cylinder(d=REST_L, h=WIDTH);
            }
        }

        hull() {
            translate([REST_L, FLEX-REST_R, 0])
            cylinder(r=REST_R, h=WIDTH*3, center=true);
            translate([REST_L, REST_R, 0])
            cylinder(r=REST_R, h=WIDTH*3, center=true);
        }

    }
}

if ($preview) {
    arm();
} else {
    arm();

    translate([0, -15, 0])
    scale([1, -1, 1])
    arm();
}
