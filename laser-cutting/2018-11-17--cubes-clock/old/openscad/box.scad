include <definitions.scad>

module box(height, wall_thickness) {
	d1 = BLOCKS_WIDTH;
	d2 = d1 - wall_thickness*2;
	translate([0, 0, -height/2])
	difference() {
		cube([d1, d1, height], true);
		cube([d2, d2, height*2], true);
	}
}

box(10, 3);