//use <../chamferer.scad>

D1 = 70.5;
D2 = 71.3;

DIN = 55 +2             +2;

H  = 29;
D  =  9;
N  =  8;

TH =  3                 -1;
ZRECESS = .5;

ATOM = 0.01;
$fn = $preview ? 20 : 150;

// cylinder(R, H), chamfered by ch
module rcylinder(R, h, ch, k0=1, k1=1) {
    hull() {
        indexes = h ? [0, 1] : [0];
        zs = [ch, h-ch];
        ks = [k0, k1];
        for (i=indexes) {
            z = zs[i];
            k = ks[i];
            translate([0, 0, z])
            rotate_extrude(convexity=10, $fn=$fn)
            translate([R*k-ch, 0, 0])
            circle(r=ch);
        }
    }
}

module bottle(h, th=0, dinset=0) {
    difference() {
        // bottle bottom-half
        hull() {
            // top
            translate([0, 0, h-TH])
            rcylinder(D2/2+th, 0, TH/2);

            // bottom
            k = 1.75;
            translate([0, 0, D*k])
            scale([1, 1, k])
            rotate_extrude(convexity=10, $fn=$fn)
            translate([D2/2-D, 0, 0])
            circle(r=D+th);
        }

        // insets
        inset = D*1 + 3.5 + dinset;
        for(i=[0:N-1])
            rotate([0, 0, i*360/N])
            translate([0, D2/2 - inset, 0])
            rotate([-45, 0, 0])
            scale([1, .5, 1])
            rotate([0, 0, 45]) {
                cube(D*10);
                //%if (i==0) cube(D*10);
            }

        // shave top
        translate([0, 0, h])
        cylinder(d=D2*2, h=D*2);
    }
}

//!bottle();

module basis() {
    d = D2+TH*2;
    intersection() {
        bottle(h=H+TH/2, th=TH, dinset=-D1);        
        cylinder(d=d*2, h=H+TH);
    }
}

module shape() {
    // body
    basis();
    
    // 3 feet
    d = D2/4;
    for (a=[0:120:360-120])
        rotate([0, 0, a])
        translate([D2/2-d/2 + TH, 0, 0])
        scale([1, 1.67, 1])
        rcylinder(d/2, H*.33, TH/2, 1.2, .9);
}

module foot() {
    // inner collar
    difference() {
        h = 2;
        translate([0, 0, H-h])
        cylinder(d=D2+TH/2, h=h);

        translate([0, 0, H-h])
        cylinder(d=D1, h=h*4, center=true);
    }
    
    difference() {
        // full shell
        translate([0, 0, -TH/2]) shape();

        // cavity
        bottle(h=H*2, dinset=0);
        
        // bottom hollowing
        cylinder(d=DIN, h=H*2, center=true);
    }
}


difference() {
    foot();

    //if ($preview)
    rotate([0, 0, -15])
    translate([0, 0, -250]) cube(500);
}

//%bottle(h=H*2);
