include <definitions.scad>
use <02-primary-plate-short.scad>
use <02-primary-plate.scad>
use <03-plate2.scad>
use <05-cubes.scad>

rotate([0, 0, 180])
{
    // Base plate
    rotate([0, 0, 90])
    translate([0, 0, PLATE_HEIGHT_SHORT])
    rotate([180, 0, 0])
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
    translate([0, 0, PLATE2_WHEEL_HEIGHT])
    rotate([180, 0, 0])
    plate2();
    // PLATE2_WHEEL_HEIGHT
    
    
    INTERSPACE_HEIGHT = 12.5;

    // wheel upside-down
    translate([0, 0, PLATE_HEIGHT_SHORT + TOLERANCE
                     + PLATE_THICKNESS + TOLERANCE
                     + PLATE2_WHEEL_HEIGHT + INTERSPACE_HEIGHT
                     ])
    plate2();

    // primary plate upside-down
    translate([0, 0, PLATE_HEIGHT_SHORT + TOLERANCE
                     + PLATE_THICKNESS + TOLERANCE
                     + PLATE2_WHEEL_HEIGHT + INTERSPACE_HEIGHT
                     + PLATE2_WHEEL_HEIGHT + TOLERANCE
                     ])
    translate([0, 0, PLATE_THICKNESS])
    rotate([180, 0, 90])
    primary_plate();
    // PLATE_THICKNESS

    // primary plate
    translate([0, 0, PLATE_HEIGHT_SHORT + TOLERANCE
                     + PLATE_THICKNESS + TOLERANCE
                     + PLATE2_WHEEL_HEIGHT + INTERSPACE_HEIGHT
                     + PLATE2_WHEEL_HEIGHT + TOLERANCE
                     + PLATE_THICKNESS + TOLERANCE
                     ])
    primary_plate();
    // PLATE_THICKNESS
    
    // wheel
    translate([0, 0, PLATE_HEIGHT_SHORT + TOLERANCE
                     + PLATE_THICKNESS + TOLERANCE
                     + PLATE2_WHEEL_HEIGHT + INTERSPACE_HEIGHT
                     + PLATE2_WHEEL_HEIGHT + TOLERANCE
                     + PLATE_THICKNESS + TOLERANCE
                     + PLATE_THICKNESS + TOLERANCE
                     ])
    translate([0, 0, PLATE2_WHEEL_HEIGHT])
    rotate([180, 0, 0])
    plate2();
    // PLATE2_WHEEL_HEIGHT
}

difference() {
    rotate([0, 0, 135]) {
        translate([0, 0, BLOCK1_HEIGHT + CUBE_CROWN_HEIGHT])
        rotate([180, 0, 90])
        bottom_block();
        
        translate([0, 0, BLOCK1_HEIGHT + CUBE_CROWN_HEIGHT + TOLERANCE])
        translate([0, 0, BLOCK2_HEIGHT_STACKABLE])
        rotate([180, 0, 90])
        mid_block();


        translate([0, 0, BLOCK1_HEIGHT + CUBE_CROWN_HEIGHT + TOLERANCE
                         + BLOCK2_HEIGHT_STACKABLE + TOLERANCE])
        translate([0, 0, BLOCK3_HEIGHT_STACKABLE])
        rotate([180, 0, 90])
        top_block();
    }
    
    translate([-BOX_SIDE/2, -BOX_SIDE, -ATOM])
    cube([BOX_SIDE*2,
          BOX_SIDE*2,
          (BLOCK1_HEIGHT_STACKABLE+BLOCK2_HEIGHT_STACKABLE+BLOCK1_HEIGHT_STACKABLE)*2]);
}