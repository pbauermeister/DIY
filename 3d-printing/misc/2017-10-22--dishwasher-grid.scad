// Density: Draft
// Fill: 100%

LENGTH = 49;
WIDTH = 39;
HEIGHT1 = 5;
HEIGHT2 = 5.5;

PITCH1 = 4.5;
PITCH2 = 4.5;
THICKNESS = 1.75;

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
