L = 900;
l = 600;
h = 140;

RADIUS = 10;
ATOM = 0.125;

module person() {
	scale([1, 0.6, 1]) {
		translate([-80, 0,   0]) cylinder(r= 80, h=700);
		translate([ 80, 0,   0]) cylinder(r= 80, h=700);
		translate([  0, 0, 700]) cylinder(r=180, h=620);
	}
	translate([ 190, 0, 700]) cylinder(r=40, h=620);
	translate([-190, 0, 700]) cylinder(r=40, h=620);

	translate([0, 0, 1600-125]) sphere(r=125);
}

module person_sitting(angle=0) {
	translate([-80, -290,   0])
	translate([0, 0, 440+80])
	rotate([-angle, 0, 0]) translate([0, 0, -440-80])
	scale([1, 0.6, 1]) cylinder(r=80, h=440+80);

	translate([80, -290,   0])
	translate([0, 0, 440+80])
	rotate([-angle, 0, 0]) translate([0, 0, -440-80])
	scale([1, 0.6, 1]) cylinder(r=80, h=440+80);

	translate([-80, -50, 500]) rotate([90, 0, 0])
	scale([1, 0.6, 1]) cylinder(r=80, h=250);
	translate([80, -50, 500]) rotate([90, 0, 0])
	scale([1, 0.6, 1]) cylinder(r=80, h=250);

	scale([1, 0.6, 1]) translate([  0,    0, 440]) cylinder(r=180, h=580);
	
	translate([ 190, 0, 440]) cylinder(r=40, h=580);
	translate([-190, 0, 440]) cylinder(r=40, h=580);

	translate([0, 0, 1300-125 ]) sphere(r=125);
}


module block() {
	color("gray")
	minkowski() {
		translate([RADIUS, RADIUS, RADIUS])
		cube([l-RADIUS*2, L-RADIUS*2, h-RADIUS*2]);
		sphere(RADIUS);
	}
}

module block_v() {
	translate([0, h, 0])
	rotate([90, 0, 0])
	block();
}

module all_1() {
	// Flockenes-1
	translate([l*0, 0, 0]) block();
	translate([l*1, 0, 0]) block();
	translate([l*2, 0, 0]) block();

	// Flockenes-2
	translate([l*0, 0, h]) block();
	translate([l*1, 0, h]) block();
	translate([l*2, 0, h]) block();

	// Flockenes-3
	translate([0, L-l, 0]) rotate([0, 0, 90]) block_v();
	translate([l*0, L, 0]) block_v();
	translate([l*1, L, 0]) block_v();

	// Flockenes-4
	translate([l*2, L, 0]) block_v();
	translate([l*3+h*1, L-l, 0]) rotate([0, 0, 90]) block_v();
	translate([l*3+h*2, L-l, 0]) rotate([0, 0, 90]) block_v();

	translate([300, 200, -180]) person_sitting(48);
}

module all_2() {
	// Flockenes-1
	translate([l*0, 0, 0]) block();
	translate([l*1, 0, 0]) block();
	translate([l*2, 0, 0]) block();

	// Flockenes-2
	translate([l*0, 0, h]) block();
	translate([l*1, 0, h]) block();
	translate([l*2, 0, h]) block();

	// Flockenes-3
	translate([0, L-l, 0]) rotate([0, 0, 90]) block_v();
	translate([l*0, L, 0]) block_v();
	translate([l*1, L, 0]) block_v();

	// Flockenes-4
	translate([l*2, L, 0]) block_v();
	translate([l*2, L+h, 0]) block_v();
	translate([l*3+h*1, L-l, 0]) rotate([0, 0, 90]) block_v();

	translate([300, 200, -180]) person_sitting(48);
}

module all_3() {
	// Flockenes-1
	translate([l*0, 0, h*1.5]) block();
	translate([l*1, 0, h*1.5]) block();
	translate([l*2, 0, h*1.5]) block();

	// Flockenes-2
	translate([l*0, 0, h*2.5]) block();
	translate([l*1, 0, h*2.5]) block();
	translate([l*2, 0, h*2.5]) block();

	// Flockenes-3
	translate([0, L-l, 0]) rotate([0, 0, 90]) block_v();
	translate([l*0, L, 0]) block_v();
	translate([l*1, L, 0]) block_v();

	// Flockenes-4
	translate([l*2, L, 0]) block_v();
	translate([l*3+h*1, L-l, 0]) rotate([0, 0, 90]) block_v();
	translate([l*3+h*2, L-l, 0]) rotate([0, 0, 90]) block_v();

	translate([300, 200, 0])
	person_sitting();
}



translate([0, L*4, 0]) all_1();
translate([0, L*2, 0]) all_2();
translate([0, L*0, 0]) all_3();

