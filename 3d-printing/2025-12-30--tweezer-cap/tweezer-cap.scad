use <../chamferer.scad>

D1 =  1.5;
D2 =  2.5;
KH =  3;
M  =  5;

CH =  0.3 * 4;

ST =  1.05;

$fn = 50;

module cap(l, w, h) {
    dz = l/2 - M*2.75;
    difference() {
        union() {
            difference() {
                // body
                chamferer(CH, shrink=false)
                cube([h, w, l], center=true);

                // pit
                ch = 2;
                chamferer(ch)
                cube([h, w, l + ch*1.75], center=true);
            }

            // bumps
            for (kz=[-1, 1])
                for (kx=[-1, 1]) translate([kx*(h/2 -.1), 0, kz * dz])
                    scale([1, 1, KH*D2/D1])
                    rotate([90, 0, 0]) cylinder(d=D1, h=w*.9, center=true);
        }
        
        // slits
        for (ky=[-1, 1]) translate([0, ky*(w/2 -.4 -ST/2 +.4)])
            cube([h*2, ST, l-M*2], center=true);

        // centering pit
        scale([1, .66, 1])
        cylinder(d=h-.5, h=l*2, center=true);
    }

    // bumps
    difference() {
        for (kz=[-1, 1])
        for (ky=[-1, 1]) translate([0, ky*(w/2 + .05*3), kz * dz])
            scale([2, 1, KH])
            rotate([0, 90, 0])
            sphere(d=D2);

        // centering pit
        scale([4/w, 1, 1])
        cylinder(d=w-1, h=l*2, center=true);
    }
}

//translate([30, 0, 0]) cap(40, 10, 4.5);
cap(55, 8, 4.5 + .5);
