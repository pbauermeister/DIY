// ============================================================================
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 5%
//
// ============================================================================

include <definitions.scad>
use <cubes.scad>

space = 7;
shift = BLOCKS_WIDTH/2 + space;

translate([-shift, -shift, 0])
bottom_block();

// mid block
translate([shift, -shift, 0])
mid_block();

// top block
translate([shift, shift, 0])
top_block();
