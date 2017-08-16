// ============================================================================
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 15%
//
// ============================================================================

include <definitions.scad>

module one_holder_spine(height) {
    difference() {
        union() {
            // bent plate
            difference() {
                rotate([0, 0, 180 - HOLDER_ANGLE/2])
                intersection() {
                    barrel(PLATE_DIAMETER/2 + HOLDER_THICKNESS,
                           PLATE_DIAMETER/2 + TOLERANCE*0, // <== ADJUST
                           height);
                    cube([PLATE_DIAMETER, PLATE_DIAMETER, height]);
                    rotate([0, 0, HOLDER_ANGLE-90])
                    cube([PLATE_DIAMETER, PLATE_DIAMETER, height]);
                }                
            }
            children();
        }

        // file flat
        r = (PLATE_DIAMETER/2 + HOLDER_THICKNESS) * cos(HOLDER_ANGLE/2);
        translate([-(PLATE_DIAMETER + r), -PLATE_DIAMETER/2, 0])
        cube([PLATE_DIAMETER, PLATE_DIAMETER, height]);
    }
}

module one_holder_tenon(upside_down) {
    difference() {
        translate([-HOLDER_ARM_RADIUS_SHORTAGE, 0, 0]) {
            length = PLATE_DIAMETER/2-HOLDER_ARM_RADIUS_SHORTAGE;
            xs = HOLDER_THICKNESS/2;        
            cylinder(h=HOLDER_ARM_HEIGHT, r=HOLDER_ARM_RADIUS);
            translate([-length-xs, -HOLDER_ARM_THICKNESS/2, 0])
            cube([length+xs, HOLDER_ARM_THICKNESS, HOLDER_ARM_HEIGHT]);
        }

        screw_z = upside_down?0:HOLDER_ARM_HEIGHT;
        translate([-HOLDER_ARM_RADIUS_SHORTAGE, 0, screw_z])
        rotate([upside_down?180:0, 0, 0])
        screw();
    }
}

module holder() {
    z1 = PLATE_HEIGHT_SHORT - HOLDER_ARM_HEIGHT + TOLERANCE/2;
    z2 = z1 + HOLDER_ARM_HEIGHT;
    z3 = PLATE2_Z + PLATE2_WHEEL_HEIGHT
       + PLATE_THICKNESS - HOLDER_ARM_HEIGHT + TOLERANCE;
    z4 = z3 + HOLDER_ARM_HEIGHT;
    h = z4 + HOLDER_ARM_HEIGHT;
    
    one_holder_spine(h) {
        translate([0, 0, z1])
        one_holder_tenon(true);

        translate([0, 0, z2])
        one_holder_tenon(false);

        translate([0, 0, z3])
        one_holder_tenon(true);

        translate([0, 0, z4])
        one_holder_tenon(false);
    }
}

rotate([0, -90, 0])
holder();