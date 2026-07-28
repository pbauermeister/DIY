use <../chamferer.scad>
use <sides.scad>
use <stud.scad>

L               = 200 -5;
W               = 15;

D               = get_holes_d_sp()[0];
SP              = get_holes_d_sp()[1];

TH              = 5;

WHEEL_D         = 15                            +1.5;
WHEEL_X         = W/2 + WHEEL_D/2 - TH/2;
SCREW_D         = 2;

SD              = 2;

PLAY            = 0.3;
ATOM            = 0.01;

WHEEL_AXIS_X    = WHEEL_X - WHEEL_D*.05;

PW              = WHEEL_X*2 + WHEEL_D/2;
PL              = (D+SP)*(3+2);
PXTRA_R         = 8;
PXTRA_L         = 2;
PTH             = 6;

$fn             = $preview ? 50 : 200;

module rail() {
    // studs
    for (i=[1:14-2]) {
        translate([0, i*(D+SP), 0]) {
            j = i+4;
            if (j%3 < 1)
                stud();
        }
    }

    // rail
    chamferer(2.4, "cone", fn=4)
    difference() {
        w = W+2.5;
        translate([-w/2, 0, -TH])
        cube([w, L, TH]);

        // ratchets
        c = TH *.75;
        for (i=[1:14-3]) {
            x = w/2;
            translate([x, (i+.5)*(D+SP), 0]) {
                scale([1, 1.25, 1])
                rotate([0, 0, 45])
                cube([c, c, TH*4], center=true);
            }
        }
    }
}

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
            cylinder(d=SCREW_D+.55, h=TH*4, center=true);

            translate([0, 0, TH - 1.75])
            cylinder(d=SCREW_D*2.5, h=TH);
        }
    }
}

module screw_anchor_hole(d) {
    cylinder(d=d, h=TH*10, center=true);

    translate([0, 0, -PTH/2+.5 - PLAY -TH -.5])
    for (a=[0:30:360])
        rotate([0, 0, a])
        cube([d*3, .1, PTH-1], center=true);
}

module wheel_screw_axis() {
    union() {
        for (y=[1.5, 3.5]) {
            translate([WHEEL_AXIS_X, (D+SP)*y, 0])
            //cylinder(d=SCREW_D-.5, h=TH*10, center=true);
            screw_anchor_hole(SCREW_D-.65);
        }
    }
}

module wheels() {
    union() {
        for (y=[1.5, 3.5]) {
            translate([WHEEL_AXIS_X, (D+SP)*y, 0])
            wheel();
        }
    }
}

module plate() {
    union() {
        SY = (D+SP);
        difference() {
            union() {
                // plate
                difference() {
                    translate([-PW/2-PXTRA_L, 0, -PTH -TH -PLAY])
                    cube([PW + PXTRA_R + PXTRA_L, PL, PTH]);

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

            // shave for strut
            translate([-PW - WHEEL_X, SY -ATOM, -TH*2.5])
            cube([PW, PL, TH*3]);

            // screw hole
            translate([-WHEEL_X, (D+SP)/2 , 0])
            screw_anchor_hole(SCREW_D-.5);
            
            // spring_holes
            for (k=[-1:1]) {
                translate([0, (D+SP)*2.5 + k*6, 0])
                translate([2, 0, -TH-PLAY-PTH/2])
                rotate([0, 90, 0])
                cylinder(d=5, h=15);
            }
        }
    }
}

module qcube(w, h, th) {
    tth = th / sqrt(2);

    hull()
    for (y=[0, h]) {
        translate([0, y, th/2])
        scale([1, .5, 1])
        rotate([45, 0, 0])
        translate([0, -tth/2, -tth/2])
        cube([w, tth, tth]);
    }
}

module partitioner(dx=0) {
    translate([0, (D+SP), -PTH-PLAY-TH -ATOM])
    difference() {
        translate([-PXTRA_R+3, (D+SP)*.25, 0])
        //cube([W+PXTRA_R, (D+SP)*2.5, PTH+ATOM*2]);
        qcube(W+PXTRA_R -3, (D+SP)*2.5, PTH+ATOM*2);

        translate([PXTRA_R*.75 + dx, (D+SP)*1, -PTH/2])
        //cube([W*1.5, (D+SP)*1.5, PTH*2]);
        qcube(W*1.5, (D+SP)*1, PTH*2);
    }
}

module carriage() {
    difference() {
        plate();
        
        dy = .60; //.45 .23;
        for (x=[-1, 2.75+1.5])
            for (y=[-dy, dy])
                translate([x, y, 0])
                partitioner(dx=2);
    }

    intersection() {
        plate();
        partitioner();
    }
}

/////////////////////////////////////////////////////////////

color("green")
rail();

wheels();

color("lightblue")
carriage();