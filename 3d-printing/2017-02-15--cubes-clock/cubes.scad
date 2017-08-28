// ============================================================================
// NOTES:
// Library file. To be imported via the use <> statement.
// You can render it for test, but do not export to STL.
//
// ============================================================================

include <definitions.scad>
include <lib/wheel-lib.scad>
use <digits.scad>

BLOCKS_R1 = PLATE2_BOX_INNER_HOLE_DIAMETER/2;
BLOCKS_R2 = BLOCKS_R1 + WALL_THICKNESS;
BLOCKS_R3 = BLOCKS_R2 + PLAY;
BLOCKS_R4 = (BLOCKS_R3+BLOCKS_WIDTH/2)/2;

CUBE_SNAP_BALLS_POS_R = BLOCKS_R4 + CUBE_SNAP_BALLS_RADIUS*CUBE_SNAP_BALLS_K + PLAY;

function get_cube_snap_ball_pos_radius() = CUBE_SNAP_BALLS_POS_R;

show_texts = false;

echo("Cylinder =", block_cylinder);
echo("Block 1 =", BLOCK1_HEIGHT);
echo("Block 2 =", BLOCK2_HEIGHT);
echo("Block 3 =", BLOCK3_HEIGHT);
echo("Total =", BLOCK1_HEIGHT+BLOCK2_HEIGHT+BLOCK3_HEIGHT);

echo(BLOCK1_HEIGHT+BLOCK2_HEIGHT+BLOCK3_HEIGHT);

module make_block_segments(height, segments, outline=0) {
    offset = DIGIT_SEGMENT_WIDTH/2;
    margin = DIGIT_SEGMENT_WIDTH/2;

    bottom = height - offset;
    mid = height / 2;
    top = offset;
    left = -BLOCKS_WIDTH/2 + offset;
    right = BLOCKS_WIDTH/2 - offset;

    y = BLOCKS_WIDTH/2;
    
    for (i=[0:3]) rotate([0, 0, 90*i]) {
        seg = segments[i];
        digit(seg, y, left, right, top, mid, bottom, outline, margin);
    }
}

module make_block_segments_marks(height, segments) {
    make_block_segments(height, segments, TOLERANCE);
/*
    offset = DIGIT_SEGMENT_WIDTH/2;
    margin = DIGIT_SEGMENT_WIDTH/2;

    bottom = height - offset;
    margin = DIGIT_SEGMENT_WIDTH;
    mid = height / 2;
    top = offset;
    left = -BLOCKS_WIDTH/2 + offset + margin;
    right = BLOCKS_WIDTH/2 - offset - margin;

    y = BLOCKS_WIDTH/2;
    
    for (i=[0:3]) rotate([0, 0, 90*i]) {
        seg = segments[i];

        if (show_texts)
            %translate([0, y, mid])
            text(str(seg));

        digit_marks(seg, y, left, right, top, mid, bottom);
    }
*/
}

module make_block_body(height, segments, with_ghosted_segments=true) {
    color("white")
    difference() {
        // outer shape
        translate([-BLOCKS_WIDTH/2, -BLOCKS_WIDTH/2, 0])
        cube([BLOCKS_WIDTH, BLOCKS_WIDTH, height]);
        
        // segment gluing marks
        make_block_segments_marks(height, segments);
    }

    if (with_ghosted_segments)
        %color("black")
        make_block_segments(height, segments);
    else
        make_block_segments(height, segments);
}

module make_block_features(height, is_closed, has_full_crown, has_guide, has_marks, 
                           segments, with_ghosted_segments=true) {
    difference() {
        union() {
            difference() {
                // outer shape
                make_block_body(height, segments, with_ghosted_segments);
                
                // central chamber
                translate([0, 0, -ATOM])
                scale([1, 1, height+ATOM*2])
                cylinder(r=BLOCKS_R1, true);

                if(has_guide) {
                    // remove cone to create bottom chamfer
                    translate([0, 0, BLOCKS_R3/2 + CUBE_CROWN_HEIGHT -ATOM])
                    cylinder(h=BLOCKS_R3+ATOM*2, r1=BLOCKS_R3, r2=0, center=true); 

                    // remove cylinder to create radial play, below chamfer
                    translate([0, 0, (CUBE_CROWN_HEIGHT)/2-ATOM])
                    cylinder(h=CUBE_CROWN_HEIGHT+ATOM*2, r=BLOCKS_R3, center=true);
                }
            }

            // crown
            translate([0, 0, height])
            barrel(BLOCKS_R2, BLOCKS_R1, has_full_crown ? CUBE_CROWN_HEIGHT : CUBE_CROWN_SHORT_HEIGHT);

            // ring to reduce friction
            translate([0, 0, height])
            barrel(BLOCKS_R4+CUBE_SNAP_BALLS_RADIUS*CUBE_SNAP_BALLS_K, BLOCKS_R2, BLOCKS_JOIN);
            
            // snap balls
            for (i=[0:3])
                rotate([0, 0, 30 + 90*i])
                translate([0, get_cube_snap_ball_pos_radius(), height+PLAY/2])
                scale([CUBE_SNAP_BALLS_K, CUBE_SNAP_BALLS_K, 1]) {
                    sphere(CUBE_SNAP_BALLS_RADIUS, true);

                    translate([0, 0, -BLOCKS_JOIN])
                    cylinder(h=BLOCKS_JOIN, r=CUBE_SNAP_BALLS_RADIUS);
                }
            
            if (is_closed) {
                // top closing plate
                translate([-BLOCKS_WIDTH/2, -BLOCKS_WIDTH/2, 0])
                cube([BLOCKS_WIDTH, BLOCKS_WIDTH, WALL_THICKNESS]);
            }
        }

        // lever cavity
        lever_cavity_thickness = CUBE_LEVER_THICKNESS+PLAY;
        lever_r1 = BLOCKS_WIDTH/2*sqrt(2);
        lever_r2 = BLOCKS_R1;
        lever_length = (lever_r1*3 + lever_r2)/4;
        r = 2;
        rotate([0, 0, 45])
        if (0)
            // rounded
            translate([0, -lever_cavity_thickness/2 +r, r + WALL_THICKNESS])
            minkowski() {
                cube([lever_length-r*2, lever_cavity_thickness-r*2, height-CUBE_CROWN_HEIGHT]);
                sphere(r=r);
        }
        else
            // not rounded
            translate([0, -lever_cavity_thickness/2, WALL_THICKNESS])
            cube([lever_length, lever_cavity_thickness, height-CUBE_CROWN_HEIGHT]);
                
        
        // snap mark
        if (has_marks) {
            make_block_snap_marks();
        }
    }
}

module make_block_snap_marks() {
    r = CUBE_SNAP_BALLS_RADIUS + PLAY/2; // <== ADJUST
    r = CUBE_SNAP_BALLS_RADIUS + PLAY/2.5; // <== ADJUST
    r = CUBE_SNAP_BALLS_RADIUS + PLAY/2.3; // <== ADJUST
    for (i=[0:3])
        rotate([0, 0, 30 + 90*i])
        translate([0, CUBE_SNAP_BALLS_POS_R, 0])
        scale([CUBE_SNAP_BALLS_K, CUBE_SNAP_BALLS_K, CUBE_SNAP_BALLS_K])
        sphere(r, true);
}

module make_block(height, is_closed, has_crown, has_guide, has_marks, segments, draft, with_ghosted_segments=true) {
    if (draft)
        make_block_body(height, segments, with_ghosted_segments);
    else
        make_block_features(height, is_closed, has_crown, has_guide, has_marks, segments, draft, with_ghosted_segments);
}

module bottom_block(draft=false, with_ghosted_segments=true) {
    segs_low = ["e", "f", "g", "h"];
    make_block(BLOCK1_HEIGHT, false, false, true, true, segs_low, draft, with_ghosted_segments);
}

module mid_block(draft=false, with_ghosted_segments=true) {
    segs_mid = ["i", "j", "k", 0];
    make_block(BLOCK2_HEIGHT , false, true, true, true, segs_mid, draft, with_ghosted_segments);
}

module top_block(draft=false, with_ghosted_segments=true) {
    segs_top = ["a", "b", "c", "d"];
    make_block(BLOCK3_HEIGHT, true, true, false, false, segs_top, draft, with_ghosted_segments);
}

module test_one_collapsed_block() {
    intersection() {
        make_block(5 , false, true, true, true, [0, 0, 0, 0]);
        if (0)
            cube([BLOCKS_WIDTH, BLOCKS_WIDTH, BLOCKS_WIDTH]);
    }
}

module test_all_blocks() {
    space = 7;
    shift = BLOCKS_WIDTH/2 + space;
    
    translate([-shift, -shift, 0])
    bottom_block();

    // mid block
    translate([shift, -shift, 0])
    mid_block();
    
    // top block
    translate([shift, shift, 0])
    top_block();
}

module test_one_stack(what) {
    all_rots = [
        [270, 270, 270],
        [0, 0, 0],
        [90, 90, 90],
        [180, 90, 90],
        [0, 90, 0],
        [180, 90, 180],
        [270, 90, 180],
        [0, 0, 90],
        [270, 90, 270],
        [180, 90, 270],
    ];
    rots = all_rots[what];

    rotate([0, 0, rots[0]])
    flip(BLOCK1_HEIGHT + CUBE_CROWN_HEIGHT)
    bottom_block(draft=true, with_ghosted_segments=false);
    
    z1 = BLOCK1_HEIGHT + CUBE_CROWN_HEIGHT + TOLERANCE;
    rotate([0, 0, rots[1]])
    translate([0, 0, z1])
    flip(BLOCK2_HEIGHT_STACKABLE)
    mid_block(draft=true, with_ghosted_segments=false);

    z2 = z1 + BLOCK2_HEIGHT_STACKABLE + TOLERANCE;
    rotate([0, 0, rots[2]])
    translate([0, 0, z2])
    flip(BLOCK3_HEIGHT_STACKABLE)
    top_block(draft=true, with_ghosted_segments=false);
}

//test_one_collapsed_block();
//test_all_blocks();

union() {
    time = $t*100;
    
    unit = time%10;
    tens = floor(time/10);
    echo(time, tens, unit);

    test_one_stack(unit);

    translate([-BLOCKS_WIDTH-5, 0, 0])
    test_one_stack(tens);

    *cube([BLOCKS_WIDTH, BLOCKS_WIDTH, BLOCKS_WIDTH*10]);
}
