// ============================================================================
// NOTES:
// Library file. To be imported via the use <> statement.
// You can render it for test, but do not export to STL.
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

module one_holder_tenon(upside_down, has_screw_hole, height=-1) {
    h = height==-1 ? (has_screw_hole ? HOLDER_ARM_HEIGHT: PLATE_HEIGHT)
                   : height;
    difference() {
        translate([-HOLDER_ARM_RADIUS_SHORTAGE, 0, 0]) {
            length = PLATE_DIAMETER/2-HOLDER_ARM_RADIUS_SHORTAGE;
            xs = HOLDER_THICKNESS/2;        
            cylinder(h=h, r=HOLDER_ARM_RADIUS);
            translate([-length-xs, -HOLDER_ARM_THICKNESS/2, 0])
            cube([length+xs, HOLDER_ARM_THICKNESS, h]);
        }

        screw_z = upside_down?0:HOLDER_ARM_HEIGHT;
        if (has_screw_hole)
            translate([-HOLDER_ARM_RADIUS_SHORTAGE, 0, screw_z])
            rotate([upside_down?180:0, 0, 0])
            screw();
    }
}

module holder() {
    z1 = PLATE_HEIGHT_SHORT - HOLDER_ARM_HEIGHT + TOLERANCE/2;
    z2 = z1 + HOLDER_ARM_HEIGHT;
    z3 = PLATE2_Z + PLATE2_WHEEL_HEIGHT
        + TOLERANCE;
    z4 = z3 + PLATE_HEIGHT;
    h = z4 + HOLDER_ARM_HEIGHT;
    
    one_holder_spine(h) {
        translate([0, 0, z1])
        one_holder_tenon(true,true);

        translate([0, 0, z2])
        one_holder_tenon(false, false);


//        translate([0, -5, z2 + PLATE_HEIGHT])
//        %one_holder_tenon(false, false, height=PLATE_HEIGHT+PLAY+PLATE2_HEIGHT);
        clearance = PLATE_HEIGHT+PLAY+PLATE2_HEIGHT;
        echo(clearance,z3-z2-PLATE_HEIGHT);
        if (clearance>z3-z2-PLATE_HEIGHT) {
            echo("Clearance issue --> no 3rd tenon");
            dz = clearance - (z3-z2-PLATE_HEIGHT);
            translate([0, 0, z3+dz])
            one_holder_tenon(true, false, height=PLATE_HEIGHT-dz);
        }
        else
            translate([0, 0, z3])
            one_holder_tenon(true, false);

        translate([0, 0, z4])
        one_holder_tenon(false, true);
    }
}

rotate([0, -90, 0])
holder();