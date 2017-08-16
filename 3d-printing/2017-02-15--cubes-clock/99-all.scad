include <definitions.scad>
use <02-primary-plate-short.scad>
use <02-primary-plate.scad>
use <03-plate2.scad>
use <04-holder.scad>
use <05-cubes.scad>

INTERSPACE_HEIGHT = 12.5 +20;
OVERALL_ROTATION = 90;

//
// CYLINDERS
//
rotate([0, 0, OVERALL_ROTATION])
{
    // Base plate
    flip(PLATE_HEIGHT_SHORT)
    short_plate();
    // PLATE_HEIGHT_SHORT

    // primary plate
    translate([0, 0, PLATE_HEIGHT_SHORT + TOLERANCE])
    primary_plate();
    // PLATE_THICKNESS

    // wheel
    translate([0, 0, PLATE_HEIGHT_SHORT + TOLERANCE
                     + PLATE_THICKNESS + TOLERANCE
                     ])
    flip(PLATE2_WHEEL_HEIGHT, 90)
    plate2();
    // PLATE2_WHEEL_HEIGHT

    // wheel upside-down
    plate2_y = PLATE_HEIGHT_SHORT + TOLERANCE
             + PLATE_THICKNESS + TOLERANCE
             + PLATE2_WHEEL_HEIGHT + INTERSPACE_HEIGHT;
    plate2_y = BLOCK1_HEIGHT_STACKABLE
             + CUBE_CROWN_HEIGHT
             + BLOCK2_HEIGHT/2
             - PLATE2_WHEEL_HEIGHT/2;
    translate([0, 0, plate2_y])
    plate2();

    // primary plate upside-down
    translate([0, 0, plate2_y
                     + PLATE2_WHEEL_HEIGHT + TOLERANCE
                     ])

    flip(PLATE_THICKNESS)
    primary_plate();
    // PLATE_THICKNESS

    // primary plate
    translate([0, 0, plate2_y
                     + PLATE2_WHEEL_HEIGHT + TOLERANCE
                     + PLATE_THICKNESS + TOLERANCE
                     ])
    primary_plate();
    // PLATE_THICKNESS
    
    // wheel
    translate([0, 0, plate2_y
                     + PLATE2_WHEEL_HEIGHT + TOLERANCE
                     + PLATE_THICKNESS + TOLERANCE
                     + PLATE_THICKNESS + TOLERANCE
                     ])
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
        
        translate([0, 0, BLOCK1_HEIGHT + CUBE_CROWN_HEIGHT + TOLERANCE])

        flip(BLOCK2_HEIGHT_STACKABLE)
        mid_block();

        translate([0, 0, BLOCK1_HEIGHT + CUBE_CROWN_HEIGHT + TOLERANCE
                         + BLOCK2_HEIGHT_STACKABLE + TOLERANCE])
        flip(BLOCK3_HEIGHT_STACKABLE)
        top_block();
    }
    
    translate([-BOX_SIDE/2, -BOX_SIDE, -ATOM])
    cube([BOX_SIDE*2,
          BOX_SIDE*2,
          (BLOCK1_HEIGHT_STACKABLE+BLOCK2_HEIGHT_STACKABLE+BLOCK1_HEIGHT_STACKABLE)*2]);
}

//
// SUPPORT
//
holder_y = PLATE_THICKNESS - PLATE_HEIGHT_SHORT;
rotate([0, 0, OVERALL_ROTATION + 45])
translate([-5, 0, holder_y*2])
holder();

