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

module body(l, w, h, gripper=false) {
    chamferer(CH, shrink=false)
    cube([h, w, l], center=true);
    
    if (gripper) {
        k = sqrt(2);
        th = l/10;
        for (z=[0:l/10*.80:l/2 *.80])
            for (kz=[-1, 1])
                translate([0, 0, kz*z])
                scale([k, k, k])
                resize([h, w, th])
                sphere(1);
    }
}

module cap(l, w, h) {
    dz = l/4;
    
    difference() {
        union() {
            difference() {
                // body
                body(l, w, h, true);

                // pit
                ch = 2;
                chamferer(ch)
                cube([h, w, l + ch*1.75], center=true);
                
                if (0) wpit(l, w, h);
            }

            // bumps
            intersection() {
                for (kz=[-1, 1])
                    for (kx=[-1, 1])
                        translate([kx*(h/2 -.1), 0, kz * (dz *1.49)])
                        scale([1+2, 1, KH*D2/D1])
                        rotate([90, 0, 0]) cylinder(d=D1, h=w*.9, center=true);
                body(l, w, h);
            }
        }
        
        // slits
        py = w/2 -.4 -ST/2 +.4;
        difference() {
            for (ky=[-1, 1]) translate([0, ky*py])
                cube([h*2, ST, l-M*2], center=true);

            cube([l+w, l+w, M*2], center=true);
        }

        for (ky=[-1, 1])
        translate([0, 0, ky*(l/2-M)])
        cube([h*2, w, 0.3], center=true);

        // centering pit
        if (0)
        scale([1, .66, 1])
        cylinder(d=h-.5, h=l*2, center=true);
    }

    // side bumps
    intersection() {
        for (kz=[-1, 1])
        for (ky=[-1, 1]) translate([0, ky*(w/2), kz * (dz)])
            scale([2, 1.25, KH])
            rotate([0, 90, 0])
            cylinder(d=D2, h= D2, center=true);
        body(l, w, h);
    }
}

//translate([30, 0, 0]) cap(40, 10, 4.5);
cap(55              +5  + 10,
    8               +1  -  0,
    4.5 + .5        +1  +  1.5
    );
