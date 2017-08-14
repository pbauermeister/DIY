// ============================================================================
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 15%
//
// ============================================================================

include <definitions.scad>
use <02-primary-plate.scad>

module short_plate() {
    difference() {
        primary_plate(is_short=true);

        translate([0, 0, PLATE_HEIGHT_SHORT])
        cylinder(r=PLATE_DIAMETER, h= PLATE_THICKNESS);
    }
}

short_plate();