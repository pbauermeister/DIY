// ============================================================================
// NOTES:
// Test and library file.
//
// You can render it for test, you can export to STL, but you do not need to 3D
// print it.
//
// You can import this file as a library (use <>) and render foot_stencile_halves()
// or foot_stencile() for printing a stencile.
// ============================================================================

include <definitions.scad>
use <base-plate.scad>
use <center-plate.scad>
use <lever-plate.scad>
use <holder.scad>
use <cubes.scad>

INTERSPACE_HEIGHT = 12.5 +20;
OVERALL_ROTATION = 45;

module foot_cubes() {
    rotate([0, 0, 135]) {
        flip(BLOCK1_HEIGHT + CUBE_CROWN_HEIGHT)
        bottom_block(draft=true);
        
        z1 = BLOCK1_HEIGHT + CUBE_CROWN_HEIGHT + TOLERANCE;
        translate([0, 0, z1])

        flip(BLOCK2_HEIGHT_STACKABLE)
        mid_block(draft=true);

        z2 = z1 + BLOCK2_HEIGHT_STACKABLE + TOLERANCE;
        translate([0, 0, z2])
        flip(BLOCK3_HEIGHT_STACKABLE)
        top_block(draft=true);
    }
}

module foot_digit(extra_rotation=0) {
    rotate([0, 0, OVERALL_ROTATION - 180 + extra_rotation]) {
        foot_cubes();
//        base_plate(has_center_hole=true, with_screws=true);
    }
}

module foot_base(width, depth, height, sink=true) {
    translate([0, 0, sink ? -height : 0])
    cube([width, depth, height]);
}

module foot_digit_imprint(radius, height) {
    base_plate_screws();
    translate([0, 0, -ATOM])  base_plate_center_hole(height+ATOM*2);
}

function sumv(v, sum=0, index=0, upto=-1) =
    index == len(v) || (upto != -1 && index > upto) ? 0 : sum + v[index] + sumv(v, sum, index+1, upto);

function foot_pos(index) = index * BLOCKS_WIDTH + sumv(spacings, upto=index);

//
// All together
//

FOOT_SPACING_MARGIN = 4;
FOOT_HEIGHT = 20;
FOOT_SPACING = BLOCKS_WIDTH * (sqrt(2)-1) / 2 + FOOT_SPACING_MARGIN;
FOOT_CENTER_GAP =  BLOCKS_WIDTH / 2;

echo("=====>", (sqrt(2)));
spacings = [
    0,
    FOOT_SPACING,
    FOOT_SPACING + FOOT_CENTER_GAP,
    FOOT_SPACING];
FOOT_LENGTH = sumv(spacings) + BLOCKS_WIDTH*4;
offset = BLOCKS_WIDTH/2;

echo(str("Foot total length: ", FOOT_LENGTH));

//
// All digits (blocks only plus bottom base) and the foot, to give a global impression
//

module all() {
    color("white") {
        translate([foot_pos(0) + offset, offset, 0]) foot_digit(45*0);
        translate([foot_pos(1) + offset, offset, 0]) foot_digit();
        translate([foot_pos(2) + offset, offset, 0]) foot_digit();
        translate([foot_pos(3) + offset, offset, 0]) foot_digit();
    }
    color("brown")
    foot_base(FOOT_LENGTH, BLOCKS_WIDTH, FOOT_HEIGHT);
}

module foot_stencile_digits(radius, height) {
    translate([foot_pos(0) + offset, offset, 0]) foot_digit_imprint(radius, height);
    translate([foot_pos(1) + offset, offset, 0]) foot_digit_imprint(radius, height);
    translate([foot_pos(2) + offset, offset, 0]) foot_digit_imprint(radius, height);
    translate([foot_pos(3) + offset, offset, 0]) foot_digit_imprint(radius, height);
}

//
// Foot stencile, to mark cable and screw holes, in case you want to make a foot out of wood, concrete, etc.
//

module foot_stencile(height) {
    // frame
    difference() {        
        foot_base(FOOT_LENGTH, BLOCKS_WIDTH, height, sink=false);
        // digits bases
        foot_stencile_digits(BLOCKS_WIDTH/2, height);
        // mark
        d = 10;
        translate([FOOT_LENGTH/2 -d/2, BLOCKS_WIDTH/2 +d, -ATOM])
        cube([d, d, height+2*ATOM]);
    }
}

module foot_stencile_halves(height) {
    translate([FOOT_LENGTH/2, 0, 0])
    difference() {
        translate([-FOOT_LENGTH/2, 0, 0])
        foot_stencile(height);
        
        translate([0, -ATOM, -ATOM])
        cube([FOOT_LENGTH, BLOCKS_WIDTH+ATOM*2, height+ATOM*2]);
    }

    translate([0, -BLOCKS_WIDTH - 10, 0])
    difference() {
        translate([-FOOT_LENGTH/2, 0, 0])
        foot_stencile(height);
        
        translate([-FOOT_LENGTH, -ATOM, -ATOM])
        cube([FOOT_LENGTH, BLOCKS_WIDTH+ATOM*2, height+ATOM*2]);
    }

}

//height = 0.2;
//translate([0, -BLOCKS_WIDTH*2, 0])
//foot_stencile_halves(height);

all();
