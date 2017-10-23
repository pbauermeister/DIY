// Density: 40%
// Quality: Draft

include <definitions.scad>
use <parts.scad>

difference() {
    diagonal_end_rest(flat=true, with_hole=true);

    translate([WALL_THICKNESS, 0, WALL_THICKNESS])
    diagonal_end_rest(flat=true, with_hole=false);
}
