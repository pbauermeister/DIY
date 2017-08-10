include <definitions.scad>
include <gears.scad>

OUTER_CROWN_INNER_DIAMETER = 60;

module plate2_gear() {
    translate([0, 0, (PLATE2_H4 - PINION_HEIGHT)])
    make_gears(GEAR_BEVEL_PAIR_ONLY_PINION_FLAT);
}

module plate2_neck() {
    scale([1, 1, PLATE2_NECK_HEIGHT])
    cylinder(r=PINION_NECK_RADIUS);
}

module plate2_crown() {
    scale([1, 1, PLATE2_CROWN_HEIGHT])
    // base crown
    barrel(PLATE2_R4, PLATE2_R1, 1);
    
    // screw barrel
    SCREW_BARREL_THICKNESS = 1.7;
    barrel(SCREW_THREAD_DIAMETER/2 + SCREW_BARREL_THICKNESS,
           SCREW_THREAD_DIAMETER/2 + TOLERANCE,
           PLATE2_HEIGHT);
    
    // outer barrel
    barrel(PLATE2_R5, PLATE2_R4, PLATE2_HEIGHT - PLAY/2);
    
    // ring
    r = PLATE2_RING_THICKNESS/2;
    translate([0, 0, PLATE2_H4 - r - PLAY/2])
    rotate_extrude(convexity = 10)
    translate([PLATE2_R4, 0, 0])
    circle(r=r);
}

module plate2_bar() {
    spoke(PLATE2_R32, PLATE2_BAR_WIDTH, PLATE2_CROWN_HEIGHT);
}


module plate2_arm() {
//    height = PLATE2_HEIGHT - PLAY;
    height = WALL_THICKNESS * 2;
    scale([1, 1, height])
    intersection() {
        difference() {
            // arm
            f = 10 * PLATE_DIAMETER/46;
            scale([f, f, 1])
            linear_extrude(height=1)
            import("plate2-arm.dxf");
        
            // carve inner
            cylinder(r=PLATE2_R4, h=1.1);
        }
        // remove outer
        cylinder(r=PLATE2_BOX_INNER_HOLE_DIAMETER/2, h=1.1);
    }
}

module plate2_box() {
    // bottom
    difference() {
        translate([0, 0, WALL_THICKNESS/2])
        cube([BOX_SIDE, BOX_SIDE, WALL_THICKNESS], true);

        translate([0, 0, -WALL_THICKNESS])
        scale([1, 1, WALL_THICKNESS*3])
        cylinder(r=PLATE2_BOX_INNER_HOLE_DIAMETER/2, true);
    }
    
    // inner side (cylinder)
    h = PLATE2_HEIGHT - PLAY;
    barrel(PLATE2_BOX_INNER_HOLE_DIAMETER/2 +WALL_THICKNESS,
           PLATE2_BOX_INNER_HOLE_DIAMETER/2, h);

    // outer sides (box)
    box_sides(BOX_SIDE, WALL_THICKNESS, h);
}

module plate2_lever() {
    height = PLATE2_HEIGHT /2;

    lever_r1 = BOX_SIDE/2*sqrt(2);
    lever_r2 = PLATE2_BOX_INNER_HOLE_DIAMETER/2;
    lever_length = (lever_r1*3 + lever_r2)/4;

    thickness = CUBE_LEVER_THICKNESS;
    length = lever_length - thickness/2;

    difference() {
        translate([0, -thickness/2, 0])
        cube([length, thickness, height]);        

        translate([0, 0, -ATOM])
        cylinder(r=PLATE2_R4,height + 2*ATOM, true);
    }

}

module plate2() {
    difference() {
        union() {
            plate2_gear();
            plate2_neck();
            plate2_bar();
            plate2_crown();
        }
        translate([0, 0, PLATE2_NECK_HEIGHT-PINION_SCREW_HEAD_RADIUS+PLAY])
        sphere(r=PINION_SCREW_HEAD_RADIUS);
    }    
//    plate2_arm();
//    plate2_box();
    plate2_lever();
}

difference() {
    plate2();
//    cube(50);
}

