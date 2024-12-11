use <mixer-holder.scad>

translate([0, 0, get_length()])
part2();

// supports / blockers

translate([8.5, -5.2, 76.5])
rotate([45, 0, 0])
cube([51.5, 8, .5]);

translate([-8.5, 84.5, 16.8])
rotate([-45, 0, 0])
cube([24, 8, .5]);

translate([-8.5, 84.5-3.2, 16.8])
rotate([-45, 0, 0])
cube([24, 8, .5]);


translate([60.2, 0, 0])
cube([5, 80, .3]);
