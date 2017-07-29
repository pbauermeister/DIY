//
// GENERAL
//
PLAY = 0.4;
TOLERANCE = 0.17;
ATOM = 0.01;

//
// SPECIFIC
//

// Screws
SCREW_SHAFT_DIAMETER = 2;
SCREW_THREAD_DIAMETER = 2.5;
SCREW_HOLE_LENGTH = 5;

SCREW_PLATE_THICKNESS = 1;

// Plate
PLATE_DIAMETER = 46;
PLATE_SCREWS_BORDER_DISTANCE = 4;
PLATE_THICKNESS = 20.5;

// Snapping
SNAP_HOLE_DIAMETER = 4;

//
// HELPERS
//

module spoke(radius, width, height) {
    translate([0, 0, height/2])
    intersection() {
        cube([radius*3, width, height], true);

        translate([0, 0, -height/2])
        scale([1, 1, height])
        cylinder(r=radius, true);
    }
}

module barrel(outer_radius, inner_radius, height) {
    scale([1, 1, height])
    difference() {
        cylinder(r=outer_radius);
        translate([0, 0, -0.5]) scale([1, 1, 2])
        cylinder(r=inner_radius);
    }
}

module alignment_columns(column_extra) {
    r = PLATE_DIAMETER/2 - PLATE_SCREWS_BORDER_DISTANCE;
    n = 4;
    offset_angle = 45;
    for(a=[0:n-1])
        rotate([0, 0, a*360/n + offset_angle])
        translate([0, r, 0])
        cylinder(r=SNAP_HOLE_DIAMETER/2 + column_extra, true);        
}