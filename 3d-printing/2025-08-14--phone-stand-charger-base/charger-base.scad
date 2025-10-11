use <../chamferer.scad>

W  =  56.5;
D  = 102.5;
TH =   1.5;
H1 =  27.0;
H2 = H1 + 3;
H3 =  22.0;
TB =   0.75;

CH =   0.75;

D_CHAMBER = D*.75;
D_EXT = D + TH*2;

ATOM = 0.01;

module base() {
    difference() {
        // body
        d_ext = D_EXT;
        chamferer($preview?0:CH, "cone", fn=$preview?4:10)
        cylinder(d=d_ext, h=H2, $fn=$preview?100:200);

        // create top border
        translate([0, 0, H2-TB])
        cylinder(d=D, h=H2, $fn=$preview?100:200);

        // charger case
        d_int = D - TH*2;
        dy = sqrt(d_int*d_int/4 - W*W/4);
        translate([-W/2, -dy, -ATOM])
        cube([W, D, H1]);

        // chamber
        d_chamber = D*.8;
        translate([0, 0, -ATOM])
        cylinder(d=D_CHAMBER, h=H1+ATOM, $fn=$preview?100:200);

        // bottom chamber chamfer
        translate([0, 0, -H1])
        chamferer($preview?0:CH, "cone", fn=$preview?4:10, shrink=false)
        cylinder(d=D_CHAMBER, h=H1, $fn=$preview?100:200);

        // bottom cavity chamfer
        chamferer($preview?0:CH, "cone", fn=$preview?4:10, shrink=false)
        translate([-W/2, -dy, -H1])
        cube([W, D, H1]);

        // cable
        z = 4;
        translate([-10, -D, z])
       cube([20, D*2, H3-z]); 
    }

    // pads
    d = (D_EXT + D_CHAMBER*2)/3;
    dy = sqrt(d*d/4 - W*W/4);
    for (ky=[-1, 1]) {
        for (kx=[-1, 1]) {
            translate([W/2*kx, dy*ky, 0])
            scale([.25, 1, 1,]) hull() {
                translate([0, 0, H1-5])
                sphere(d=2, $fn=50);
                translate([0, 0, 5])
                sphere(d=2, $fn=50);
            }
        }
    }
}

base();