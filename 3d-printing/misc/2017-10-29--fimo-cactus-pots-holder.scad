// Density: Draft
// Fill: 100%
$fn = 90;

DIAMETER1 = 12;
DIAMETER2 = 14.5;

HEIGHT = 2.5;

BORDER = 1.5;
BORDER_THICKNESS = 1.5;

LENGTH = 160.4 + BORDER*2;
WIDTH = 20;

PITCH1 = 4.5;
PITCH2 = 5.5;
THICKNESS = 1.75;
MARGIN = 8.4;
MARGIN = 6.12;

ATOM = 0.001;

n1 = round(LENGTH/PITCH1);
n2 = round(WIDTH/PITCH2);
echo(n1); echo(n2);
p1 = (LENGTH-THICKNESS) / n1;
p2 = (WIDTH-THICKNESS) / n2;

module matte() {

    for (x = [0:p1:LENGTH])
        translate([x, 0, 0])
        cube([THICKNESS, WIDTH, HEIGHT]);
        
    for (y = [0:p2:WIDTH])
        translate([0, y, 0])
        cube([LENGTH, THICKNESS, HEIGHT]);

    cube([BORDER, WIDTH, HEIGHT + BORDER_THICKNESS]);

    translate([LENGTH-BORDER, 0, 0])
    cube([BORDER, WIDTH, HEIGHT + BORDER_THICKNESS]);
}

module pothole(big) {
    translate([0, 0, -ATOM])
    scale([1, 1, HEIGHT+ATOM*2])
    cylinder(d=big?DIAMETER2:DIAMETER1, true);
}

difference() {
    translate([-LENGTH/2, -WIDTH/2, 0])
    matte();

    pothole(true);

    spacing = (LENGTH/2 - DIAMETER2/2 - DIAMETER1*2 - MARGIN) / 2;
    
    d1 = p1 * (n1/4-1) ;
    translate([d1, 0, 0]) pothole(false);
    translate([-d1, 0, 0]) pothole(false);

    d2 = p1 * (n1/2-2) ;
    translate([d2, 0, 0]) pothole(false);
    translate([-d2, 0, 0]) pothole(false);
    
}