use <chamferer.scad>

ATOM = .01;

$fn = 20;

sm = 4; // Smoothness. Small: tight, big: hull

chamferer(sm, "cylinder", fn=$fn, grow=false)
chamferer(sm, "cylinder", fn=$fn, shrink=false)
union() {
    cylinder(d=20, h=1);
    %cylinder(d=20, h=2);

    translate([20, 0, 0])
    cylinder(d=20, h=1);

    %translate([20, 0, 0])
    cylinder(d=20, h=2);
}