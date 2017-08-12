include <definitions.scad>
use <gears.scad>

module plate2_gear() {
    translate([0, 0, (PLATE2_WHEEL_HEIGHT)]) {
        gears_pinion();
        
        // screw barrel
        SCREW_BARREL_THICKNESS = 1.7;
        barrel(gears_pinion_radius(inner=true) - PLAY*2,
               SCREW2_DIAMETER/2 + TOLERANCE,
               GEARS_THICKNESS + TOLERANCE);   
    }
}

module plate2_neck() {
    scale([1, 1, PLATE2_WHEEL_HEIGHT])
    cylinder(r=PINION_NECK_RADIUS);
}

module plate2_crown() {
    // base crown
    barrel(PLATE2_RADIUS, GEARS_DISTANCE + PLATE2_GROVE_THICKNESS/2, PLATE2_WHEEL_HEIGHT);
}

module plate2_bar() {
    spoke(PLATE2_RADIUS, PLATE2_BAR_WIDTH, PLATE2_WHEEL_HEIGHT-PLATE2_GROVE_HEIGHT);
}

module plate2_lever() {
    height = PLATE2_LEVER_HEIGHT;

    lever_r1 = BOX_SIDE/2*sqrt(2);
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

module plate2_grove() {
    translate([0, 0, PLATE2_WHEEL_HEIGHT-PLATE2_GROVE_HEIGHT])
    barrel(GEARS_DISTANCE + PLATE2_GROVE_THICKNESS/2,
           GEARS_DISTANCE - PLATE2_GROVE_THICKNESS/2,
           PLATE2_GROVE_HEIGHT+ATOM);
}

module plate2() {
    difference() {
        union() {
            plate2_gear();
            plate2_neck();
            plate2_crown();

            for(i=[0, 60, 120])
                rotate([0, 0, i])
                plate2_bar();
        }
        sphere(r=PINION_SCREW_HEAD_RADIUS);
        plate2_grove();
    }    
    plate2_lever();
}

difference() {
    plate2();
//    cube(50);
}

