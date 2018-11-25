// ============================================================================
// NOTES:
// Library file. To be imported via the use <> statement.
// You can render it for test, but do not export to STL.
//
// ============================================================================

include <definitions.scad>
use <gears.scad>

PLATE_CROWN = 8;

module plate(thickness, side_recess, no_cuts=false) {
	difference() {
		w = BLOCKS_WIDTH - side_recess*2;
		translate([0, 0, thickness/2])
		cube([w, w, thickness], true);

		if (!no_cuts)
			plate_cuts(thickness);
	}
}

module plate_cuts(thickness) {
	r1 = GEARS_DISTANCE + PLATE_CROWN*.8;
	r2 = GEARS_DISTANCE - PLATE_CROWN/2;
	h = thickness*2;
	a = 22.5 +10;

	translate([0, 0, -thickness/2])
	union() {
		da = 90 *3;
		rotate([0, 0,  a/2 +da]) c(r1, r2, h);
		rotate([0, 0, -a/2 +da]) c(r1, r2, h);
	}

	translate([0, 0, -thickness/2])
	cylinder(d=ROD_DIAMETER+TOLERANCE, h=thickness*2);
}

module c(r1, r2, thickness) {
	difference() {
		barrel(r1, r2, thickness);
		translate([0, 0, -ATOM])
		cube(r1);
	}
}

plate(PLATE2_WHEEL_HEIGHT, 3);
