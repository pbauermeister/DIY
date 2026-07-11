use <../chamferer.scad>

//                              Not yet re-printed
LENGTH = 260;
WIDTH  = 110                    +0.5 +.7;
HEIGHT =  20;
DEPTH  =  20                    -0;

TH     =   3;

GW     =  15;
GH     =  10;
GL     = LENGTH -TH*2           -30;
GZ     =  10                    *0;

ATOM = 0.03;


module basis() {
    hull() {
        cube([LENGTH, WIDTH, HEIGHT]);

        translate([-HEIGHT, 0, HEIGHT])
        cube([LENGTH, WIDTH, ATOM]);
    }
}

module tray() {
    chamferer($preview? 0 : TH*.499) {
        difference() {
            chamferer(TH, "plate-z", shrink=false) {
                basis();
                hull() {
                    cube([LENGTH, 14/2, ATOM]);
                    translate([0, 0, -DEPTH]) cube([LENGTH, ATOM, ATOM]);
                }
            }
            
            translate([0, 0, TH+ATOM]) basis();
        }

        translate([LENGTH-GL, -GW-TH, HEIGHT+GZ]) {
            difference() {
                chamferer(TH, "cube", shrink=false)
                translate([0, 0, TH])
                cube([GL, GW, GH-TH]);

                translate([-GL/2, 0, -ATOM])
                cube([GL*2, GW, GH+ATOM]);
            }
            
            translate([-TH, GW, -GZ])
            cube([GL+TH*2, TH, GZ]);
        }
    }
}

rotate([0, 90, 0])
intersection() {
    tray();
    //cube(250, center=true);
}