include <definitions.scad>
include <gears.scad>

PINION_NECK_RADIUS = 6.5;
PINION_SCREW_HEAD_RADIUS = 3 + PLAY;
PINION_HEIGHT = PINION_THICKNESS;

PLATE2_H4 = 7;
PLATE2_H3 = 5.5;
PLATE2_H2 = 5;
PLATE2_H1 = 3;

PLATE2_R5 = PLATE_DIAMETER/2;
PLATE2_R4 = PLATE2_R5 - 1;
PLATE2_R3 = PLATE2_R4 - 1;
PLATE2_R2 = PLATE2_R3 - 1.5;
PLATE2_R1 = PLATE2_R2 - 1.5;
PLATE2_R1 = PLATE2_R5 - 7;

PLATE2_R32 = (PLATE2_R2-0.5);

PLATE2_BAR_SPACE = 0.4;
PLATE2_RING_THICKNESS = 0.7 * 2;

PLATE2_RATCHET_RADIUS = 1;

PLATE2_SPRING_THICKNESS = 0.7;
PLATE2_SPRING_HEIGHT = 1;

PLATE2_BAR_WIDTH = 5;
PLATE2_BAR_ANGLE = 20;

PLATE2_NECK_HEIGHT = PLATE2_H4 - PINION_HEIGHT + 0.5;
PLATE2_CROWN_HEIGHT = PLATE2_H4 - PLATE2_H3;

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
    difference() {
        // base crown
        barrel(PLATE2_R4, PLATE2_R1, 1);

        // slots
        for (a=[-PLATE2_BAR_ANGLE/2:PLATE2_BAR_ANGLE/2:PLATE2_BAR_ANGLE/2])
            rotate([0, 0, a])
            spoke(PLATE2_R32 + PLATE2_BAR_SPACE,
                  PLATE2_BAR_WIDTH, PLATE2_CROWN_HEIGHT);

        // alignment holes
        alignment_columns(TOLERANCE);
    }
    
    // barrel
    difference() {
        barrel(PLATE2_R5, PLATE2_R4, PLATE2_H4);
        plate2_ratchet_holes();
    }
    
    // ring
    r = PLATE2_RING_THICKNESS/2;
    translate([0, 0, PLATE2_H4 - r])

    rotate_extrude(convexity = 10)
    translate([PLATE2_R4, 0, 0])
    circle(r=r);
    
    
}

module plate2_ratchet_holes() {
    for(i=[0, 90])
        rotate([0, 0, i])
        translate([0, 0, PLATE2_H4-PLATE2_H1])
        rotate([0, 90, 0])
        scale([1, 1, PLATE2_R5*2.5])
        translate([0, 0, -0.5])
        cylinder(r=PLATE2_RATCHET_RADIUS, true);
}

module plate2_bar() {
    spoke(PLATE2_R32, PLATE2_BAR_WIDTH, PLATE2_CROWN_HEIGHT);
}

module plate2_spring() {
    scale([8.75, 8.75, PLATE2_SPRING_HEIGHT])
    linear_extrude(height=1)
    import("plate2-spring.dxf");
}

module plate2() {
    difference() {
        union() {
            plate2_gear();
            plate2_neck();
            plate2_spring();
            plate2_bar();
        }
        
        translate([0, 0, PLATE2_NECK_HEIGHT-PINION_SCREW_HEAD_RADIUS+PLAY])
        sphere(r=PINION_SCREW_HEAD_RADIUS);
    }
    plate2_crown();
}

plate2();