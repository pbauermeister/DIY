use <../chamferer.scad>
use <sides.scad>
use <stud.scad>

L               = 200 -5;
W               = 15;

D               = get_holes_d_sp()[0];
SP              = get_holes_d_sp()[1];

TH              = 5;

WHEEL_D         = 15;
WHEEL_XD        = 1.5;
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

$fn             = $preview ? 20 : 200;

////////////////////////////////////////////////////////////////////////////////

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

module rbar(l, w, th) {
    hull()
    for (y=[w/2, l-w/2])
        translate([w/2, y, 0])
            cylinder(d=w, h=th);
}
////////////////////////////////////////////////////////////////////////////////

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
        w = W;
        translate([-w/2, 0, -TH])
        cube([w, L, TH]);

        // ratchets
        c = TH *.75;
        for (i=[1:14-3]) {
            x = w/2;
            translate([x, (i+.5)*(D+SP), 0]) {
                //scale([1, 1.25, 1])
                rotate([0, 0, 45])
                cube([c, c, TH*4], center=true);
            }
        }
    }
}

module wheel() {
    d = WHEEL_D + WHEEL_XD;
    translate([0, 0, -TH]) {
        difference() {
            intersection() {
                union() {
                    cylinder(d1=d-TH/3, d2=d-TH/3*5, h=TH);
                    cylinder(d2=d-TH/3, d1=d-TH/3*5, h=TH);
                }
                //translate([0, 0, .5])
                cylinder(d=d-TH/3 * 1.75, h=TH-.5);        
            }

            // screw hole
            cylinder(d=SCREW_D+.55 +.2, h=TH*4, center=true);

            translate([0, 0, TH - 1.75])
            cylinder(d=SCREW_D*2.5, h=TH);
        }
    }
}

module screw_anchor_hole(d, z=-PTH/2+.5 - PLAY -TH -.5, force=false) {
    cylinder(d=d, h=TH*10, center=true);

    if (!$preview || force)
    translate([0, 0, z]) {
        for (dd=[d:1:d*4]) difference() {
            cylinder(d=dd, h=PTH-1, center=true, $fn=20);
            cylinder(d=dd-.2, h=PTH, center=true, $fn=20);
        }
    }
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
        dy = 5;
        SY = (D+SP) + dy;
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
                    union() {
                        th = PTH+PLAY+TH -PLAY;
                        translate([-PW/2- PXTRA_L, 0, -PTH -TH -PLAY])
                        cube([PW/2-W/2+TH/2 + PXTRA_L, PL, th]);


                        l = D-2;
                        for (y=[(D+SP)/2 , PL - l - (D+SP)/2]) {
                            translate([W/2-TH/2, y, -TH-PLAY])
                            cube([10, l, TH]);
                        }

                    }

                    // rail chamber
                    hull() for (k=[1, -1.08]) {
                        translate([(-W/2 +TH/sqrt(2)/2)*k*.9, 0, -TH/2])
                        scale([.67, 1, 1])
                        rotate([0, 45, 0])
                        cube([TH, PL*3, TH], center=true);
                    }
                }
            }

            // clearance for strut
            translate([-PW-PW/2 + W/2 + PXTRA_L/2 -1, dy, -PLAY-(TH+PTH)+2.5])
            cube([PW, SY-dy, (TH+PTH)-5]);
            echo(str("strut th =", (TH+PTH)-5-1));

            // shave for strut
            translate([-PW - WHEEL_X, SY -ATOM, -TH*2.5])
            cube([PW, PL, TH*3]);

            // screw hole
            translate([-WHEEL_X -2, (D+SP)/2 + dy , 0])
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

module partitioner(dx=0) {
    translate([0, (D+SP), -PTH-PLAY-TH -ATOM])
    difference() {
        translate([-PXTRA_R+3, (D+SP)*(.25-.75), 0])
        //cube([W+PXTRA_R, (D+SP)*2.5, PTH+ATOM*2]);
        qcube(W+PXTRA_R -3, (D+SP)*(2.5+1.5), PTH+ATOM*2);

        translate([PXTRA_R*.75 + dx, (D+SP)*.9, -PTH/2])
        //cube([W*1.5, (D+SP)*1.5, PTH*2]);
        qcube(W*1.5, (D+SP)*1.2, PTH*2);
    }
}

module carriage() {
    difference() {
        plate();
        
        dy = .60  -.1*0; //.45 .23;
        for (x=[-1, 2.75+1.5  -2.5])
            for (y=[-dy, dy])
                translate([x, y, 0])
                partitioner(dx=2);
    }

    intersection() {
        plate();
        partitioner();
    }
}


STRUT_L         = 140;
STRUT_W         =   8;
STRUT_TH        = PTH;
STRUT_AXIS_D    =   5;
STRUT_HEAD_D    =  11;

module strut_washer() {
    difference() {
        cylinder(d=STRUT_AXIS_D +.5 -1, h=STRUT_TH);
        cylinder(d=SCREW_D+.55 +.2, h=TH*4, center=true);
    }
}

module strut() {
    y = (D+SP)/2 + 5;
    bx = -STRUT_W - WHEEL_X - PLAY;
    z = -PLAY-TH-STRUT_TH +2.5;

    axis_pos = [[-WHEEL_X -2, y], [bx+STRUT_W/2, D + STRUT_L - STRUT_W/2]];

    difference() {
        chamferer($preview ? 0 : .8)
        union() {
            translate([bx, D, z]) {
                rbar(STRUT_L, STRUT_W, STRUT_TH);
            }

            hull() {
                translate([bx+STRUT_W/2, D+STRUT_W/2, z])
                cylinder(d=STRUT_W, STRUT_TH);

                translate([-WHEEL_X -2, y , z])
                cylinder(d=STRUT_HEAD_D, h=STRUT_TH);
            }

            for (xy=axis_pos) {
                translate([xy[0], xy[1] , z])
                cylinder(d=STRUT_HEAD_D, h=STRUT_TH);
            }

        }
        
        // axis holes
        for (xy=axis_pos) {
            translate([xy[0], xy[1] , z])
            cylinder(d=STRUT_AXIS_D +.5, h=STRUT_TH*4, center=true);
        }

        // play
        translate([-WHEEL_X -2, y , z+STRUT_TH-PLAY*2])
        cylinder(d=STRUT_W*2.5, h=STRUT_TH);

        translate([bx+STRUT_W/2, D + STRUT_L - STRUT_W/2, z+STRUT_TH-PLAY*2])
        translate([-STRUT_HEAD_D, -STRUT_HEAD_D/2-PLAY, 0])
        cube([STRUT_HEAD_D*2, STRUT_HEAD_D*2, STRUT_TH]);
//        cylinder(d=STRUT_W*1.5, h=STRUT_TH);
    }
    
    for (y=[0, STRUT_HEAD_D*2]) {
        translate([-WHEEL_X*2, y , z])
        strut_washer();
    }    
}

strut();

/////////////////////////////////////////////////////////////

color("green") rail();

wheels();

//color("lightblue")
%carriage();