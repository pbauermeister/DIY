use <../chamferer.scad>

L  = 140;
W  =  25;
TH =  10;
M  =   5;
R  =  50;
TH2 = 2;
TH3 = 7;

D1 =  5;
D2 =  9.5;
D3 = 17;

ATOM = 0.01;

CH1 = W / 2 - ATOM;
CH2 = (W-M*2) / 2 - ATOM;

$fn = 64;


difference() {

    //chamferer($preview ? 0 : 1)
    difference() {
        chamferer($preview ? 0 : 1)
        translate([0, -W/2, -TH-TH2-TH3])
        union() {
            chamferer($preview ? 0 : CH1, "cylinder", fn=32)
            cube([L, W, TH2]);
            
            chamferer($preview ? 0 : CH2, "cylinder", fn=32)
            translate([M, M, TH2])
            cube([L-M*2, W-M*2, TH]);        

            chamferer($preview ? 0 : CH1, "cylinder", fn=32)
            translate([0, 0, TH+TH2])
            cube([L, W, TH3]);
        }

        translate([0, 0, -1.5])
        rotate([0, .3, 0])
        for (k=[-1, 1]) {
            y = (-D2/2-2)*k;
            hull() {
                translate([-1, y, TH-D2])
                rotate([0, 90, 0])
                cylinder(d1=D1, d2=D2, h=L+2);

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
     
        translate([L/2-30 + 10, -W, -TH3-ATOM])
        cube([60+6, W*2, TH]);    
    }

    translate([-1, 0, -R-TH-TH2-TH3+1.5])
    rotate([0, 90, 0])
    cylinder(r=R, h=L+2);
}