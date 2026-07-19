use <../chamferer.scad>

D = 40;
N = 7;
W = 140;
Z = -2;
TH = 10;

K1 = 1.65;
K2 = K1 * 0.49;

module row(k=K1, dn=0, fn=200) {
    for (i=[-dn:N-1]) {
        translate([D*(i-N/2+.5), 0, 0])
        rotate([-90, 0, 0]) {
            cylinder(d=D*k, h=W*2, center=true, $fn=fn);
        }
    }
}

module stacker() {
    difference() {
        chamferer(2)
        cube([D*N, W, TH], center=true);

        translate([0, 0, D*K2])
        row();

        translate([D/2, 0, -D*K2])
        row(dn=1);
        
        
        %translate([0, 0, D/2])
        row(k=1, fn=200);

        %translate([D/2, 0, -D/2*2*1.05])
        row(k=2, fn=200, dn=1);
    }
}

rotate([90, 0, 0])
stacker();