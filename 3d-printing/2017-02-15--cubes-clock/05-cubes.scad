// ============================================================================
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 5%
//
// ============================================================================

include <definitions.scad>
include <lib/wheel-lib.scad>
//use <gears.scad>
//use <servo.scad>

cylinder = PLATE_THICKNESS + PLATE2_HEIGHT;

BLOCK1_HEIGHT = cylinder*2  + PLAY*2 - PLATE2_HEIGHT;
BLOCK2_HEIGHT = PLATE2_HEIGHT + PLAY*2;
BLOCK3_HEIGHT = cylinder*2  + PLAY*2 - PLATE2_HEIGHT;

BLOCKS_WIDTH = BOX_SIDE;

BLOCKS_R1 = PLATE2_BOX_INNER_HOLE_DIAMETER/2;
BLOCKS_R2 = BLOCKS_R1 + WALL_THICKNESS;
BLOCKS_R3 = BLOCKS_R2 + PLAY;
BLOCKS_R4 = (BLOCKS_R3+BLOCKS_WIDTH/2)/2;

echo("Cylinder =", cylinder);
echo("Block 1 =", BLOCK1_HEIGHT);
echo("Block 2 =", BLOCK2_HEIGHT);
echo("Block 3 =", BLOCK3_HEIGHT);
echo("Total =", BLOCK1_HEIGHT+BLOCK2_HEIGHT+BLOCK3_HEIGHT);

echo(BLOCK1_HEIGHT+BLOCK2_HEIGHT+BLOCK3_HEIGHT);

module make_block_segments(height, segments) {

    offset = DIGIT_SEGMENT_WIDTH/2 + 0.5;
    bottom = height - offset;
    mid = height / 2;
    top = offset;
    left = -BLOCKS_WIDTH/2 + offset;
    right = BLOCKS_WIDTH/2 - offset;

    mleft = -BLOCKS_WIDTH/2 + offset + DIGIT_SEGMENT_WIDTH*2;
    mright = BLOCKS_WIDTH/2 - offset - DIGIT_SEGMENT_WIDTH*2;

    y = BLOCKS_WIDTH/2;
    
    r = 1;
    for (i=[0:3]) rotate([0, 0, 90*i]) {
        seg = segments[i];

        %translate([0, y, mid])
        text(str(seg));
         
        if (seg=="a" || seg=="c" || seg=="d" ||
            seg=="e" || seg=="g") // top-left
            translate([left, y, top])
            sphere(r, true);
        if (seg=="a" || seg=="b" || seg=="c" || seg=="d" ||
            seg=="e" || seg=="f" || seg=="h") // top-right
            translate([right, y, top])
            sphere(r, true);
        if (seg=="a" || seg=="b" || seg=="c" ||
            seg=="e" || seg=="f" || seg=="g" || seg=="h") // bottom-right
            translate([right, y, bottom])
            sphere(r, true);
        if (seg=="a" || seg=="b" || seg=="d" ||
            seg=="e" || seg=="g" || seg=="h") // bottom-left
            translate([left, y, bottom])
            sphere(r, true);

        if (seg=="j") // mid-left
            translate([left, y, mid])
            sphere(r, true);
        if (seg=="i" || seg=="j") // mid-right
            translate([right, y, mid])
            sphere(r, true);

        if (seg=="k") // mid-left
            translate([mleft, y, mid])
            sphere(r, true);
        if (seg=="k") // mid-left
            translate([mright, y, mid])
            sphere(r, true);
        
    }
}

module make_block0(height, is_closed, has_crown, has_guide, has_marks, segments) {
    difference() {
        union() {
            difference() {
                translate([-BLOCKS_WIDTH/2, -BLOCKS_WIDTH/2, 0])
                cube([BLOCKS_WIDTH, BLOCKS_WIDTH, height]);
                
                scale([1, 1, height])
                cylinder(r=BLOCKS_R1, true);

                if(has_guide) {
                    translate([0, 0, BLOCKS_R3/2 + CUBE_CROWN_HEIGHT])
                    cylinder(h=BLOCKS_R3, r1=BLOCKS_R3, r2=0, center=true);            

                    translate([0, 0, (CUBE_CROWN_HEIGHT)/2])
                    cylinder(h=CUBE_CROWN_HEIGHT, r=BLOCKS_R3, center=true);
                }
            }

            if (has_crown) {
                // crown
                translate([0, 0, height])
                barrel(BLOCKS_R2, BLOCKS_R1, CUBE_CROWN_HEIGHT);

                // ring to reduce friction
                translate([0, 0, height])
                barrel(BLOCKS_R4+CUBE_SNAP_BALLS_RADIUS, BLOCKS_R2, PLAY/2);
                
                // snap balls
                pos = BLOCKS_R4;
//                h = PLAY/1.5;
                h = PLAY;
                for (i=[0:3])
                    rotate([0, 0, 30 + 90*i])
                    translate([0, pos, height+PLAY/2])
                    cylinder(h=h, r=CUBE_SNAP_BALLS_RADIUS);
//                    sphere(CUBE_SNAP_BALLS_RADIUS, true);
            }
            
            if (is_closed) {
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
        translate([0, -lever_cavity_thickness/2 +r, r + WALL_THICKNESS])
        minkowski() {
            cube([lever_length-r*2, lever_cavity_thickness-r*2, height*2]);
            sphere(r=r);
        }
        
        // snap mark
        if (has_marks) {
            pos = BLOCKS_R4;
            for (i=[0:3])
                rotate([0, 0, 30 + 90*i])
                translate([0, pos, 0])
                sphere(CUBE_SNAP_BALLS_RADIUS+PLAY*2, true);
        }
        make_block_segments(height, segments);
    }
}

module make_block(height, is_closed, has_crown, has_guide, has_marks, segments) {
    intersection() {
        make_block0(height, is_closed, has_crown, has_guide, has_marks, segments);

        if(0)
            translate([BLOCKS_WIDTH/6, BLOCKS_WIDTH/6, 0])
            cube([BLOCKS_WIDTH, BLOCKS_WIDTH, height*2]);
    }
}


if(0) {
    // test block
    segs_mid = ["i", "j", "k", 0];
    translate([BLOCKS_WIDTH + 15, 0, 0])
    make_block(BLOCK2_HEIGHT /10 , false, true, true, true, segs_mid);
}
else {
    //// bottom block
    segs_low = ["e", "f", "g", "h"];
    make_block(BLOCK1_HEIGHT, false, true, true, true, segs_low);

    // mid block
    segs_mid = ["i", "j", "k", 0];
    translate([BLOCKS_WIDTH + 15, 0, 0])
    make_block(BLOCK2_HEIGHT , false, true, true, true, segs_mid);

    // top block
    segs_top = ["a", "b", "c", "d"];
    translate([BLOCKS_WIDTH*2 + 15*2, 0, 0])
    make_block(BLOCK3_HEIGHT, true, true, false, false, segs_top);
}