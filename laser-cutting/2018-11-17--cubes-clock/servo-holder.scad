include <definitions.scad>

use <servo.scad>
use <rods.scad>

////////////////////////////////////////////////////////////////////////////////

holder(4, !true);
%servo();

translate([40, 0, 0]) {
	translate([0, 0, 4])
	holder(4, true, false);

	translate([0, 0, 4+4+TOLERANCE])
	holder(4, true);

	%servo();
}

//%servo();

HOLDER_MARGIN_X = 4;
HOLDER_MARGIN_Y = 2;
HOLDER_MARGIN_Y2 = 8;
HOLDER_MARGIN_3 = 4.5;

SERVO_TOLERANCE = TOLERANCE;

HOLDER_LENGTH = SERVO_SCREW1_H_DISPLACEMENT
              - SERVO_SCREW2_H_DISPLACEMENT + HOLDER_MARGIN_X*2;
HOLDER_WIDTH = SERVO_THICKNESS + HOLDER_MARGIN_Y*2;

HOLDER_DX = (SERVO_SCREW1_H_DISPLACEMENT + SERVO_SCREW2_H_DISPLACEMENT) / 2;
HOLDER_DZ = SERVO_SCREW_V_DISPLACEMENT;

CABLE_CLEARANCE_LENGTH = 5;
CABLE_CLEARANCE_WIDTH = 3.5;
CABLE_CLEARANCE_LENGTH2 = 3.5;

module holder_frame(thickness, is_upper=false) {
	difference() {
		translate([HOLDER_DX, 0, -thickness/2 + HOLDER_DZ])

		intersection() {
			cube([HOLDER_LENGTH, HOLDER_WIDTH, thickness], true);
			translate([0, HOLDER_LENGTH*.05, 0])
			rotate([0, 0, 45])
			cube([HOLDER_LENGTH, HOLDER_LENGTH, thickness*2], true);
		}

		if (is_upper) {
			l = SERVO_SCREW1_H_DISPLACEMENT - SERVO_SCREW2_H_DISPLACEMENT
			    + HOLDER_MARGIN_X;
			l = SERVO_LENGTH;
			translate([HOLDER_DX, 0, -thickness/2 + HOLDER_DZ])
			cube([l, SERVO_THICKNESS+SERVO_TOLERANCE, thickness*2], true);
		}
		else {
			d = SERVO_TOLERANCE/2;
			for (x=[-d, d])
				for (y=[-d, d])
					translate([x, y, ATOM])
			servo();
			servo_screws();
		}
	}
}

module holder_extension(thickness) {
	w = GEARS_DISTANCE - HOLDER_WIDTH/2 + HOLDER_MARGIN_Y2 + ATOM*2;
	dy = HOLDER_WIDTH/2 + w/2 -ATOM;
	translate([HOLDER_DX, dy, -thickness/2 + HOLDER_DZ])
	cube([HOLDER_LENGTH, w, thickness], true);	
}

module holder(thickness, is_upper=false, cable_lock=true) {
	holder_frame(thickness, is_upper);
	difference() {
		holder_extension(thickness);

		translate([0, GEARS_DISTANCE, 0])
		rotate([0, 0, -270]) {
			rod2();
			hull() {
				translate([PLAY, 0, 0]) rod1();
				translate([-PLAY, 0, 0]) rod1();
			}
		}

		// cable clearance
		w = cable_lock ? CABLE_CLEARANCE_WIDTH : CABLE_CLEARANCE_WIDTH*2;
		translate([GEARS_DISTANCE + HOLDER_MARGIN_3,
				  GEARS_DISTANCE - CABLE_CLEARANCE_LENGTH/2,
				  HOLDER_DZ-thickness*1.5])
		cube([w, CABLE_CLEARANCE_LENGTH, thickness*2]);

		translate([GEARS_DISTANCE + HOLDER_MARGIN_3 + CABLE_CLEARANCE_WIDTH-ATOM,
				  GEARS_DISTANCE - CABLE_CLEARANCE_LENGTH2/2,
				  HOLDER_DZ-thickness*1.5])
		cube([CABLE_CLEARANCE_WIDTH, CABLE_CLEARANCE_LENGTH2, thickness*2]);

	}
}
