

module letter(l) {
	difference() {
		translate([-2, -2, -2])
		cube([14, 14, 14]);

		translate([0, 0, -5])
		scale([1, 1, 2])
		translate([-1, 0, 0])
		resize([10, 10, 10])
		linear_extrude(10)
		text(l);
	}
}


intersection() {
	//translate([-.85, .1, 0]) 
	letter("1");

	//translate([-1.8, 10, 0])
	translate([0, 10, 0])
	rotate([90, 0, 0])
	letter("2");

	//translate([0, -1.1, 0])
	rotate([90, 0, 90])
	letter("3");
}
