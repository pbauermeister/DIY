// Density: Draft
// Fill: 100%

LENGTH = 50;
WIDTH = 36;
HEIGHT1 = 12;
HEIGHT2 = HEIGHT1 + 1;

PITCH1 = 4.5 *1.7;
PITCH2 = 4.5 *1.7;
THICKNESS = 2*1.7;

EPSILON = 0.01;

n1 = round(LENGTH/PITCH1);
n2 = round(WIDTH/PITCH2);
echo(n1); echo(n2);

p1 = (LENGTH-THICKNESS) / n1;
p2 = (WIDTH-THICKNESS) / n2;

for (x = [0:p1:LENGTH])
    translate([x, 0, 0])
    cube([THICKNESS, WIDTH, HEIGHT1]);
    
for (y = [0:p2:WIDTH])
    translate([0, y, 0])
    cube([LENGTH, THICKNESS, HEIGHT2]);


difference() {
	cube([LENGTH, WIDTH, HEIGHT2+2]);
	translate([THICKNESS, THICKNESS, -EPSILON])
	cube([LENGTH-THICKNESS*2, WIDTH-THICKNESS*2, HEIGHT2+2 + EPSILON*2]);

}