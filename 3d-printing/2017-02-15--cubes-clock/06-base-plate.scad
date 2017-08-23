// ============================================================================
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 15%
//
// ============================================================================

include <definitions.scad>
use <02-primary-plate.scad>
use <04-holder.scad>
use <05-cubes.scad>

BASE_CROWN_MEDIAN_RADIUS = PLATE2_BOX_INNER_HOLE_DIAMETER/2;
BASE_CROWN_OUTER_RADIUS = BASE_CROWN_MEDIAN_RADIUS + WALL_THICKNESS;

BASE_OUTER_HEIGHT = CUBE_CROWN_HEIGHT;
BASE_MEDIAN_HEIGHT = 7;
BASE_SCREW_POS_RADIUS = BASE_CROWN_MEDIAN_RADIUS - SCREW2_HEAD_DIAMETER/2 - PLAY - WALL_THICKNESS;

module base_plate_holder_cavity() {
    height = BASE_MEDIAN_HEIGHT + 2*ATOM;
    difference() {
        rotate([0, 0, 180 - HOLDER_ANGLE/2])
        translate([0, 0, -ATOM])
        intersection() {
            cylinder(r=PLATE_DIAMETER/2+HOLDER_THICKNESS+PLAY, h=height);
            cube([PLATE_DIAMETER, PLATE_DIAMETER, height]);
            rotate([0, 0, HOLDER_ANGLE-90])
            cube([PLATE_DIAMETER, PLATE_DIAMETER, height]);
        }
    }
    translate([0, 0, -ATOM])
    cylinder(r=PLATE_DIAMETER/2, h=height);
}

module base_plate_lower_plate() {
    r = get_cube_snap_ball_pos_radius() + CUBE_SNAP_BALLS_RADIUS*CUBE_SNAP_BALLS_K*2 + WALL_THICKNESS;

    difference() {
        cylinder(r=r, h=BASE_OUTER_HEIGHT);
        translate([0, 0, -ATOM])
        cylinder(r=PLATE_DIAMETER/2, h=BASE_OUTER_HEIGHT+2*ATOM);

        // snap marks
        translate([0, 0, BASE_OUTER_HEIGHT])
        rotate([0, 0, 45]) flip(0)
        make_block_snap_marks();
        
        // grove
        translate([0, 0, CUBE_CROWN_HEIGHT - CUBE_CROWN_SHORT_HEIGHT - TOLERANCE])
        barrel(BASE_CROWN_MEDIAN_RADIUS + WALL_THICKNESS + PLAY/2,
               BASE_CROWN_MEDIAN_RADIUS - PLAY/2, CUBE_CROWN_HEIGHT);
    }
}

module base_plate_median_plate() {
    cylinder(r=BASE_CROWN_MEDIAN_RADIUS - PLAY/2, h=BASE_MEDIAN_HEIGHT);
}

module base_plate_screws_holes() {
    for (i=[0:3]) {
        rotate([0, 0, 90*i + 45])
        translate([BASE_SCREW_POS_RADIUS, 0, WALL_THICKNESS*2])
        screw(head_extent=PLATE_THICKNESS, is_clearance_hole=true);            
    }
}

module base_plate_screws() {
    %for (i=[0:3]) {
        rotate([0, 0, 90*i + 45])
        translate([BASE_SCREW_POS_RADIUS, 0, WALL_THICKNESS*2])
        screw();            
    }
}

module base_plate_parts() {
    // plate
    flip(PLATE_HEIGHT_SHORT)
    difference() {
        primary_plate(is_short=true);

        translate([0, 0, PLATE_HEIGHT_SHORT])
        cylinder(r=PLATE_DIAMETER, h= PLATE_THICKNESS);
}

    // support plates
    rotate([0, 0, 45]) {
        difference() {
            union() {
                base_plate_lower_plate();
                base_plate_median_plate();
            }
            base_plate_holder_cavity();
        }
    }
}

module base_plate() {
    difference() {
        base_plate_parts();

        rotate([0, 0, 45]) {
            base_plate_screws_holes();
        }
    }

    rotate([0, 0, 45])
    base_plate_screws();
}

base_plate();
