
HOLE_DIAMETER = 0.4 + .5;
THICKNESS = 1.8;
THICKNESS2 = 1.4;

D2 = 4.5;
D1 = 2.2;
LENGTH = 20;

MARGIN = .17 * 2;
ATOM = .001;

$fn = $preview ? 12 : 60;

module channel(r) {
    intersection() {
        translate([0, 0, -r+THICKNESS - HOLE_DIAMETER/2*0])
        rotate([90, 0, 0])
        rotate_extrude(convexity = 10, $fn = 100)
        translate([r, 0, 0])
        scale([1.5, 1, 1])
        rotate([0, 0, 45])
        circle(d=HOLE_DIAMETER + MARGIN, $fn=4);

        cube([LENGTH + D2/2, D2*1.5, THICKNESS*3], center=true);        
    }
}

module head() {
    rotate([180, 0, 0])
    difference() {
        union() {
            d = 8; //D2*1.5;
            z = THICKNESS - THICKNESS2;
            cylinder(d=10, h=THICKNESS);
            translate([0, 0, THICKNESS2/2+z])
            cube([LENGTH, d, THICKNESS2], center=true);
            
            translate([-LENGTH/2, 0, z]) cylinder(d=d, h=THICKNESS2);
            translate([LENGTH/2, 0, z]) cylinder(d=d, h=THICKNESS2);
        }
        translate([0, 0, -ATOM])
        cylinder(d1=D1 + MARGIN*2, d2=D2 + MARGIN*2, h=THICKNESS + ATOM*2);
        
        channel(50);
        channel(35);
    }
}

for (y=[0:3])
    translate([0, y*D2*2.5, 0])
    head();
