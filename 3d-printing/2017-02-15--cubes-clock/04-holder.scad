// ============================================================================
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 15%
//
// ============================================================================

include <definitions.scad>

module one_holder(height, upside_down) {
    difference() {
        union() {
            // tenon
            difference() {
                tenon_z = upside_down ? height - HOLDER_ARM_HEIGHT : 0;
                translate([-HOLDER_ARM_RADIUS_SHORTAGE, 0, tenon_z]) {
                    length = PLATE_DIAMETER/2-HOLDER_ARM_RADIUS_SHORTAGE;
                    xs = HOLDER_THICKNESS/2;        
                    cylinder(h=HOLDER_ARM_HEIGHT, r=HOLDER_ARM_RADIUS);
                    translate([-length-xs, -HOLDER_ARM_THICKNESS/2, 0])
                    cube([length+xs, HOLDER_ARM_THICKNESS, HOLDER_ARM_HEIGHT]);
                }

                screw_z = tenon_z + (upside_down?0:HOLDER_ARM_HEIGHT);
                translate([-HOLDER_ARM_RADIUS_SHORTAGE, 0, screw_z])
                rotate([upside_down?180:0, 0, 0])
                screw();
            }

            // spine
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
        }
        
        // file flat
        r = (PLATE_DIAMETER/2 + HOLDER_THICKNESS) * cos(HOLDER_ANGLE/2);
        translate([-(PLATE_DIAMETER + r), -PLATE_DIAMETER/2, 0])
        cube([PLATE_DIAMETER, PLATE_DIAMETER, height]);
    }
}

HOLDER_HEIGHT = 50;

function get_holder_heights() = 
    let(module_height = PLATE_THICKNESS - PLATES_OVERLAP/2 + PLATE2_HEIGHT)
    [HOLDER_ARM_HEIGHT,
     module_height,
     module_height + HOLDER_MODULES_SPACING,
     HOLDER_ARM_HEIGHT];

module holder() {
    heights = get_holder_heights();
    one_holder(heights[0], true);

    translate([0, 0, heights[0]])
    one_holder(heights[1], false);

    translate([0, 0, heights[0]+heights[1]])
    one_holder(heights[2], true);

    translate([0, 0, heights[0]+heights[1]+heights[2]])
    one_holder(heights[3], false);
}

rotate([0, -90, 0])
holder();