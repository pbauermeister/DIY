use <../chamferer.scad>

L    = 140          + 15;
W    =  25;
M    =   5    + 3;
R    =  50;

TH2  = 4            +1;
TH   = 10           +1;
TH3  = 10;

HH   =  2.5;

POSX = -20;

D1   =  7       -.4;
D2   =  9.5     -.4;
D3   = 17;

ATOM = 0.01;

CH1 = W / 2 - ATOM;
CH2 = (W-M*2) / 2 - ATOM;

_CH1 = 0;
_CH2 = 0;

$fn = 64/2;
cfn = 32/2;

module holder() {
    difference() {
        difference() {
            union() {
                // body
                chamferer($preview ? 0 : 1)
                translate([0, -W/2, -TH-TH2-TH3])
                union() {
                    // base
                    /*
                    chamferer($preview ? 0 : CH1, "cylinder", fn=cfn)                    
                    translate([-W, 0, 0])
                    cube([L+W*2, W, TH2]);
                    */
                    chamferer($preview ? 0 : CH1, "cylinder", fn=cfn)                    
                    translate([W/2, 0, 0])
                    cube([L-W, W, TH2]);
                    
                    // column
                    chamferer($preview ? 0 : CH2, "cylinder", fn=cfn)
                    translate([M*2, M, TH2])
                    cube([L-M*4, W-M*2, TH+TH2]);        

                    // upper floor
                    if(0)
                    chamferer($preview ? 0 : CH1, "cylinder", fn=cfn)
                    translate([0, 0, TH+TH2])
                    cube([L, W, TH3]);

                    hull() {
                        z = 2;

                        translate([M*2, M, TH+TH2+z]) //TH2+TH-M+z*2])
                        cube([L-M*4, W-M*2, ATOM]);

/*                        translate([0, 0, TH+TH2+z])
                        cube([L, W, ATOM]);

                        translate([0, 0, TH+TH2+TH3])
                        cube([L, W, ATOM]);
*/

                        chamferer($preview ? 0 : CH1/2, "cylinder", fn=cfn)
                        translate([0, 0, TH+TH2+z])
                        cube([L, W, TH3-z]);

                    }
                    
                    // bumps
                    d = W/4;
                    translate([L-d*2-4 + POSX, W/2, TH+TH2+TH3])
                    scale([2, 1, .5])
                    sphere(d=d);

                    translate([d*2 + 24, W/2, TH+TH2+TH3])
                    scale([2, 1.2, .5])
                    sphere(d=d);
                }
                
                /*
                // pillars
                chamferer(3) //$preview ? 0 : 3)
                for (x=[-W*.75, L+W*.75])
                    translate([x, 0, -TH-TH2-TH3])
                    cylinder(d=W/2, h=TH+TH2+TH3/2);
                */
            }

            // probes cavities
            intersection() {
                translate([POSX, 0, -1.5 - .25 -1.25])
                rotate([0, .3, 0])
                for (k=[-1, 1]) {
                    y = (-D2/2-2)*k;
                    hull() {
                        translate([-1, y, TH-D2])
                        rotate([0, 90, 0]) {
                            cylinder(d1=D1, d2=D2, h=L+2);

                            translate([0, 0, L])
                            cylinder(d=D2, h=15);

%                            translate([0, 0, L])
                            cylinder(d=D2, h=15);
                        }

                %        translate([-1, y, TH-D2])
                        rotate([0, 90, 0])
                        cylinder(d1=D1, d2=D2, h=L+2);
                    }
                    translate([L-30, y, TH-D2 +2])
                    rotate([0, 90, 0])
                    cylinder(d=D3, h=6);

            %        translate([L-30, y, TH-D2 +2])
                    rotate([0, 90, 0])
                    cylinder(d=D3, h=6);
                }

                translate([-ATOM, -W, -TH3])
                cube([L+ATOM*2, W*2, TH+TH2+TH3]);
            }
            // center clearance
            translate([L/4-5+10, -W, -TH-TH3])
            cube([L/2-10, W*2, TH+TH2+TH3]);    
        }

        // foot hollowing
        translate([-L/2, -W/2+2, -TH-TH2-TH3 -1+.5])
        cube([L*2, W-4, HH]);

        // screws
        for (x=[W, L/2, L-W])
            translate([x, 0, 0]) {
                cylinder(d=3.5, h=(TH+TH2+TH3)*3, center=true);
                translate([0, 0, -TH-TH2-TH3+1 + 2])
                cylinder(d=8, h=(TH+TH2+TH3));
            }
    }
}

intersection() {
    holder();

//    translate([L*.765, 0, 0]) cube([13, 60, 60], center=true);
}