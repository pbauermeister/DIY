// ============================================================================
// NOTES:
// Library file. To be imported via the use <> statement.
// You can render it for test, but do not export to STL.
//
// ============================================================================

include <definitions.scad>
use <center-plate.scad>
use <holder.scad>
use <cubes.scad>

BASE_CROWN_MEDIAN_RADIUS = PLATE2_BOX_INNER_HOLE_DIAMETER/2;
BASE_CROWN_OUTER_RADIUS = BASE_CROWN_MEDIAN_RADIUS + WALL_THICKNESS;

BASE_SCREW_POS_RADIUS = BASE_CROWN_MEDIAN_RADIUS - SCREW2_HEAD_DIAMETER/2 - PLAY - WALL_THICKNESS;

module base_plate_cavity(angle, radius, disc) {
    height = BASE_PLATE_CROWN_HEIGHT + 2*ATOM;
    difference() {
        // cable or holder cavity
        rotate([0, 0, 180 - angle/2])
        translate([0, 0, -ATOM])
        intersection() {
            cylinder(r=radius, h=height);
            cube([PLATE_DIAMETER, PLATE_DIAMETER, height]);
            rotate([0, 0, angle-90])
            cube([PLATE_DIAMETER, PLATE_DIAMETER, height]);
        }
        
        if (!disc)
            translate([0, 0, -ATOM*2])
            cylinder(r=PLATE_DIAMETER/2, h=height+ATOM*4);
    }
    if (disc)
        translate([0, 0, -ATOM])
        cylinder(r=PLATE_DIAMETER/2 - TOLERANCE, h=height);
}

module base_plate_holder_cavity() {
    base_plate_cavity(HOLDER_ANGLE, PLATE_DIAMETER/2+HOLDER_THICKNESS+PLAY, true);
}

module base_plate_cables_cavity() {
    radius = PLATE_DIAMETER/2+HOLDER_THICKNESS-PLAY;
    height = 3;
    width = 5;
    angle = 45;
    radius2 = PLATE_DIAMETER/2+HOLDER_THICKNESS/2;

    base_plate_cavity(angle*2, radius, false);


    union() {
        // cable canal
        rotate([0, 0, angle])
        translate([-radius2/2 -width/2, width/2, 0])
        cube([radius2-width, width, height*2 +ATOM*2], true);
     
        // cable canal
        rotate([0, 0, -angle])
        translate([-radius2/4, -width/2, 0])
        cube([radius2*1.5, width, height*2 +ATOM*2], true);
    }
}

module base_plate_center_hole(height) {
        cylinder(r=BASE_PLATE_CAVITY_DIAMETER/2, h=height);
}

module base_plate_main_plate(has_center_hole) {
    if (has_center_hole) {
        difference() {
            flip(PLATE_HEIGHT_SHORT)
            center_plate(is_short=true, has_servo_cavities=false);
            translate([0, 0, -PLATE_HEIGHT])
            cylinder(r=PLATE_DIAMETER, h=PLATE_HEIGHT);

            translate([0, 0, -ATOM])            
            base_plate_center_hole(PLATE_HEIGHT_SHORT+ATOM*2);
        }
    }
    else {
        difference() {
            flip(PLATE_HEIGHT_SHORT)
            center_plate(is_short=true);
            translate([0, 0, -PLATE_HEIGHT])
            cylinder(r=PLATE_DIAMETER, h=PLATE_HEIGHT);
        }
    }
}

module base_plate_lower_plate() {
    r = BASE_CROWN_OUTER_RADIUS;

    difference() {
        cylinder(r=r, h=BASE_PLATE_CROWN_HEIGHT);
        
        *translate([0, 0, -ATOM])
        cylinder(r=PLATE_DIAMETER/2-PLAY, h=BASE_PLATE_CROWN_HEIGHT+2*ATOM);

        // snap marks
        *translate([0, 0, BASE_PLATE_CROWN_HEIGHT])
        rotate([0, 0, 45]) flip(0)
        make_block_snap_marks();
        
        // grove
        translate([0, 0, CUBE_CROWN_HEIGHT - CUBE_CROWN_SHORT_HEIGHT - TOLERANCE])
        barrel(BASE_CROWN_MEDIAN_RADIUS + WALL_THICKNESS + PLAY,
               BASE_CROWN_MEDIAN_RADIUS - PLAY/2, PLATE_HEIGHT);
    }
}

module base_plate_screws_holes() {
    for (i=[0:2]) {
        rotate([0, 0, 120*i])
        translate([BASE_SCREW_POS_RADIUS, 0, WALL_THICKNESS*2])
        screw(head_extent=PLATE_HEIGHT, is_clearance_hole=true);            
    }
}

module base_plate_screws() {
    for (i=[0:2]) {
        rotate([0, 0, 120*i])
        translate([BASE_SCREW_POS_RADIUS, 0, WALL_THICKNESS*2])
        screw();            
    }
}

module base_plate_parts(has_center_hole) {
    union() {
        // plate
        base_plate_main_plate(has_center_hole);
        
        // support plates
        rotate([0, 0, 45]) {
            difference() {
                base_plate_lower_plate();
                base_plate_holder_cavity();
            }
        }
    }
}

module base_plate(has_center_hole=false, with_screws=false) {
    difference() {
        base_plate_parts(has_center_hole);

        rotate([0, 0, 45]) {
            base_plate_screws_holes();
            if (!has_center_hole)
               base_plate_cables_cavity();
        }
    }

    rotate([0, 0, 45])
    if (with_screws)
        base_plate_screws();
    else
        %base_plate_screws();
}

base_plate(true);

translate([BLOCKS_WIDTH, 0, 0])
base_plate(false);
