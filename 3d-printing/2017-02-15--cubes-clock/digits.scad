// ============================================================================
// NOTES:
// Library file. To be imported via the use <> statement.
// You can render it for test, but do not export to STL.
//
// ============================================================================

include <definitions.scad>

DIGIT_SEGMENT_THICKNESS = 1;
DIGIT_MARK_RADIUS = 1;

module digit_block_dot(outline) {
    width = DIGIT_SEGMENT_WIDTH + outline*2;
    thickness = DIGIT_SEGMENT_THICKNESS + (outline ? TOLERANCE : 0);
    k = 1 - 2 * thickness / width;

    rotate([90, 0, 0])
    translate([0, 0, outline ? 0 : -ATOM])
    linear_extrude(height=thickness, scale=k)
    circle(d=width);
}

module digit_block_square(outline) {
    width = DIGIT_SEGMENT_WIDTH + outline*2;
    thickness = DIGIT_SEGMENT_THICKNESS + (outline ? TOLERANCE : 0);
    k = 1 - 2 * thickness / width;

    rotate([90, 0, 0])
    translate([0, 0, outline ? 0 : -ATOM])
    linear_extrude(height=thickness, scale=k)
    translate([-width/2, -width/2, 0])
    square(width);
}

module digit_block_dot_at(outline, x, y, z) {
    translate([x, y, z])
    digit_block_dot(outline);
//    digit_block_square();
}

module digit_block_square_at(outline, x, y, z) {
    translate([x, y, z])
    digit_block_square(outline);
}

module digit_draw(outline, y, path) {
    n = len(path);
    if (n==1) {
        digit_block_square_at(outline, path[0][0], y, path[0][1]);
    }
    else if (n==2)
        hull() {
            digit_block_square_at(outline, path[0][0], y, path[0][1]);
            digit_block_square_at(outline, path[1][0], y, path[1][1]);
        }
    else {
        for (i=[0:n-2]) {
            if (len(path[i]) == 0)
                ; // if first point is emprh, skip it so we will start with a dot not a square
            else if (i==0)
                hull() {
                    digit_block_square_at(outline, path[i][0], y, path[i][1]);
                    digit_block_dot_at(outline, path[i+1][0], y, path[i+1][1]);
                }
            else if (i==n-2)
                hull() {
                    digit_block_dot_at(outline, path[i][0], y, path[i][1]);
                    digit_block_square_at(outline, path[i+1][0], y, path[i+1][1]);
                }
            else
                hull() {
                    digit_block_dot_at(outline, path[i][0], y, path[i][1]);
                    digit_block_dot_at(outline, path[i+1][0], y, path[i+1][1]);
                }
        }
    }
}

module digit(seg, y, left, right, top, mid, bottom, outline, margin) {
    left2   = left   + margin;
    right2  = right  - margin;
    top2    = top    + margin;
    bottom2 = bottom - margin;

    left0   = left   + TOLERANCE;
    right0  = right  - TOLERANCE;
    top0    = top    + TOLERANCE;
    bottom0 = bottom - TOLERANCE;
    
    if (seg=="a") digit_draw(outline, y, [
        [left2, bottom0],
        [left2, top2],
        [right2, top2],
        [right2, bottom0],
    ]);
    else if (seg=="b") digit_draw(outline, y, [
        [],
        [left2, bottom0],
        [right2, top2],
        [right2, bottom0],
    ]);
    else if (seg=="c") digit_draw(outline, y, [
        [left2, top2],
        [right2, top2],
        [right2, bottom0],
    ]);
    else if (seg=="d") digit_draw(outline, y, [
        [left2, bottom0],
        [left2, top2],
        [right2, top2],
    ]);

    else if (seg=="j") digit_draw(outline, y, [
        [right2, mid],
    ]);
    else if (seg=="i") {
        digit_draw(outline, y, [[left2, mid]]);
        digit_draw(outline, y, [[right2, mid]]);
    }
    else if (seg=="k") digit_draw(outline, y, [
        [left2, mid],
        [right2, mid],
    ]);

    else if (seg=="e") digit_draw(outline, y, [
        [left2, top0],
        [left2, bottom2],
        [right2, bottom2],
        [right2, top0],
    ]);
    else if (seg=="f") digit_draw(outline, y, [
        [right2, bottom2],
        [right2, top0],
    ]);
    else if (seg=="g") digit_draw(outline, y, [
        [left2, top0],
        [left2, bottom2],
        [right2, bottom2],
    ]);
    else if (seg=="h") digit_draw(outline, y, [
        [left2, bottom2],
        [right2, bottom2],
        [right2, top0],
    ]);
}

/*
module digit_marks(seg, y, left, right, top, mid, bottom) {
    r = DIGIT_MARK_RADIUS + TOLERANCE;
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

    if (seg=="i") // mid-left
        translate([left, y, mid])
        sphere(r, true);
    if (seg=="i" || seg=="j") // mid-right
        translate([right, y, mid])
        sphere(r, true);

    if (seg=="k") // mid-left
        translate([left, y, mid])
        sphere(r, true);
    if (seg=="k") // mid-left
        translate([right, y, mid])
        sphere(r, true);
}
*/