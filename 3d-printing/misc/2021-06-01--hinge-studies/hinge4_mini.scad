/*
3D printed hinge, as thin as possible, vertically oriented.
  _________     ___:______________
           |   |   :
    h1     |   |   :
  _ __ _   |   |___:_______
    h2     |       :       |
  _ __ _   |_______:___    |
                   :   |   |
                   :   |   |
    h1*2           :   |   |
                   :   |   |
                   :   |   |
  _ __ _    _______:___|   |
    h2     |       :       |
  _ __ _   |    ___:_______|
           |   |   :
    h1     |   |   :
  _________|   |___:______________
                   :
*/

$fn         = 45 *2;

ATOM        = 0.001;
TOLERANCE   =  .4   +.2;
THICKNESS   =  4.5; //4.2;
THICKNESS2  =  2;
LENGTH      = 20;

H0          =  .2;
H2          =  1.3;  // if too small, layer may overlap and fill hole of below layer
H1          =  2.5;

HEIGHT      =  H1+H2 + 2*H1 +H2+H1;
WALL        =  0.42;

PLAY        =  0.45 +.15*2 -.2    + 0.25;
R           =  THICKNESS/2        - 1.25;
KK          =  2;

echo("HEIGHT=", HEIGHT);

module hingelet() {
    translate([-WALL/2, -THICKNESS/5, 0])
    cube([WALL, THICKNESS/2.5, HEIGHT]);

    dy = THICKNESS - THICKNESS2*2;

    cylinder(r=.1, h=HEIGHT);
    translate([0, 0, H0])
    union() {
        difference() {
            translate([0, 0, -H0])
            union() {
                hull() {
                    cylinder(d=THICKNESS, h=HEIGHT);

                    if(0) translate([0, THICKNESS/2-THICKNESS2*2 -dy, 0])
                    cube([THICKNESS, THICKNESS2, HEIGHT]);
                }
                translate([0, THICKNESS/2-THICKNESS2*2 -dy, 0])
                cube([LENGTH/2, THICKNESS2, HEIGHT]);
            }

            // lower cut - straight
            translate([-THICKNESS/2, -THICKNESS/2, -H0 -ATOM])
            cube([THICKNESS+TOLERANCE, THICKNESS, H1+H2+H0 +ATOM]);

            // lower cut - slanted up
            translate([THICKNESS+TOLERANCE-THICKNESS/2, 0, H1+H2])
            translate([-THICKNESS*2-TOLERANCE, -THICKNESS/2, -H1])
            cube([THICKNESS*2+TOLERANCE, THICKNESS, H1]);
            
            // upper cut - straight
            translate([-THICKNESS/2, -THICKNESS/2, H1+H2+2*H1])
            cube([THICKNESS+TOLERANCE, THICKNESS, H2+H1 +ATOM]);

            // hole
            if(0)
            translate([0, 0, H1+H2+2*H1+H2])
            scale([1, 1, KK])
            sphere(r=R+PLAY);
            
            translate([0, 0, H1+H2+2*H1+H2 - (R+PLAY)*KK])
            cylinder(r=R+PLAY, h=(R+PLAY)*KK);
        }

        // pin
        translate([0, 0, H1+H2]) {
            difference() {
                union() {
                    translate([0, 0, -PLAY*1.5])
                    scale([1, 1, KK])
                    sphere(r=R);

                    translate([0, 0, -THICKNESS/4])
                    cylinder(r1=R, d2=THICKNESS, h=THICKNESS/4);
                }
                cylinder(r=R, h=KK*R);
            }
        }
    }

    rotate([0, 0, 180])
    translate([0, 0, H0])
    union() {
        difference() {
            translate([0, 0, -H0])
            union() {
                hull() {
                    cylinder(d=THICKNESS, h=HEIGHT);

                    if(0) translate([-THICKNESS, THICKNESS/2-THICKNESS2*2 -dy, 0])
                    cube([THICKNESS, THICKNESS2, HEIGHT]);
                }
                translate([-LENGTH/2, THICKNESS/2-THICKNESS2*2 -dy, 0])
                cube([LENGTH/2, THICKNESS2, HEIGHT]);
            }
            
            // med cut - straight
            translate([-THICKNESS/2-TOLERANCE, -THICKNESS/2, H1])
            cube([THICKNESS+TOLERANCE, THICKNESS, H2+2*H1+H2]);

            // med cut - slanted up
            translate([-THICKNESS/2-TOLERANCE, -THICKNESS/2, H1+H2+2*H1+H2])
            translate([0, 0, -H1])
            cube([THICKNESS*2+TOLERANCE, THICKNESS, H1]);

            // hole
            if(0)
            translate([0, 0, H1+H2])
            scale([1, 1, KK])
            sphere(r=R+PLAY);

            translate([0, 0, H1+H2 - (R+PLAY)*KK])
            cylinder(r=R+PLAY, h=(R+PLAY)*KK);
        }

        // pin
        translate([0, 0, H1+H2+2*H1+H2]) {
            difference() {
                union() {
                    translate([0, 0, -PLAY*1.5])
                    scale([1, 1, KK])
                    sphere(r=R);

                    translate([0, 0, -THICKNESS/4])
                    cylinder(r1=R, d2=THICKNESS, h=THICKNESS/4);
                }
                cylinder(r=R, h=KK*R);
            }
        }
    }
}

module hinge(layers=3) {
    for (i=[1:layers]) {
        translate([0, 0, (i-1) * HEIGHT])
        hingelet();
    }
}

difference() {
    hinge();
    if ($preview) translate([-LENGTH/2, 0, 0]) cube([LENGTH, LENGTH, HEIGHT*100]);
}