use <../chamferer.scad>

H = 12.5;
XH = 8;
D = 12.5;
G = 4-1;
G2 = 4;
CW = 10.5;
CH = 4;

SD = 3.5;
SHD = 7.5;

ATOM = 0.01;
$fn = 100;

module stopper() {
    difference() {
        chamferer(CH, "octahedron")
        translate([-CH+1, -38/2, -G])
        cube([35+CH, 38, H + XH + G]);

        // back
        translate([-50, -25, -25])
        cube(50);

        // axis
        hull() {
            translate([-D, 0, -G-1])
            cylinder(d=D, G+2);

            translate([12, 0, -G-1])
            cylinder(d=D, G+2);
        }
        %translate([12, 0, -G-1])
        cylinder(d=D, G+2);
        
        // h screw
        translate([0, 0, H/2])
        rotate([0, 90, 0])
        cylinder(d=SD, h=50);
        translate([21+4+2.5, 0, H/2])
        sphere(d=SHD);

        translate([21+4+2.5, 0, H/2])
        rotate([0, 90, 0])
        cylinder(d=SHD, h=50);

        // v screw
        translate([SD*1.5, 0, 0]) {
            translate([0, 0, H/2])
            cylinder(d=SD, h=50);

            //translate([0, 0, H+3]) cylinder(d=SHD, h=50);
            translate([0, 0, H +XH -2.5]) {
                sphere(d=SHD);
                cylinder(d=SHD, h=50);
            }
            
        }

        // central
        translate([-ATOM, -CW/2, 0])
        cube([22, CW, H]);

        // arms
        AW = 8;
        translate([-ATOM, CW/2-ATOM-.5 -.2, G2])
        cube([50, AW, 20]);
        translate([-ATOM, -AW -CW/2+ATOM +.5+.2, G2])
        cube([50, AW, 20]);


        // plate
        translate([-ATOM, -24.5/2, 0])
        cube([22, 24.5, H]);
    }
}

difference() {
//    rotate([0, $preview ? 0 : 90, 0])
    rotate([$preview ? 0 : 90, 0, 0])
    stopper();
//    if ($preview) translate([-500, 0, -500]) cube(1000);
}