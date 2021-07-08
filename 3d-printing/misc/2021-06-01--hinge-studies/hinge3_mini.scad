$fn                    = 45;
ATOM                   =  0.001;

TOLERANCE      =  .3; //0.4;
THICKNESS      =  2.5;
HINGE2M_LAYER_HEIGHT   =  4.5;
HINGE2M_NB_LAYERS      =  5*0 +3;
HINGE2M_LINE_THICKNESS =  0.84;
HINGE2M_WALL_THICKNESS =  0.75;
HINGE2M_SUPPORT_D      =  0.25;


LENGTH = 15;

K = 1;
H0 = .5;
H2 = .2;
H1 = 1 * K + H2*2;
H3 = 1.5;  // must yield angle that can be printed w/o support
ANGLE = atan(H3/(TOLERANCE+THICKNESS));

HEIGHT = H1+H2+H3 + 2*H1 +H2+H3+H1;
PLAY = .15;
WALL = .42;
R = THICKNESS/2 - WALL;
echo("HEIGHT=", HEIGHT);
echo("ANGLE=", ANGLE);
echo("AXIS=", (R-PLAY)*2);

module hingelet() {
    translate([0, 0, H0])
    union() {
        difference() {
            translate([0, 0, -H0])
            union() {
                translate([0, -THICKNESS/2+ATOM, 0])
                cube([LENGTH/2, THICKNESS -ATOM*2, HEIGHT]);
                
                cylinder(d=THICKNESS, h=HEIGHT);
            }

            // lower cut - straight
            translate([-THICKNESS/2, -THICKNESS/2, -H0 -ATOM])
            cube([THICKNESS+TOLERANCE, THICKNESS, H1+H2+H0 +ATOM]);

            // lower cut - slanted up
            translate([THICKNESS+TOLERANCE-THICKNESS/2, 0, H1+H2])
            rotate([0, ANGLE, 0])
            translate([-THICKNESS*2-TOLERANCE, -THICKNESS/2, -H1])
            cube([THICKNESS*2+TOLERANCE, THICKNESS, H1]);
            
            // upper cut - straight
            translate([-THICKNESS/2, -THICKNESS/2, H1+H2+H3+2*H1])
            cube([THICKNESS+TOLERANCE, THICKNESS, H2+H3+H1 +ATOM]);

            // hole
            translate([0, 0, H1+H2+H3+2*H1+H2+H3/2 - (R-PLAY)*3])
            cylinder(r=R, h=R*4);
        }
        translate([0, 0, H1+H2+H3/2])
        scale([1, 1, 3])
        sphere(r=R-PLAY);
    }

    translate([0, 0, H0])
    union() {
        difference() {
            translate([0, 0, -H0])
            union() {
                translate([-LENGTH/2, -THICKNESS/2 +ATOM, 0])
                cube([LENGTH/2, THICKNESS -ATOM*2, HEIGHT]);
                
                cylinder(d=THICKNESS, h=HEIGHT);            
            }
            
            // med cut - straight
            translate([-THICKNESS/2-TOLERANCE, -THICKNESS/2, H1])
            cube([THICKNESS+TOLERANCE, THICKNESS, H2+H3+2*H1+H2]);

            // med cut - slanted up
            translate([-THICKNESS/2-TOLERANCE, -THICKNESS/2, H1+H2+H3+2*H1+H2])
            rotate([0, -ANGLE, 0])
            translate([0, 0, -H1])
            cube([THICKNESS*2+TOLERANCE, THICKNESS, H1]);

            // hole
            translate([0, 0, H1+H2+H3/2 - (R-PLAY)*3])
            cylinder(r=R, h=R*3);

        }
        intersection() {
            translate([0, 0, H1+H2+H3+2*H1+H2+H3/2])
            scale([1, 1, 3])
            sphere(r=R-PLAY);
            cylinder(d=THICKNESS, h=HEIGHT-H0);
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
    //translate([-LENGTH/2, 0, 0]) cube([LENGTH, LENGTH, HEIGHT*100]);
}