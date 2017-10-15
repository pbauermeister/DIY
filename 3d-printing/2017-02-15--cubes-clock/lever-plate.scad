// ============================================================================
// NOTES:
// Library file. To be imported via the use <> statement.
// You can render it for test, but do not export to STL.
//
// ============================================================================

include <definitions.scad>
use <gears.scad>

module lever_plate_gear() {
    translate([0, 0, (PLATE2_WHEEL_HEIGHT)]) {
        gears_pinion();
        
        // screw barrel
        SCREW_BARREL_THICKNESS = 1.7;
        barrel(gears_pinion_radius(inner=true) - PLAY*2,
               SCREW2_DIAMETER/2 + TOLERANCE,
               GEARS_THICKNESS + TOLERANCE);   
    }
}

module lever_plate_neck() {
    scale([1, 1, PLATE2_WHEEL_HEIGHT])
    cylinder(r=PINION_NECK_RADIUS);
}

module lever_plate_crown() {
    // base crown
    barrel(PLATE2_RADIUS, GEARS_DISTANCE + PLATE2_GROVE_THICKNESS/2, PLATE2_WHEEL_HEIGHT);
}

module lever_plate_bar() {
    spoke(PLATE2_RADIUS, PLATE2_BAR_WIDTH, PLATE2_WHEEL_HEIGHT-PLATE2_GROVE_HEIGHT);
}

module lever_plate_lever() {
    height = PLATE2_LEVER_HEIGHT;

    lever_r1 = BLOCKS_WIDTH/2*sqrt(2);
    lever_r2 = PLATE2_BOX_INNER_HOLE_DIAMETER/2;
    lever_length = (lever_r1*3 + lever_r2)/4;

    thickness = CUBE_LEVER_THICKNESS;
    length = lever_length - thickness/2;

    difference() {
        translate([0, -thickness/2, 0])
        cube([length, thickness, height]);        

        translate([0, 0, -ATOM])
        cylinder(r=PLATE2_RADIUS, height + 2*ATOM, true);
    }

}

module lever_plate_grove() {
    translate([0, 0, PLATE2_WHEEL_HEIGHT-PLATE2_GROVE_HEIGHT])
    barrel(GEARS_DISTANCE + PLATE2_GROVE_THICKNESS/2,
           GEARS_DISTANCE - PLATE2_GROVE_THICKNESS/2,
           PLATE2_GROVE_HEIGHT+ATOM);
}

module lever_plate() {
    screw_h = PLATE2_WHEEL_HEIGHT + GEARS_THICKNESS - WALL_THICKNESS*4;
     difference() {
        union() {
            // elements
            lever_plate_gear();
            lever_plate_neck();
            lever_plate_crown();

            // spokes
            for(i=[0, 60, 120])
                rotate([0, 0, i])
                lever_plate_bar();
        }
        
        // cylindric+conic screw cavity
        cylinder(r=PINION_SCREW_HEAD_RADIUS, h=screw_h);
        translate([0, 0, screw_h])
        cylinder(r1=PINION_SCREW_HEAD_RADIUS, r2=0, h=PINION_SCREW_HEAD_RADIUS);

        lever_plate_grove(); // useful?
    }    
    lever_plate_lever();
}

difference() {
    lever_plate();
//    cube(50);
}

