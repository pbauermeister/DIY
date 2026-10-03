use <../chamferer.scad>

D1 = 70.5;
D2 = 71.3;

DIN = 55 +2;

H  = 29;
D  =  9;
N  =  8;

TH =  3;
ZRECESS = .5;

ATOM = 0.01;
$fn = $preview ? 20 : 150;


module bottle(th=0, dinset=0) {
    difference() {
        hull() {
            translate([0, 0, H*2])
            cylinder(d=D2+th*2, h=ATOM);

            k = 1.75;
            translate([0, 0, D*k])
            scale([1, 1, k])
            rotate_extrude(convexity=10, $fn=$fn)
            translate([D2/2-D, 0, 0])
            circle(r=D+th);
        }
        
        inset = D*1 + 3.5 + dinset;
        for(i=[0:N-1])
            rotate([0, 0, i*360/N])
            translate([0, D2/2 - inset, 0])
            rotate([-45, 0, 0])
            scale([1, .5, 1])
            rotate([0, 0, 45]) {
                cube(D*10);
                %if (i==0) cube(D*10);
            }
    }
}

//!bottle();

module basis() {
    d = D2+TH*2;
    if(0)
    translate([0, 0, -TH])
    cylinder(d=d, h=H+TH);

    intersection() {
        //translate([0, 0, -TH])
        cylinder(d=d*2, h=H+TH);
        
        bottle(th=TH, dinset=-D1);
    }
}

module shape() {

    basis();

    d2 = D2 / 1.1;

    hull()
    for (kz=[[1, 0], [.90, TH*3]]) {
        k = kz[0]; z = kz[1];
        translate([0, 0, z])
        scale([k, k, 1])
        intersection() {
            hull() for (a=[-10, 10])
                rotate([0, 0, a])
                translate([-d2/2, -d2/2, -TH])
                cube([d2, d2, TH*2]);
            cylinder(d=D2*1.2, h=TH*4, center=true);
        }
    }
}

module foot() {
    
    // collar
    difference() {
        h = 2;
        translate([0, 0, H-2])
        cylinder(d=D2+TH/2, h=h);

        translate([0, 0, H-2])
        cylinder(d=D1, h=h*4, center=true);
    }
    
    difference() {
        chamferer($preview? 0 : TH/2, "cone")
        difference() {
            shape();

            translate([0, 0, -TH*2 +ZRECESS])
            scale([.85, .85, -1]) {
                shape();
                //%shape();
            }
        }

        bottle(dinset=0);
        cylinder(d=DIN, h=H*2, center=true);
    }
}


difference() {
    foot();

    if ($preview) translate([0, 0, -250]) cube(500);
}
%bottle();
