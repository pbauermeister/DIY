// ============================================================================
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 5%
//
// ============================================================================

include <definitions.scad>
use <cubes.scad>

space = 3;
shift = BLOCKS_WIDTH/2 + space;

translate([-shift, -shift, 0]) bottom_block();

translate([ shift, -shift, 0]) mid_block();

translate([ shift,  shift, 0]) top_block();
