include <constants.scad>

W = 227     +1.0;
H = 103     -0.3;
TH1 = 2;
TH2 = 5;

TTH = .8;

ATOM = 0.01;

D  = 10;
SP = 5;

function get_holes_d_sp() = [D, SP];

module hole(extent=0) {  
    intersection() {
        union() {
            // narrow entry
            translate([-D/2, -D/2, -extent])
            cube([D, D, TH2*4], center=!true);

            // conical chamber
            z = 1;
            translate([0, 0, z])
            hull() {
                translate([-D/2, -D/2, 0])
                cube([D, D, TH2*4]);

                translate([-D, -D, D])
                cube([D*2, D*2, TH2*4]);
            }
        }

        translate([0, 0, -TTH])
        cylinder(d=D*2, h=TH2);        
    }
}

module holes() {
    nx = floor(W / (D+SP))-1;
    ny = floor(H / (D+SP));

    for (i=[-nx/2+.5:nx/2-.5]) {
        for (j=[-ny/2+.5:ny/2-.5]) {
            translate([(i)*(D+SP)-W/2*0, j*(D+SP)+H/2, 0]) {
                hole(ATOM);
            }
        }
    }
}

module side_plate() {
    difference() {
        translate([-W/2, 0, 0])
        intersection() {
            hull() {
                translate([0, 0, TH2])
                cube([W, H, ATOM]);

                translate([TH2, TH2*0, 0])
                cube([W-TH2*2, H-TH2*1, ATOM]);
            }
            
            // unsharpen edges
            translate([TH1, 0, 0])
            cube([W-TH1*2, H-TH1*1, TH2*2]);
        }

        holes();
    }
}


difference() {
    side_plate();

    //translate([-W/2 + 24, 22, -1]) cube([W, H, TH2*2]);
}