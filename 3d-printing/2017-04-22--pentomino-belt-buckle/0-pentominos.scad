/*
PENTOMINO BLOCKS GENERATOR
==========================

(C) 2017 by Pascal Bauermeister.
License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.

(This is a part of the project "Pentomino Belt Buckle", focused on the
Pentomino pieces. It can however be used standalone. The other parts, not in this
file, include: frame, belt clip.)

This OpenSCAD script generates Pentomino blocks, with tabs and cavities to
allow them to hold together.

Being completely parametric allows individual control such as:
- size and thickness,
- tolerances (important for 3D printing), and also
- creating any kind of pieces, including 2D Polyminos of N cells for any N.
*/

IS_INV = 1;

$fn = 24; // 24: high quality; 8: draft
//$fn = 8;
$fn = 16;

// BASE ETCHING
// this etches the first layer, to compensate for being wider due to being squished down
BASE_HEIGHT = 0.3;
BASE_TOLERANCE = 0.3;

// BLOCK
BLOCK_TOLERANCE = 0.15; // in mm
BLOCK_TOLERANCE = 0.00; // in mm

BLOCK_SIDE = 6.5;       // in mm
BLOCK_HEIGHT = 3;     // in mm

// GRIP
GRIP_TOLERANCE_H = 0.6; // in mm -- horizontal tolerance around grips; 
                        // more means smaller grip
GRIP_TOLERANCE_V = 0.3; // in mm -- vertical tolerance around grips;
                        // affects cavity height
GRIP_RADIUS = BLOCK_SIDE/4 - GRIP_TOLERANCE_H; // in mm
GRIP_HEIGHT = 1;      // in mm
GRIP_RADIUS2 = BLOCK_TOLERANCE;
GRIP_V_OFFSET = IS_INV ? -0.5 : 0.5;

// CAVITY
CAVITY_MARGIN = 0.4; // in mm -- For cavity to not take whole half-side and leave margin on the corner
CAVITY_RADIUS = BLOCK_SIDE/4 - CAVITY_MARGIN; // in mm
CAVITY_HEIGHT = GRIP_HEIGHT + GRIP_TOLERANCE_V; // in mm
CAVITY_RADIUS2 = BLOCK_TOLERANCE;
CAVITY_DISP = BLOCK_TOLERANCE * 2;

CAVITY_RADIUS3 = 0.7;

// MISC
ATOM = 0.0001; // a tiny value just to produce some offsets, making the 
               // results nicer in preview mode by cancelling effects of
               // boolean operations, but meant to not affect the end result
               // noticeably
_ = 0;

///////////////////////////////////////////////////////////////////////////////
// Bitmap defining the Pentomino shapes
GRID = [
    [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _],
    [_, 1, 1, 1, 1, _, _, 1, _, 1, 1, 1, _, _, _, _, _],
    [_, _, _, 1, _, _, _, 1, _, 1, _, _, _, 1, _, _, _],
    [_, _, _, _, _, _, _, 1, _, 1, _, 1, 1, 1, _, _, _], 
    [_, 1, 1, _, _, _, _, 1, _, _, _, _, 1, _, _, 1, _],
    [_, 1, _, _, _, 1, _, 1, _, _, _, _, _, _, _, 1, _],
    [_, 1, _, 1, 1, 1, _, _, _, 1, _, _, _, _, 1, 1, _],
    [_, 1, _, 1, _, _, _, _, 1, 1, 1, _, _, _, 1, _, _],
    [_, _, _, _, _, _, _, _, _, 1, _, _, _, _, _, _, _],
    [_, _, _, 1, _, _, 1, _, _, _, _, _, _, _, 1, _, _],
    [_, _, 1, 1, _, _, 1, _, _, 1, _, 1, _, 1, 1, _, _],
    [_, 1, 1, _, _, 1, 1, 1, _, 1, 1, 1, _, 1, 1, _, _],
    [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _],

//    // Chiral copies
//    [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _],
//    [_, 1, 1, 1, 1, _, 1, _, _, _, 1, 1, 1, 1, _, _, _],
//    [_, _, 1, _, _, _, 1, 1, 1, _, 1, _, _, _, _, _, _],
//    [_, _, _, _, _, _, _, 1, _, _, _, _, _, 1, _, _, _],
//    [_, _, _, 1, 1, _, _, _, _, _, 1, 1, _, 1, 1, 1, _],
//    [_, 1, 1, 1, _, _, _, _, _, 1, 1, 1, _, _, _, 1, _],
    [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _],
];


GRID_ = [
    [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _, 1, 1, 1, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _, 1, _, _, _, 1, _, _, _],
    [_, _, _, _, _, _, _, _, _, 1, _, 1, 1, 1, _, _, _], 
    [_, 1, 1, _, _, _, _, _, _, _, _, _, 1, _, _, 1, _],
    [_, 1, _, _, _, 1, _, _, _, _, _, _, _, _, _, 1, _],
    [_, 1, _, 1, 1, 1, _, _, _, 1, _, _, _, _, 1, 1, _],
    [_, 1, _, 1, _, _, _, _, 1, 1, 1, _, _, _, 1, _, _],
    [_, _, _, _, _, _, _, _, _, 1, _, _, _, _, _, _, _],
    [_, _, _, 1, _, _, 1, _, _, _, _, _, _, _, 1, _, _],
    [_, _, 1, 1, _, _, 1, _, _, 1, _, 1, _, 1, 1, _, _],
    [_, 1, 1, _, _, 1, 1, 1, _, 1, 1, 1, _, 1, 1, _, _],
    [_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _],

];

// Rename as GRID to have a single block, for tests
GRID_ = [
    [_, _, _, _, _, _, _],
    [_, _, _, _, 1, _, _],
    [_, 1, 1, 1, 1, _, _],
    [_, _, _, _, _, _, _],
    [_, _, _, _, _, _, _],
];

///////////////////////////////////////////////////////////////////////////////
// Side-level primitives

/* Generate a grip for one give side (to be added) */
module make_grip_side(x, y, side) {
    convex = (side=="n") ? GRID[y+1][x-1] || GRID[y+1][x+1] :
             (side=="s") ? GRID[y-1][x-1] || GRID[y-1][x+1] :
             (side=="e") ? GRID[y+1][x+1] || GRID[y-1][x+1] :
           /*(side=="w")*/ GRID[y+1][x-1] || GRID[y-1][x-1];
    if (!convex) {
        center = (side=="n") ? [BLOCK_SIDE*.75, BLOCK_SIDE -BLOCK_TOLERANCE*2, 0] :
                 (side=="s") ? [BLOCK_SIDE*.25,             BLOCK_TOLERANCE*2, 0] :
                 (side=="e") ? [BLOCK_SIDE -BLOCK_TOLERANCE*2, BLOCK_SIDE*.25, 0] :
               /*(side=="w")*/ [            BLOCK_TOLERANCE*2, BLOCK_SIDE*.75, 0] ;
        dh = (BLOCK_HEIGHT - GRIP_HEIGHT*2) / 2 - GRIP_V_OFFSET;

        color("yellow")
        translate([0, 0, dh])
        translate(center)
        cylinder(h=GRIP_HEIGHT, r2=GRIP_RADIUS, r1=GRIP_RADIUS2);

        color("yellow")
        translate([0, 0, GRIP_HEIGHT+dh])
        translate(center)
        cylinder(h=GRIP_HEIGHT, r1=GRIP_RADIUS, r2=GRIP_RADIUS2);
    }
}

/* Generate a cavity for one give side (to be substracted) */
module make_cavity_side(x, y, side) {
    // cavity for grip of neighbour piece
    center = (side=="n") ? [BLOCK_SIDE*.25, BLOCK_SIDE -CAVITY_DISP, 0] :
             (side=="s") ? [BLOCK_SIDE*.75,            +CAVITY_DISP, 0] :
             (side=="e") ? [BLOCK_SIDE -CAVITY_DISP, BLOCK_SIDE*.75, 0] :
           /*(side=="w")*/ [           +CAVITY_DISP, BLOCK_SIDE*.25, 0];    
    dh = (BLOCK_HEIGHT - CAVITY_HEIGHT*2) / 2 - GRIP_V_OFFSET;

    color("orange")
    translate([0, 0, dh])
    translate(center)
    cylinder(h=CAVITY_HEIGHT, r2=CAVITY_RADIUS, r1=CAVITY_RADIUS2);

    color("orange")
    translate([0, 0, CAVITY_HEIGHT+dh])
    translate(center)
    cylinder(h=CAVITY_HEIGHT, r1=CAVITY_RADIUS, r2=CAVITY_RADIUS2);

}

/* Generate an etching for one give side (to be substracted) */
module make_etch_side(x, y, side) {
    center = (side=="n") ? [BLOCK_SIDE/2,   BLOCK_SIDE] :
             (side=="s") ? [BLOCK_SIDE/2,            0] :
             (side=="e") ? [  BLOCK_SIDE, BLOCK_SIDE/2] :
           /*(side=="w")*/ [           0, BLOCK_SIDE/2];

    // main etiching
    qsize = (side=="n") ? [BLOCK_SIDE + BLOCK_TOLERANCE*2, BLOCK_TOLERANCE*2] :
            (side=="s") ? [BLOCK_SIDE + BLOCK_TOLERANCE*2, BLOCK_TOLERANCE*2] :
            (side=="e") ? [BLOCK_TOLERANCE*2, BLOCK_SIDE + BLOCK_TOLERANCE*2] :
          /*(side=="w")*/ [BLOCK_TOLERANCE*2, BLOCK_SIDE + BLOCK_TOLERANCE*2];
    tx = center[0] - qsize[0]/2;
    ty = center[1] - qsize[1]/2;

    color("green")
    translate([tx, ty, -ATOM])
    cube([qsize[0], qsize[1], BLOCK_HEIGHT + ATOM*2]);
    
    // base etiching
    qsize2 = (side=="n") ? [BLOCK_SIDE + BLOCK_TOLERANCE*2 + BASE_TOLERANCE*2, BLOCK_TOLERANCE*2 + BASE_TOLERANCE*2] :
             (side=="s") ? [BLOCK_SIDE + BLOCK_TOLERANCE*2 + BASE_TOLERANCE*2, BLOCK_TOLERANCE*2 + BASE_TOLERANCE*2] :
             (side=="e") ? [BLOCK_TOLERANCE*2 + BASE_TOLERANCE*2, BLOCK_SIDE + BLOCK_TOLERANCE*2 + BASE_TOLERANCE*2] :
          /*(side=="w")*/ [BLOCK_TOLERANCE*2 + BASE_TOLERANCE*2, BLOCK_SIDE + BLOCK_TOLERANCE*2 + BASE_TOLERANCE*2];
    tx2 = center[0] - qsize2[0]/2;
    ty2 = center[1] - qsize2[1]/2;
    color("black")
    translate([tx2, ty2, -ATOM])
    cube([qsize2[0], qsize2[1], BASE_HEIGHT + ATOM*2]);    
}

///////////////////////////////////////////////////////////////////////////////
// Block-level primitives

/* Generate a given grid block */
module make_block(x, y) {
    if (GRID[y][x]) {
        translate([x*BLOCK_SIDE, y*BLOCK_SIDE, 0])
        cube([BLOCK_SIDE, BLOCK_SIDE, BLOCK_HEIGHT]);
    }
}

/* Generate etching for a given grid block (to be substracted) */
module make_etch(x, y) {
    if (GRID[y][x]) {
        translate([x*BLOCK_SIDE, y*BLOCK_SIDE, 0]) {
            if (!GRID[y-1][x]) make_etch_side(x, y, "s");
            if (!GRID[y+1][x]) make_etch_side(x, y, "n");
            if (!GRID[y][x+1]) make_etch_side(x, y, "e");
            if (!GRID[y][x-1]) make_etch_side(x, y, "w");
        }
    }
}

/* Generate all grips for a given grid block (to be added) */
module make_grip(x, y) {
    if (GRID[y][x]) {
        translate([x*BLOCK_SIDE, y*BLOCK_SIDE, 0]) {
            if (!GRID[y-1][x]) make_grip_side(x, y, "s");
            if (!GRID[y+1][x]) make_grip_side(x, y, "n");
            if (!GRID[y][x+1]) make_grip_side(x, y, "e");
            if (!GRID[y][x-1]) make_grip_side(x, y, "w");
        }
    }
}

/* Generate all cavities for a given grid block (to be substracted) */
module make_cavity(x, y) {
    if (GRID[y][x]) {
        translate([x*BLOCK_SIDE, y*BLOCK_SIDE, 0]) {
            if (!GRID[y-1][x]) make_cavity_side(x, y, "s");
            if (!GRID[y+1][x]) make_cavity_side(x, y, "n");
            if (!GRID[y][x+1]) make_cavity_side(x, y, "e");
            if (!GRID[y][x-1]) make_cavity_side(x, y, "w");
                
            translate([ 0.5 * BLOCK_SIDE, 0.5 * BLOCK_SIDE, BLOCK_HEIGHT*IS_INV])
            sphere(r=CAVITY_RADIUS3);
        }
    }
}

///////////////////////////////////////////////////////////////////////////////
// Grid-level primitives

/* Generate all blocks of the grid */
module make_blocks() {
    union() { for (y = [0 : len(GRID)-1] ) for (x = [0 : len(GRID[y])-1] ) make_block(x, y); }
}

/* Generate all etchings of the grid */
module make_etches() {
    union() { for (y = [0 : len(GRID)-1] ) for (x = [0 : len(GRID[y])-1] ) make_etch(x, y); }
}

/* Generate all grips of the grid */
module make_grips() {
    union() { for (y = [0 : len(GRID)-1] ) for (x = [0 : len(GRID[y])-1] ) make_grip(x, y); }
}

/* Generate all cavities of the grid */
module make_cavities() {
    union() { for (y = [0 : len(GRID)-1] ) for (x = [0 : len(GRID[y])-1] ) make_cavity(x, y); }
}

///////////////////////////////////////////////////////////////////////////////
// Everything together

/* Generate all objects by combining additive and substractive elements */
module make_all() {
    difference()
    {
        union() {
            //union() {
            difference() {
                make_blocks();
//                make_etches();
            }
//            make_grips();
        }
//        make_cavities();
    }
}

/* Go for it and fix orientation */
rotate([0, 180*1, 90*1]) {
    make_all();
}

// End