SHAFT_D = 4.5;
HEIGHT = 4.5;
LENGTH = 25;
WIDTH = 12;

HOLE_W = 7.8;
HOLE_H = 1.5;
HOLE_L = 20;

EPSILON = 0.01;
$fn = 90;

module body() {
	translate([-LENGTH, -WIDTH/2, 0])
	cube([LENGTH, WIDTH, HEIGHT]);

	translate([0, 0, SHAFT_D/2])
	hull() {
		sphere(d=SHAFT_D);

		translate([SHAFT_D, 0, 0])
		sphere(d=SHAFT_D);
	}
}

module hole() {
	translate([-LENGTH-EPSILON, -HOLE_W/2, (HEIGHT-HOLE_H)/2])
	cube([HOLE_L, HOLE_W, HOLE_H]);
}

difference() {
	body();
	hole();
}
