/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

K1 = 54.1 / 54;
K2 = 54.2 / 54;
//K3 = 54.3 / 54;
K3 = 54.8 / 54;

ATOM = 0.001;

SHIFT_X = 2.2;
N = 50;
HEIGHT = 10.2;

TOLERANCE = 0.15*2;

////////////////////////////////////////////////////////////////////////////////
// Helpers

module my_scale(k) {
    scale([k, k, 1])   
    translate([-30, -30, 0])
    children();
}

module layer(fname, thickness, altitude) {
    translate([0, 0, altitude])
    linear_extrude(height=thickness+ATOM)
    scale([10, 10, 1])
    import(fname);
}

////////////////////////////////////////////////////////////////////////////////

intersection(){
    my_scale(1) layer("3-clipless.dxf", 1.4, 0);
    scale([1,1,100]) cylinder(r=35, true);
}
