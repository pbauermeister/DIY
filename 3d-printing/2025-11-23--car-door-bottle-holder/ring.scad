D       =  88;
H1      =   2               +1.5;
TH      =   2.5;
H2      =  23       -5;
TH2     = TH+.5     +0.5;
OPENING =  64;
ATOM    =   0.01;
A       = 130;
N       =   8;

DH      = H2-H1;

$fn = $preview ? 50 : 80;

module hollowing() {
    // inside
    cylinder(r=D/2, h=H2*3, center=true);

    // curved inside
    translate([0, 0, -ATOM])
    cylinder(r1=D/2+TH, r2=D/2, h=DH/2+ATOM);    
    translate([0, 0, H2-DH/2])
    cylinder(r2=D/2+TH, r1=D/2, h=DH/2+ATOM);    
}

difference() {
    cylinder(r=D/2+TH2, h=H2);
    hollowing();

    // side cut
    translate([0, 0, -H2/2])
    hull() for (a= [-A,A])
    rotate([0, 0, a])
    cube([D*2, ATOM, H2*2]);
}

step = A*2/8;
dr = 5 + 2 + 7;
k = dr/H2;
difference() {
    union() {
        // ends
        intersection() {
            for (a= [-A,A]) rotate([0, 0, a]) hull() {
                translate([0, 0, H2/2])
                sphere(d=H2);
                
                translate([D/2+TH2, 0, H2/2])
                sphere(d=H2);
            }
            cylinder(r=D/2+TH2, h=H2*3, center=true);
        }

        d = H2/2.75;
        for (a= [-A:step:A]) rotate([0, 0, a]) hull() {
            translate([0, 0, H2/2])
            scale([k, 1.1, 1.1])
            sphere(d=d);
            
            translate([D/2+TH2, 0, H2/2]) {
                scale([k, 1.1, 1.1])
                sphere(d=d);
            }
        }

    }    
    hollowing();
}