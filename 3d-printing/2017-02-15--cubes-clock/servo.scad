include <definitions.scad>

servo_hull();
%servo_screw_cavity();

module servo_hull(with_clearance=false, with_cable_slot=false, rotation=180+45) {
    thickness = SERVO_THICKNESS + TOLERANCE;
    cable_slot_thickness = SERVO_THICKNESS; // / 3;
    
    rotate([0, 0, rotation]) {
        rotate([90, 0, 0]) {
            translate([0, 0, -thickness/2])
            linear_extrude(height=thickness)
            //offset(delta=TOLERANCE/2) // <== Loosen a bit the cavity
            scale([10, 10, 1]) {
                import("2d/servo.dxf");
                
                if (with_clearance)
                    import("2d/servo-clearances.dxf");
            }

            if (with_cable_slot) {
                translate([0, 0, -cable_slot_thickness/2])
                linear_extrude(height=cable_slot_thickness)
                //offset(delta=TOLERANCE/2) // <== Loosen a bit the cavity
                scale([10, 10, 1])
                import("2d/servo-cable-slot.dxf");
            }
        }
    }
}

module servo_screw_cavity(rotation=180+45, is_clearance_hole=false) {
    rotate([0, 0, rotation]) {
        servo_screw(SERVO_SCREW1_H_DISPLACEMENT,
                    SERVO_SCREW_V_DISPLACEMENT,
                    SERVO_SCREW_HEAD_EXTENT, is_clearance_hole);
        servo_screw(SERVO_SCREW2_H_DISPLACEMENT,
                    SERVO_SCREW_V_DISPLACEMENT,
                    SERVO_SCREW_HEAD_EXTENT, is_clearance_hole);
    }
}

module servo_screw(distance_to_axis, z, head_extent, is_clearance_hole) {   
    translate([distance_to_axis, 0, z])
    screw(head_extent, is_clearance_hole);
}
