// ============================================================================
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 15%
//
// ============================================================================

include <definitions.scad>
use <02-primary-plate.scad>

//rotate([180, 0, 0])
difference() {
    translate([0, 0, -PLATES_OVERLAP/2])
    plate_all(is_short=true);

    translate([0, 0, PLATE_HEIGHT_SHORT])
    cylinder(r=PLATE_DIAMETER, h= PLATE_THICKNESS);
}
