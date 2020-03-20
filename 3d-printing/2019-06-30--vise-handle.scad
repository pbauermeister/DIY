$fn = 66;
D = 70;

module body() {
	translate([0, 0, D/2/1.25])
	scale([.65, .65, 1])
	intersection() {
		translate([0, 0, 3.5]) sphere(d=D);
		cube([D/1.25,D/1.25,D/1.25 -2],true);
	}
}
module axis_hole() {
	cylinder(d=13.8, h=41);
	sphere(d=16);
	translate([0,0,-20]) cylinder(d=40, h=20);
	translate([0,0,40 + 25/2-2.5]) cylinder(d=25, h=20);
	translate([0,0,40+25/2-2.5]) sphere(d=25);
}

module all() {
	difference() {
		body();
		axis_hole();
	}
}

rotate([180, 0, 0]) {
	//body();
	//axis_hole();
	all();
}
