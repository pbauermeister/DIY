include <gears.scad>


PINION_GROUP_H4 = 8;
PINION_GROUP_H3 = 6;
PINION_GROUP_H2 = 5;
PINION_GROUP_H1 = 4;

PINION_GROUP_R5 = PLATE_DIAMETER;
PINION_GROUP_R4 = PINION_GROUP_R5 - 4;
PINION_GROUP_R3 = PINION_GROUP_R4 - 1;
PINION_GROUP_R2 = PINION_GROUP_R3 - 2;
PINION_GROUP_R1 = PINION_GROUP_R2 - 2;

PINION_GROUP_R32 = (PINION_GROUP_R2-0.5);

PINION_NECK_RADIUS = 7;

SPRING_THICKNESS = 0.6;
BAR_THICKNESS = 5;

crown_thickness = PINION_GROUP_H4 - PINION_GROUP_H3;

module arc(radius, rotation) {
    rotate([0, 0, rotation])
    translate([radius/2 , 0, 0])
    scale([1, 1, crown_thickness])
    difference() {
        cylinder(r=radius/2);
        
        translate([0, 0, -0.5]) scale([1, 1, 2])
        cylinder(r=radius/2 - SPRING_THICKNESS);
        
        translate([-radius, 0, -ATOM])
        cube([radius*2, radius, crown_thickness + ATOM*2]);
    }
}

module bar(radius, thickness) {
    translate([0, 0, crown_thickness/2])
    cube([radius*2, thickness, crown_thickness], true);
}

// Gear
translate([0, 0, (PINION_GROUP_H4 - PINION_THICKNESS)])
make_gears(GEAR_BEVEL_PAIR_ONLY_PINION_FLAT);

// Neck
scale([1, 1, PINION_GROUP_H4 - PINION_THICKNESS + 0.5])
cylinder(r=PINION_NECK_RADIUS);

// Crown
scale([1, 1, crown_thickness])
difference() {
    cylinder(r=PINION_GROUP_R4 - PLAY);

    translate([0, 0, -0.5]) scale([1, 1, 2])
    cylinder(r=PINION_GROUP_R1);

    for (a=[-10:5:10])
        rotate([0, 0, a])
        bar(PINION_GROUP_R32+0.5, BAR_THICKNESS+1);
}

// Spring
arc(PINION_GROUP_R3, -45);
arc(PINION_GROUP_R3, 180-45);

bar(PINION_GROUP_R32, BAR_THICKNESS);
