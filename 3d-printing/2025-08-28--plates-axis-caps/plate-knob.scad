use <../chamferer.scad>

D1 = 38;
D2 = 33;
D3 = 60 + 12;
D4 = 23;
D5 = 38;

H1 =  5.5;
H2 = 17.2;
H3 = 22     -2;

CH =  2.5;

$fn = $preview ? 30 : 200;
ATOM = 0.01;

difference() {
    chamferer($preview?0:CH, "cone")
    difference() {
        intersection() {
            cylinder(d=D3, h=H3);

            r = D3*1.75;
            translate([0, 0, -r+H3])
            sphere(r=r);
        }
        
        for (a=[0, 90, 180, 270])
            rotate([0, 0, a])
            translate([D2*1.7, 0, 0])
            cylinder(d=D2*2.05, h=H3*3, center=true);
    }

    //cylinder(d=D2, h=H2);

    cylinder(d=D4, h=H2*2);
    translate([0, 0, -ATOM]) cylinder(d=D5, h=H1+ATOM);
    scale([1, 1, .9]) translate([0, 0, H1]) sphere(d=D5);

/*
    // inner hollowings
    for (a=[0, 90, 180, 270])
        rotate([0, 0, a+45])
        translate([D2*.76, 0, D2*.27])
        sphere(d=D2*.37, $fn=8);
*/

   if ($preview) cube(1000);
}