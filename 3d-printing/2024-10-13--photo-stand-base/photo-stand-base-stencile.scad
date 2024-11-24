use <lib.scad>

RADIUS = 45;
TOLERANCE = .17;
cylinder(r=RADIUS-3 -TOLERANCE, h=2, $fn=100, center=true);
