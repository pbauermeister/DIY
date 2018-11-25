include <definitions.scad>

use <rods.scad>
use <01--block.scad>
use <disc.scad>

////////////////////////////////////////////////////////////////////////////////

MATERIAL1_THICKNESS = 4;
MATERIAL2_THICKNESS = 2;
MATERIAL3_THICKNESS = 2;

BLOCK_HEIGHT = 44;
BLOCK_HEIGHT2 = 10;
BLOCK_SPACING = 0.25;

// Bottom block
block(MATERIAL1_THICKNESS, MATERIAL2_THICKNESS, BLOCK_HEIGHT, extra_holders=4);

// Mid block
translate([0, 0, BLOCK_SPACING])
rotate([180, 0, 180])
block(MATERIAL1_THICKNESS, MATERIAL2_THICKNESS, BLOCK_HEIGHT2);

// Top block
translate([0, 0, BLOCK_SPACING*2 + BLOCK_HEIGHT + BLOCK_HEIGHT2])
block(MATERIAL1_THICKNESS, MATERIAL2_THICKNESS, BLOCK_HEIGHT, no_cuts=true);

// Base disc
translate([0, 0, -BLOCK_HEIGHT-1.1 + MATERIAL3_THICKNESS*0])
//cylinder(r=BLOCKS_WIDTH/2-MATERIAL2_THICKNESS-PLAY/2, h=MATERIAL3_THICKNESS);
disc(MATERIAL2_THICKNESS, MATERIAL3_THICKNESS);

// Rods
if(1)
color("silver")
rods();

// TODO:
// - Base disc: hole for cables
// - Median+top servos: 
// - Top disc
// - Cut rods to size
// - Import and place each piece, then call projection()
