use <goggle-attachment.scad>

d = 6;

translate([d, 0, 0])
rotate([0, 0, 90]) all();

translate([-d, 0, 0])
rotate([0, 0, 90]) scale([1, -1, 1]) all();