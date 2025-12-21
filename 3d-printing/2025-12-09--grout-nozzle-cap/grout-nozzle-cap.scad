
D_IN = 12;
H    = 30;
TH   =  0.75;

$fn = 100;

module cap() {
    difference() {
        union() {
            cylinder(d=D_IN + TH*2, h=H+TH);

            if(0)
            translate([0, 0, H/2-D_IN/2])
            rotate([90, 0, 0])
            cylinder(d=H+TH+D_IN, h=3, center=true);

            cube([D_IN*1.5, 2, H*2], center=true);
        }

        translate([0, 0, -D_IN/2])
        cylinder(d=D_IN, h=H);

        translate([0, 0, H - D_IN/2])
        sphere(d=D_IN);

        translate([0, 0, -H*2])
        cylinder(r=D_IN*2, h=H*2);
    }
}

cap();