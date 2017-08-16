include <definitions.scad>
use <02-primary-plate-short.scad>
use <02-primary-plate.scad>
use <03-plate2.scad>
use <04-holder.scad>
use <05-cubes.scad>

INTERSPACE_HEIGHT = 12.5 +20;
OVERALL_ROTATION = 40;

//
// CYLINDERS
//
%rotate([0, 0, OVERALL_ROTATION])
{
    // Base plate
    flip(PLATE_HEIGHT_SHORT)
    short_plate();
    // PLATE_HEIGHT_SHORT

    // primary plate
    z1 = PLATE_HEIGHT_SHORT + TOLERANCE;
    translate([0, 0, z1])
    primary_plate();
    // PLATE_THICKNESS

    // wheel
    z2 = z1 + PLATE_THICKNESS + TOLERANCE;
    translate([0, 0, z2])
    flip(PLATE2_WHEEL_HEIGHT, 90)
    plate2();
    // PLATE2_WHEEL_HEIGHT

    // wheel upside-down
    z3 = PLATE2_Z;
    translate([0, 0, z3])
    plate2();

    // primary plate upside-down
    z4 = z3 + PLATE2_WHEEL_HEIGHT + TOLERANCE;
    translate([0, 0, z4])
    flip(PLATE_THICKNESS)
    primary_plate();
    // PLATE_THICKNESS

    // primary plate
    z5 = z4 + PLATE_THICKNESS + TOLERANCE;
    translate([0, 0, z5])
    primary_plate();
    // PLATE_THICKNESS
    
    // wheel
    z6 = z5 + PLATE_THICKNESS + TOLERANCE;
    translate([0, 0, z6])
    flip(PLATE2_WHEEL_HEIGHT, 90)
    plate2();
    // PLATE2_WHEEL_HEIGHT
}

//
// CUBES
//
rotate([0, 0, OVERALL_ROTATION - 180])
difference() {
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
    
    translate([-BOX_SIDE/2/2, -BOX_SIDE, -ATOM])
    cube([BOX_SIDE*2,
          BOX_SIDE*2,
          (BLOCK1_HEIGHT_STACKABLE+BLOCK2_HEIGHT_STACKABLE+BLOCK1_HEIGHT_STACKABLE)*2]);
}

//
// SUPPORT
//

rotate([0, 0, OVERALL_ROTATION + 45])
//translate([-4, 0, 0])
holder();
