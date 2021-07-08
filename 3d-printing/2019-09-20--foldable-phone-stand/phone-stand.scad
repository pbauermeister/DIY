$fn = 60; 

HINGE_DIAMETER = 2;
HINGE_LENGTH = 5;
HINGE_SPACING = 5;
NB_HINGES = 4;
CLEARANCE = 0.25;
K = 1.5;

module knuckle(diameter, length, spacing, nb, excess=0) {
	for (i=[0: nb-1]) {
		translate([i*(length+spacing) + diameter/2 + spacing/2, 0, 0]) {
			hull() {
				scale([K, 1, 1])
				sphere(d=diameter + excess*2/K);

				translate([length-diameter, 0, 0])
				scale([K, 1, 1])
				sphere(d=diameter + excess*2/K);
			}
		}
	}
}

module hinge(diameter, length, spacing, nb, excess=0) {
	knuckle(diameter, length, spacing, nb, excess);
	// fingers
	for (i=[0: nb-1]) {
		translate([i*(length+spacing) + diameter/2 +spacing/2, 0, 0]) {
			translate([-diameter/2/K + CLEARANCE, -diameter, -diameter/2])
			cube([length-diameter/2/K - CLEARANCE*2, diameter, diameter]);
		}
	}
}

module counter_hinge(diameter, length, spacing, nb, clearance) {
	difference() {
		union() {
			// bar
			rotate([0, 90, 0])
			cylinder(d=diameter, h=(length+spacing)*(nb));

			// intermediate fingers
			for (i=[1: nb-1]) {
				translate([i*(length+spacing) + -spacing/2 + length/2*0, 0, 0]) {
					translate([0, 0, -diameter/2])
					cube([spacing, diameter, diameter]);
				}
			}

			// end fingers
			translate([0, 0, -diameter/2])
			cube([spacing/2, diameter, diameter]);
			translate([nb*(length+spacing)-spacing/2, 0, -diameter/2])
			cube([spacing/2, diameter, diameter]);
		}
		// carve
		knuckle(diameter, length, spacing, nb, clearance);
	}
}

LENGTH = (HINGE_LENGTH+HINGE_SPACING)*NB_HINGES;
WIDTH = HINGE_DIAMETER *2;

color("blue") {
	hinge(HINGE_DIAMETER, HINGE_LENGTH, HINGE_SPACING, NB_HINGES);

	// plate
	translate([0, -WIDTH -HINGE_DIAMETER*.9, -HINGE_DIAMETER/2])
	cube([LENGTH, WIDTH, HINGE_DIAMETER]);
}

color("red") {
	counter_hinge(HINGE_DIAMETER, HINGE_LENGTH, HINGE_SPACING, NB_HINGES, CLEARANCE);

	// plate
	translate([0, HINGE_DIAMETER*.9, -HINGE_DIAMETER/2])
	cube([LENGTH, WIDTH, HINGE_DIAMETER]);
}