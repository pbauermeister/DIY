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
                import("servo.dxf");
                
                if (with_clearance)
                    import("servo-clearances.dxf");
            }

            if (with_cable_slot) {
                translate([0, 0, -cable_slot_thickness/2])
                linear_extrude(height=cable_slot_thickness)
                //offset(delta=TOLERANCE/2) // <== Loosen a bit the cavity
                scale([10, 10, 1])
                import("servo-cable-slot.dxf");
            }
        }
    }
}

module servo_screw_cavity(rotation=180+45, radius_excess=0) {
    rotate([0, 0, rotation]) {
        servo_screw(SERVO_SCREW1_H_DISPLACEMENT,
                    SERVO_SCREW_V_DISPLACEMENT,
                    SERVO_SCREW_HEAD_EXTENT, radius_excess);
        servo_screw(SERVO_SCREW2_H_DISPLACEMENT,
                    SERVO_SCREW_V_DISPLACEMENT,
                    SERVO_SCREW_HEAD_EXTENT, radius_excess);
    }
}

module servo_screw(distance_to_axis, z, head_extent, radius_excess) {   
    translate([distance_to_axis, 0, z]) {
        // thread
        translate([0, 0, -SCREW2_HEIGHT + SCREW2_HEAD_THICKNESS])
        cylinder(h=SCREW2_HEIGHT, r=SCREW2_DIAMETER/2 - TOLERANCE + radius_excess);

        // head
        for (i=[0:head_extent])
            translate([0, 0, i])
            cylinder(h=SCREW2_HEAD_THICKNESS, r=SCREW2_HEAD_DIAMETER/2 + PLAY);
    }
}