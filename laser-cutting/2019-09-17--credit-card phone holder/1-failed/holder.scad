/* */

// 85 X 54
LENGTH = 85;
WIDTH = 54;
THICKNESS = 1.5;

EPSILON = 0.1;

module cutoff() {
	translate([0, 0, -EPSILON])
	resize([LENGTH+EPSILON*2, WIDTH+EPSILON*3, THICKNESS + EPSILON])
	linear_extrude(1)
	translate([-26.812, 68.269, 0])
	import("holder.dxf");
}

difference() {
	cube([LENGTH, WIDTH, THICKNESS]);
	cutoff();
}