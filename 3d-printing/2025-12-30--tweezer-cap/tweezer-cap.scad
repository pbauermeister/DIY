use <../chamferer.scad>

D1 =  1.5;
D2 =  2.5;
KH =  3;
M  =  5;

CH =  0.3 * 4;

ST =  1.05;

$fn = 50;

module wpit(l, w, h, k=1) {
    scale([4/w*k, 1.125, 1])
    cylinder(d=w-1, h=l*2, center=true);
}

module cap(l, w, h) {
    dz = l/4;
    
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
                
                wpit(l, w, h);
            }

            // bumps
            for (kz=[-1, 1])
                for (kx=[-1, 1]) translate([kx*(h/2 -.1), 0, kz * (dz)])
                    scale([1, 1, KH*D2/D1])
                    rotate([90, 0, 0]) cylinder(d=D1, h=w*.9, center=true);
        }
        
        // slits
        difference() {
            for (ky=[-1, 1]) translate([0, ky*(w/2 -.4 -ST/2 +.4)])
                cube([h*2, ST, l-M*2], center=true);

            cube([l+w, l+w, M*2], center=true);
        }

        // centering pit
        scale([1, .66, 1])
        cylinder(d=h-.5, h=l*2, center=true);
    }

    // side bumps
    difference() {
        for (kz=[-1, 1])
        for (ky=[-1, 1]) translate([0, ky*(w/2), kz * (dz)])
            scale([2, 1.25, KH])
            rotate([0, 90, 0])
            sphere(d=D2);
        wpit(l, w-1, h, 1.3);
    }
}

//translate([30, 0, 0]) cap(40, 10, 4.5);
cap(55              +5,
    8               +1,
    4.5 + .5        +1
    );
