include <definitions.scad>
include <gears.scad>


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
    
    // barrel
    barrel(PLATE2_R5, PLATE2_R4, PLATE2_H4);
    
    // ring
    r = PLATE2_RING_THICKNESS/2;
    translate([0, 0, PLATE2_H4 - r])
    rotate_extrude(convexity = 10)
    translate([PLATE2_R4, 0, 0])
    circle(r=r);
}

module plate2_bar() {
    spoke(PLATE2_R32, PLATE2_BAR_WIDTH, PLATE2_CROWN_HEIGHT);
}


module plate2() {
    difference() {
        union() {
            plate2_gear();
            plate2_neck();
            plate2_bar();
        }
        translate([0, 0, PLATE2_NECK_HEIGHT-PINION_SCREW_HEAD_RADIUS+PLAY])
        sphere(r=PINION_SCREW_HEAD_RADIUS);
    }
    plate2_crown();
}

difference() {
    plate2();
//    cube(50);
}

