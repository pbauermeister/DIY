use <../chamferer.scad>

INNER_H    = 22;
INNER_SIDE = 55;
WALL       =  1.25;
CH         =  1.25;

H = INNER_H    + WALL*2;
S = INNER_SIDE + WALL*2;

$fn = 200;

difference() {
    chamferer($preview?0:CH, fn=8)
    cube([S, H, S]);
    
    // cavity
    translate([WALL, WALL, WALL])
    cube([INNER_SIDE, INNER_H, INNER_SIDE]);

    // opening
    translate([WALL, WALL, WALL])
    cube([INNER_SIDE, INNER_H*.67, INNER_SIDE*2]);

    // finger notch
    translate([S/2, -S/2, S])
    rotate([90, 0, 0])
    cylinder(r=10, h= H*3, center=true);

    // bottom hole
    translate([S/2, H/2, -1])
    cylinder(d=INNER_H*.85, h=S/2);
    
    
    // cross-cut
    if ($preview) translate([10, 20, -10]) cube(1000);
}