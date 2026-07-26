use <../chamferer.scad>
use <sides.scad>
use <stud.scad>

L = 200 -5; // box width: 227
W = 15;

D  = get_holes_d_sp()[0];
SP = get_holes_d_sp()[1];

TH = 5;
PLAY = .3;

ATOM = 0.01;

$fn = $preview ? 50 : 200;

module rail() {
    // studs
    for (i=[1:14-2]) {
        translate([0, i*(D+SP), 0]) {
            j = i+4;
            if (j%5 < 2)
                stud();
        }
    }

    // rail
    chamferer(2.4, "cone", fn=4)
    difference() {
        translate([-W/2, 0, -TH])
        cube([W, L, TH]);

        // ratchets
        c = TH *.75;
        for (i=[1:14-3]) {
            x = W/2;
            translate([x, (i+.5)*(D+SP), 0]) {
                rotate([0, 0, 45])
                cube([c, c, TH*4], center=true);
            }
        }
    }
}

WHEEL_D = 15;
WHEEL_X = W/2 + WHEEL_D/2 - TH/2;
SCREW_D = 2;

SD = 2;

module wheel() {
    translate([0, 0, -TH]) {
        difference() {
            intersection() {
                union() {
                    cylinder(d1=WHEEL_D-TH/3, d2=WHEEL_D-TH/3*5, h=TH);
                    cylinder(d2=WHEEL_D-TH/3, d1=WHEEL_D-TH/3*5, h=TH);
                }
                //translate([0, 0, .5])
                cylinder(d=WHEEL_D-TH/3 * 1.75, h=TH-.5);        
            }

            // screw hole
            cylinder(d=SCREW_D+.3, h=TH*4, center=true);

            translate([0, 0, TH - 1.75])
            cylinder(d=SCREW_D*2.5, h=TH);

        }
    }
}

WHEEL_AXIS_X = WHEEL_X - WHEEL_D*.05;

module wheels() {
    union() {
        for (y=[1.5, 3.5]) {
            translate([WHEEL_AXIS_X, (D+SP)*y, 0])
            wheel();
        }
    }
}

module wheel_screw_axis() {
    union() {
        for (y=[1.5, 3.5]) {
            translate([WHEEL_AXIS_X, (D+SP)*y, 0])
            cylinder(d=SCREW_D-.5, h=TH*10, center=true);
        }
    }
}


color("green")
rail();

wheels();

PW  = WHEEL_X*2 + WHEEL_D/2;
PL  = (D+SP)*(3+2);
PXTRA  = 15;
PTH = TH;

union() {
    SY = (D+SP);
    difference() {
        union() {
            // plate
            difference() {
                translate([-PW/2, 0, -PTH -TH -PLAY])
                cube([PW + PXTRA, PL, PTH]);

                // screw hole
                wheel_screw_axis();
            }

            // rail
            difference() {
                translate([-PW/2, 0, -PTH -TH -PLAY])
                cube([PW/2-W/2+TH/2, PL, PTH+PLAY+TH -PLAY]);

                hull() for (k=[1, -1]) {
                    translate([(-W/2 +TH/sqrt(2)/2)*k, 0, -TH/2])
                    scale([.5, 1, 1])
                    rotate([0, 45, 0])
                    cube([TH, PL*3, TH], center=true);
                }

                // clearance for strut
                translate([-PW, -1, -TH-PLAY])
                cube([PW, SY +1, TH*2]);
            }
        }

        translate([-PW - WHEEL_X, SY -ATOM, -TH*2.5])
        cube([PW, PL, TH*3]);
    }
}