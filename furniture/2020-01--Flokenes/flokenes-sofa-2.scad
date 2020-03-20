L = 900;
l = 600;
h = 140;

RADIUS = 10;
ATOM = 0.125;

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
		cube([L-RADIUS*2, l-RADIUS*2, h-RADIUS*2]);
		sphere(RADIUS);
	}
}

module all() {
	// Flockenes-1
	translate([0, 0, 0]) block();
	// Flockenes-2
	translate([0, 1, h]) block();
	// Flockenes-3
	translate([0, l, h*2]) rotate([-20, 0, 0])
	translate([0, h, 0]) rotate([90, 0, 0]) block();
}

N_SEATS = 3;
for (i=[0:N_SEATS-1]) translate([L*i, 0, 0]) all();

N_PERSONS = 4;
for (j=[0:N_PERSONS-1]) translate([L*i, 0, 0])
	translate([N_SEATS/2*L + (j-N_PERSONS/2+.5)*600, 300, -180]) person_sitting(48);

