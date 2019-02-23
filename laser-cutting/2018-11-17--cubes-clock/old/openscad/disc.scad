include <definitions.scad>
use <rods.scad>

module disc(recess, thickness) {
	difference() {
		cylinder(r=BLOCKS_WIDTH/2-recess-PLAY/2, h=thickness);
		rods();
	}
}

disc(2, 2);