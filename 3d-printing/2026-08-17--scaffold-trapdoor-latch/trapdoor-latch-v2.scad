use <../hinge4.scad>
D = 35              -0;

X1  =  3            +3;
TH1 = 12;  // board
TH2 = 15  -5;
TH3 = 5;
H1  = 30;
H2  = 80;
W   = 47            +3;

PLAY = .5;
$fn  = 25;
ATOM = 0.01;

module wheel(xd=0, xh=0) {
    h = D*.67+xh;
    resize([D+xd, D+xd, h])
    intersection() {
        sphere(d=D, $fn=100);
        cylinder(d=D, h=h, $fn=100, center=true);
    }
}


z = D*.33 + TH3;
dx = 3.5            +2.55;
da = 12;

module latch() {
    difference() {

        union() {

            %translate([-X1, 0, D/2])
            wheel();

            // wheel holder
            hull() {
                translate([X1, -W/2, 0])
                cube([TH2, W, D]);

                translate([-X1, 0, 0])
                cylinder(d=D*.5, h=D);
            }
            translate([X1, -W/2, -H1+TH2])
            cube([TH2, W, H1-TH2]);
         
            // main hinge
            translate([X1+TH2/2, W/2, -H1]) {
                rotate([90, -90, 0])
                hinge4(thickness=TH2, arm_length=TH2, total_height=W, angle=180,
                       tolerance=.3, nb_layers=9);
                       //nb_layers=2, with_hull=true);
                rotate([90, 0, 0]) cylinder(d=.9, h=W);
            }

            // leg
            translate([X1, -W/2, -H1-H2])
            cube([TH2, W, H2-TH2]);

            // upper hinge
            hull() {
                translate([X1+TH2/2+TH2+dx, W/2, TH2/2])
                rotate([90, 0, 0]) cylinder(d=TH2/2, h=W);

                translate([X1+TH2, -W/2, TH2/4])
                cube([ATOM, W, TH2]);
            }

            // upper arm
            translate([X1+TH2, -W/2, -H1+TH2/2+3.5])
            cube([TH2*.75+dx, W, H1-3.5]);

            // lower hinge
            hull() {
                translate([X1+TH2/2+TH2+dx, W/2, -H1-H1-TH2/2])
                rotate([90, 0, 0]) cylinder(d=TH2/2, h=W);

                translate([X1+TH2, -W/2, -H1-H1-TH2/2-TH2+TH2/4])
                cube([ATOM, W, TH2]);
            }

            // lower arm
            translate([X1+TH2, -W/2, -H2+TH2+TH2/2])
            cube([TH2*.75+dx, W, H1-3.5]);

            // spring cylinders
            D1 = 16;
            D2 = 12;
            D3 =  3;
            L  = 25;
            translate([0, 0, -H1])
            for (kz=[-1, 1])
                scale([1, 1, kz])
                for (k=[-1:1:1]) {
                    difference() {
                        translate([X1+TH2/2+TH2 +2.5, k*(D1+.5), -2])
                        cylinder(d1=D2-2.5, d2=D2, h=11);

                        translate([X1+TH2/2+TH2 +2.5, k*(D1+.5), 0])
                        rotate([0, 0, 90+90*kz])
                        translate([1-D2/2, 0, -10+6])
                        cube([D2, D2, 20], center=true);
                    }
                }
        }

        // wheel cavity
        translate([-X1, 0, D/2])
        scale([1, 1.5, 1])
        wheel(xd=4, xh=PLAY*2);
        
        // wheel axis
        translate([-X1, 0, 0])
        cylinder(d=3, h=D*3, center=true);

        // screw holes
        D1 = 16;
        translate([0, 0, -5])
        for (kz=[1, -1 +.33]) {
            for (ky=[1, -1]) {
                translate([X1+TH2+1, D1*ky, -H1-H2/2 + kz*H2/3.5])
                rotate([0, 90, 0]) {
                    cylinder(d=4, h=TH2*4, center=true);
                    cylinder(d=7.5+6, h=TH2*4);
                }
            }
        }
    }
}

translate([0, 0, $preview ? 0 : W/2]) rotate([$preview ? 0 : -90, 0, 0])
latch();

if (0)
if (!$preview)
translate([-D/2, -D*.75, D*.67/2])
difference() {
    wheel();
    cylinder(d=4, h=D*4, center=true);
}