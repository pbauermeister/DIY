include <definitions.scad>

servo();

SERVO_VERTICAL_SHIFT = -.635;
SERVO_PINION_RADIUS = 3;
SERVO_PINION_HEIGHT = 4.3;

module servo(rotation=0) {
	difference() {
		servo_hull(rotation);
		//servo_screw_cavity(rotation);
	}

	cylinder(r=SERVO_PINION_RADIUS, h=SERVO_PINION_HEIGHT);
}

module servo_hull(rotation) {
    thickness = SERVO_THICKNESS;
    cable_slot_thickness = SERVO_THICKNESS; // / 3;
    
    rotate([0, 0, rotation]) {
        rotate([90, 0, 0]) {
            translate([0, SERVO_VERTICAL_SHIFT, -thickness/2])
            linear_extrude(height=thickness)
            //offset(delta=TOLERANCE/2) // <== Loosen a bit the cavity
            scale([10, 10, 1]) {
                import("2d/servo.dxf");
            }
        }
    }
}

module servo_screw_cavity(rotation, is_clearance_hole=false) {
    rotate([0, 0, rotation]) {
        servo_screw(SERVO_SCREW1_H_DISPLACEMENT,
                    SERVO_SCREW_V_DISPLACEMENT,
                    SERVO_SCREW_HEAD_EXTENT, is_clearance_hole);
        servo_screw(SERVO_SCREW2_H_DISPLACEMENT,
                    SERVO_SCREW_V_DISPLACEMENT-ATOM,
                    SERVO_SCREW_HEAD_EXTENT, is_clearance_hole);
    }
}

module servo_screw(distance_to_axis, z, head_extent, is_clearance_hole) {   
    translate([distance_to_axis, 0, z])
    screw(head_extent, is_clearance_hole);
}

module servo_screws() {
    servo_screw(SERVO_SCREW1_H_DISPLACEMENT,
                SERVO_SCREW_V_DISPLACEMENT,
                0, false);
    servo_screw(SERVO_SCREW2_H_DISPLACEMENT,
                SERVO_SCREW_V_DISPLACEMENT,
                0, false);
}
