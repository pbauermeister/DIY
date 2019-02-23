include <definitions.scad>


module rod1() {
	cylinder(r=ROD_DIAMETER/2, h=250, center=true);
}

module rod2() {
	translate([0, -GEARS_DISTANCE, 0])
	cylinder(r=ROD_DIAMETER/2, h=250, center=true);
}

module rods() {
	rod1();
	rod2();
}

rods();