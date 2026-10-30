D   =  80;
TH  =   3;
GAP =   5;
PCENT = 15;

$fn = 100;
dh = D * PCENT/100;

difference() {
    union() {
        difference() {
            sphere(d=D);
            sphere(d=D-TH);

            translate([0, 0, -D/2])
            cylinder(d=D, h=D * PCENT/100);

            translate([0, 0, D/2 - dh])
            cylinder(d=D, h=dh);
        }
        
        translate([0, 0, -D/2+dh])
        cylinder(d=D*1.2, h=.5);
    }
    
    for (a=[0:3])
        rotate([0, 0, a*90])
        cube([GAP, D*2, D*2], center=true);
    
    cylinder(d=D*.68, h=D*2, center=true);
}


for (a=[0:3]) {
    rotate([0, 0, a*90 + 45])
    translate([-4, -D*.55, -D/2+dh+1]) {
        linear_extrude(.75)
        text(str(a));
    }
}