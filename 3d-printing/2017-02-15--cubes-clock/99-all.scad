// ============================================================================
// NOTES:
// Test file.
// You can render it for test, but do not export to STL.
//
// ============================================================================


include <definitions.scad>
use <base-plate.scad>
use <center-plate.scad>
use <lever-plate.scad>
use <holder.scad>
use <cubes.scad>

INTERSPACE_HEIGHT = 12.5 +20;
OVERALL_ROTATION = 45;

module cylinders() {
    // Base plate
    base_plate();
    // PLATE_HEIGHT_SHORT

    // primary plate
    z1 = PLATE_HEIGHT_SHORT + TOLERANCE;
    translate([0, 0, z1])
    center_plate(has_holder_stop=false);
    // PLATE_THICKNESS

    // wheel
    z2 = z1 + PLATE_THICKNESS + TOLERANCE;
    translate([0, 0, z2])
    flip(PLATE2_WHEEL_HEIGHT, 90)
    lever_plate();
    // PLATE2_WHEEL_HEIGHT

    // wheel upside-down
    z3 = PLATE2_Z;
    translate([0, 0, z3])
    lever_plate();

    // primary plate upside-down
    z4 = z3 + PLATE2_WHEEL_HEIGHT + TOLERANCE;
    translate([0, 0, z4])
    flip(PLATE_THICKNESS)
    center_plate(has_holder_stop=false);
    // PLATE_THICKNESS

    // primary plate
    z5 = z4 + PLATE_THICKNESS + TOLERANCE;
    translate([0, 0, z5])
    center_plate();
    // PLATE_THICKNESS
    
    // wheel
    z6 = z5 + PLATE_THICKNESS + TOLERANCE;
    translate([0, 0, z6])
    flip(PLATE2_WHEEL_HEIGHT, 90)
    lever_plate();
    // PLATE2_WHEEL_HEIGHT
}

module cubes() {
    rotate([0, 0, 135]) {
        flip(BLOCK1_HEIGHT + CUBE_CROWN_HEIGHT)
        bottom_block();
        
        z1 = BLOCK1_HEIGHT + CUBE_CROWN_HEIGHT + TOLERANCE;
        translate([0, 0, z1])

        flip(BLOCK2_HEIGHT_STACKABLE)
        mid_block();

        z2 = z1 + BLOCK2_HEIGHT_STACKABLE + TOLERANCE;
        translate([0, 0, z2])
        flip(BLOCK3_HEIGHT_STACKABLE)
        top_block();
    }
}

module cubes_cut() {
    translate([-BLOCKS_WIDTH/2/2*0, -BLOCKS_WIDTH, -ATOM])
    cube([BLOCKS_WIDTH*2,
          BLOCKS_WIDTH*2,
          (BLOCK1_HEIGHT_STACKABLE+BLOCK2_HEIGHT_STACKABLE+BLOCK1_HEIGHT_STACKABLE)*2]);
}

//
// All together
//

rotate([0, 0, OVERALL_ROTATION])
cylinders();

rotate([0, 0, OVERALL_ROTATION - 180])
difference() {
    cubes();
    cubes_cut();
}

rotate([0, 0, OVERALL_ROTATION + 45])
//translate([-4, 0, 0])
translate([-PLAY, 0, 0])
holder();










