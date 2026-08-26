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
$fn = 25;


module wheel(xd=0, xh=0) {
    h = D*.67+xh;
    resize([D+xd, D+xd, h])
    intersection() {
        sphere(d=D, $fn=100);
        cylinder(d=D, h=h, $fn=100, center=true);
    }
}


z = D*.33 + TH3;
dx = 3.5;
da = 12;

module latch() {
    difference() {

        union() {

            %translate([-X1, 0, D/2])
            wheel();

            // wheel holder
            hull() {
                translate([0-D/6, -W/2, 0])
                cube([TH2+X1+D/6, W, D]);

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
            translate([X1+TH2/2+TH2+dx, W/2, TH2/2]) {
                rotate([90, -135-da, 0])
                hinge4(thickness=TH2/2, arm_length=TH2+dx*2, total_height=W, angle=135-da,
                       tolerance=.3, nb_layers=7);
                       //nb_layers=2, with_hull=true);

                rotate([90, -135-45, 0])
                hinge4(thickness=TH2/2, arm_length=TH2+dx, total_height=W,
                       tolerance=.3, nb_layers=7, angle=135-45);

                rotate([90, 0, 0]) cylinder(d=.9, h=W);
            }

            // upper arm
            h1 = H1-TH2/2;
            translate([X1+TH2/2+TH2-TH2/4 +dx, -W/2, -h1])
            cube([TH2/2, W, h1]);

            // lower hinge
            translate([X1+TH2/2+TH2+dx, W/2, -H1-H1-TH2/2]) {
                rotate([90, 135+da, 0])
                hinge4(thickness=TH2/2, arm_length=TH2+dx, total_height=W, angle=225+da,
                       tolerance=.3, nb_layers=7);
                       //nb_layers=2, with_hull=true);

                rotate([90, 135+45, 0])
                hinge4(thickness=TH2/2, arm_length=TH2+dx, total_height=W,
                       tolerance=.3, nb_layers=7, angle=225+45);

                rotate([90, 0, 0]) cylinder(d=.9, h=W);
            }

            // lower arm
            h2 = h1; //H2-TH2/2*0 + TH2/2;
            translate([X1+TH2/2+TH2-TH2/4 +dx, -W/2, -TH2-h1-h2])
            cube([TH2/2, W, h1]);
        }

        // wheel cavity
        translate([-X1, 0, D/2])
        scale([1, 1.5, 1])
        wheel(xd=4, xh=PLAY*2);
        
        // wheel axis
        translate([-X1, 0, 0])
        cylinder(d=3, h=D*3, center=true);
        
        // spring cavities
        D1 = 16;
        D2 = 12;
        D3 =  3;
        L  = 25;
        for (k=[-1:1:1])
        translate([X1+TH2/2+TH2 +dx, k*D1, -H1]) {
            cylinder(d=D3, h=L+TH2*2.5, center=true);
        
            difference() {
                cylinder(d=D1+1, h=L, center=true);
                cylinder(d=D2, h=L*2, center=true);
            }
        }
        
        // screw holes
        translate([0, 0, -5])
        for (kz=[1, -1]) {
            for (ky=[1, -1]) {
                translate([X1+TH2+1, D1*ky, -H1-H2/2 + kz*H2/3.5])
                rotate([0, 90, 0]) {
                    cylinder(d=4, h=TH2*4, center=true);
                    cylinder(d=7.5, h=TH2*4);
                }
            }
        }
    }
}

translate([0, 0, $preview ? 0 : W/2]) rotate([$preview ? 0 : -90, 0, 0])
latch();

if (!$preview)
translate([-D/2, -D*.75, D*.67/2])
difference() {
    wheel();
    cylinder(d=4, h=D*4, center=true);
}