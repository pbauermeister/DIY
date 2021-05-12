$fn       = 30;
ALPHA     = 20;
TOLERANCE = .15; // .2
R1        = 1;
R2        = 2 -.2;
L         = 4 - .2;
T         = .7;

ATOM = 0.0001;

module piece0(extra=false, o=true, c=true) {
    tol = extra ? TOLERANCE : 0;

    translate([0, 0, -tol])
    scale([1, 1, extra ? 2 : 1]) {
        if(o) cylinder(r=R1 + tol, h=1);
        if(c) translate([L, 0, 0]) cylinder(r=R2 + tol, h=1);
        translate([0, -T/2 - tol, 0]) cube([L, T + tol*2, 1]);
    }
}

module piece1(o=true, c=true) {
    scale([1, 1, 10])
    difference() {
        piece0(o=o, c=c);
        
        translate([L, 0, 0]) piece0();
        for (a=[-ALPHA: 10: ALPHA]) {
            translate([L, 0, 0]) rotate([0, 0,  a]) piece0(true);
        }

    }
}


translate([-R2*3 +R2, -R1/2, 0])
cube([R2*3, R1, 10]);

translate([(L+R2)*5 -R2*2, -R1/2, 0])
cube([R2*3, R1, 10]);

for (i=[0:6]) {
    translate([L*i, 0, 0]) piece1(o=i>0, c=i<6);
}