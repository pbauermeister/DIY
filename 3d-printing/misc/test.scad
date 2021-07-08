/*
PENTOMINO BLOCKS GENERATOR
==========================
(C) 2017 by Pascal Bauermeister.

(This is a part of the project "Pentomino Belt Buckle", focused on the
Pentomino pieces. It can however be used standalone. The other parts, not in this
file, include: frame, belt clip.)

This OpenSCAD script generates Pentomino blocks, with tabs and cavities to
allow them to hold together.

Being completely parametric allows individual control such as:
- size and thickness,
- tolerances (important for 3D printing), and also
- creating any kind of pieces, including 2D Polyminos of N cells for any N.

This is freeware. Enjoy and modify freely. You may kindly mention this project.
*/

IS_FRAME = true;
SCALE_FACTOR = IS_FRAME ? (60 - 1.3) / 60 : 1; // makes frame a bit smaller, compensating pentominos tolerance
//SCALE_FACTOR = IS_FRAME ? (60 - 1.8 + 0.5) / 60 : 1; // makes frame a bit smaller, compensating pentominos tolerance
echo("SCALE_FACTOR=", SCALE_FACTOR);

IS_INV = 1;

$fn = 24; // 24: high quality; 8: draft
//$fn = 8;
$fn = 16;

// BASE ETCHING
// this etches the first layer, to compensate for being wider due to being squished down
BASE_HEIGHT = 0.3;
BASE_TOLERANCE = 0.3;

// BLOCK
BLOCK_TOLERANCE = 0.15/2; // in mm
GRIP_TOLERANCE = 0.15/2; // in mm

BLOCK_SIDE = 6.5 *6/7;       // in mm
BLOCK_HEIGHT = 3;     // in mm
echo("BLOCK_SIDE=", BLOCK_SIDE);

DH = 0.1;
// GRIP
GRIP_RADIUS = BLOCK_HEIGHT/4 - GRIP_TOLERANCE; // in mm
GRIP_V_OFFSET = 0.2; //IS_INV ? 0.25 : -0.25;
//echo(GRIP_RADIUS*2);

// CAVITY
CAVITY_RADIUS = BLOCK_HEIGHT/4; // in mm
//echo(CAVITY_RADIUS*2);

// CHAMFER
SLICES = 5;
SLICE_THIKHNESS = 0.3/SLICES;
SLICE_RECESSION = 0.4/SLICES;

// MISC
ATOM = 0.0001; // a tiny value just to produce some offsets, making the 
               // results nicer in preview mode by cancelling effects of
               // boolean operations, but meant to not affect the end result
               // noticeably
_ = 0;

///////////////////////////////////////////////////////////////////////////////
// Bitmap defining the Pentomino shapes
GRID_P = [
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
];

// Rename as GRID_P to have a single block, for tests
GRID_P_ = [
    [_, _, _, _, _, _, _],
    [_, _, _, _, 1, _, _],
    [_, _, _, 1, 1, _, _],
    [_, 1, _, _, _, _, _],
    [_, 1, 1, _, _, _, _],
    [_, _, _, _, _, _, _],
];

GRID_F = [
    // grips+ cavities:
    // 2:none 3:north 4:south 5:east 6:west
    [_, _, _, _, _, _, _, _, _, _, _, _, _, _],
    [_, 9, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 10, _],
    [_, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, _],
    [_, 5, 2, 2, 1, 2, 1, 1, 1, 1, 2, 2, 6, _],
    [_, 5, 1, 2, 1, 2, 1, 1, 1, 2, 2, 2, 6, _],
    [_, 5, 2, 2, 1, 2, 2, 1, 1, 1, 1, 1, 6, _],
    [_, 5, 2, 1, 1, 2, 2, 1, 1, 2, 2, 2, 6, _],
    [_, 5, 2, 2, 1, 1, 2, 1, 1, 2, 2, 2, 6, _],
    [_, 7, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 8, _],
    [_, _, _, _, _, _, _, _, _, _, _, _, _, _],
];

GRID = IS_FRAME ? GRID_F : GRID_P;

///////////////////////////////////////////////////////////////////////////////
// Side-level primitives

/* Generate a grip for one give side (to be added) */
module make_grip_side(val, x, y, side) {
    convex = (side=="n") ? GRID[y+1][x-1] || GRID[y+1][x+1] :
             (side=="s") ? GRID[y-1][x-1] || GRID[y-1][x+1] :
             (side=="e") ? GRID[y+1][x+1] || GRID[y-1][x+1] :
           /*(side=="w")*/ GRID[y+1][x-1] || GRID[y-1][x-1];
    
    doit =  val==1
        || val==3 && side=="n"
        || val==4 && side=="s"
        || val==5 && side=="e"
        || val==6 && side=="w";

    if (doit && !convex) {
        center1 =
            (side=="n") ? [BLOCK_SIDE*.75, BLOCK_SIDE -BLOCK_TOLERANCE*2, 0] :
            (side=="s") ? [BLOCK_SIDE*.25,             BLOCK_TOLERANCE*2, 0] :
            (side=="e") ? [BLOCK_SIDE -BLOCK_TOLERANCE*2, BLOCK_SIDE*.25, 0] :
          /*(side=="w")*/ [            BLOCK_TOLERANCE*2, BLOCK_SIDE*.75, 0] ;
        color("yellow")
        translate([0, 0, BLOCK_HEIGHT*.25 +DH])
        translate(center1)
        sphere(r=GRIP_RADIUS);

        center2 =
            (side=="n") ? [BLOCK_SIDE*.25, BLOCK_SIDE -BLOCK_TOLERANCE*2, 0] :
            (side=="s") ? [BLOCK_SIDE*.75,             BLOCK_TOLERANCE*2, 0] :
            (side=="e") ? [BLOCK_SIDE -BLOCK_TOLERANCE*2, BLOCK_SIDE*.75, 0] :
          /*(side=="w")*/ [            BLOCK_TOLERANCE*2, BLOCK_SIDE*.25, 0] ;
        color("yellow")
        translate([0, 0, BLOCK_HEIGHT*.75 -DH])
        translate(center2)
        sphere(r=GRIP_RADIUS);
    }
}

/* Generate a cavity for one give side (to be substracted) */
module make_cavity_side(val, x, y, side) {
    // cavity for grip of neighbour piece

    doit =  val==1
        || val==3 && side=="n"
        || val==4 && side=="s"
        || val==5 && side=="e"
        || val==6 && side=="w";

    if (doit) {

        center1 = (side=="n") ? [BLOCK_SIDE*.25, BLOCK_SIDE -BLOCK_TOLERANCE*2, 0] :
                  (side=="s") ? [BLOCK_SIDE*.75,            +BLOCK_TOLERANCE*2, 0] :
                  (side=="e") ? [BLOCK_SIDE -BLOCK_TOLERANCE*2, BLOCK_SIDE*.75, 0] :
                /*(side=="w")*/ [           +BLOCK_TOLERANCE*2, BLOCK_SIDE*.25, 0];        
        color("orange")
        translate([0, 0, BLOCK_HEIGHT*.25 +DH])
        translate(center1)
        sphere(r=CAVITY_RADIUS);

        center2 = (side=="n") ? [BLOCK_SIDE*.75, BLOCK_SIDE -BLOCK_TOLERANCE*2, 0] :
                  (side=="s") ? [BLOCK_SIDE*.25,            +BLOCK_TOLERANCE*2, 0] :
                  (side=="e") ? [BLOCK_SIDE -BLOCK_TOLERANCE*2, BLOCK_SIDE*.25, 0] :
                /*(side=="w")*/ [           +BLOCK_TOLERANCE*2, BLOCK_SIDE*.75, 0];        
        color("orange")
        translate([0, 0, BLOCK_HEIGHT*.75 -DH])
        translate(center2)
        sphere(r=CAVITY_RADIUS);
    }
}

module make_border_side(val, x, y, side) {
    s2 = sqrt(2);
    
    if (val==5 || val==7 || val==9) {
        cube([BLOCK_SIDE/2, BLOCK_SIDE, BLOCK_HEIGHT*2]);            
    }
    else if (val==6 || val==8 || val==10) {
        translate([BLOCK_SIDE/2, 0, 0])
        cube([BLOCK_SIDE/2, BLOCK_SIDE, BLOCK_HEIGHT*2]);
    }    
    if (val==3 || val==9 || val==10) {
//        translate([0, -BLOCK_SIDE/2, 0])
        cube([BLOCK_SIDE, BLOCK_SIDE/4, BLOCK_HEIGHT*2]);
    }
    if (val==4 || val==7 || val==8) {
        translate([0, BLOCK_SIDE*3/4, 0])
        cube([BLOCK_SIDE, BLOCK_SIDE/4, BLOCK_HEIGHT*2]);
    }

//    // clip    
//    if (val==5) {
//        color("red")
//        translate([BLOCK_SIDE*.45, 0, BLOCK_HEIGHT*2])
//        rotate([0, 45+90, 0])
//        cube([BLOCK_SIDE/2 / s2, BLOCK_SIDE, BLOCK_SIDE/2 / s2]);
//    }
//    if (val==6) {
//        color("red")
//        translate([BLOCK_SIDE*.55, 0, BLOCK_HEIGHT*2])
//        rotate([0, 45+90, 0])
//        cube([BLOCK_SIDE/2 / s2, BLOCK_SIDE, BLOCK_SIDE/2 / s2]);
//    }

}

/* Generate an etching for one give side (to be substracted) */
module make_etch_side(x, y, side, etch) {
    center = (side=="n") ? [BLOCK_SIDE/2,   BLOCK_SIDE] :
             (side=="s") ? [BLOCK_SIDE/2,            0] :
             (side=="e") ? [  BLOCK_SIDE, BLOCK_SIDE/2] :
           /*(side=="w")*/ [           0, BLOCK_SIDE/2];

    // main etiching
    qsize = (side=="n") ? [BLOCK_SIDE + etch*2, etch*2] :
            (side=="s") ? [BLOCK_SIDE + etch*2, etch*2] :
            (side=="e") ? [etch*2, BLOCK_SIDE + etch*2] :
          /*(side=="w")*/ [etch*2, BLOCK_SIDE + etch*2];
    tx = center[0] - qsize[0]/2;
    ty = center[1] - qsize[1]/2;

    color("green")
    translate([tx, ty, -ATOM])
    cube([qsize[0], qsize[1], BLOCK_HEIGHT + ATOM*2]);
}

///////////////////////////////////////////////////////////////////////////////
// Block-level primitives

/* Generate a given grid block */
module make_block(x, y) {
    if (GRID[y][x]) {
        color(GRID[y][x]==2 ? "orange" : "black")
        translate([x*BLOCK_SIDE, y*BLOCK_SIDE, 0])
        cube([BLOCK_SIDE, BLOCK_SIDE, BLOCK_HEIGHT]);
    }
}

/* Generate etching for a given grid block (to be substracted) */
module make_etch(x, y, etch) {
    if (GRID[y][x]) {
        translate([x*BLOCK_SIDE, y*BLOCK_SIDE, 0]) {
            if (!GRID[y-1][x]) make_etch_side(x, y, "s", etch);
            if (!GRID[y+1][x]) make_etch_side(x, y, "n", etch);
            if (!GRID[y][x+1]) make_etch_side(x, y, "e", etch);
            if (!GRID[y][x-1]) make_etch_side(x, y, "w", etch);
        }
    }
}

/* Generate all grips for a given grid block (to be added) */
module make_grip(x, y) {
    val = GRID[y][x];
    if (val) {
        translate([x*BLOCK_SIDE, y*BLOCK_SIDE, 0]) {
            if (!GRID[y-1][x]) make_grip_side(val, x, y, "s");
            if (!GRID[y+1][x]) make_grip_side(val, x, y, "n");
            if (!GRID[y][x+1]) make_grip_side(val, x, y, "e");
            if (!GRID[y][x-1]) make_grip_side(val, x, y, "w");
        }
    }
}

/* Generate clips */
module make_border(x, y) {
    val = GRID[y][x];
    if (val) {
        color(GRID[y][x]==2 ? "orange" : "black")
        translate([x*BLOCK_SIDE, y*BLOCK_SIDE, 0]) {
            if (!GRID[y-1][x]) make_border_side(val, x, y, "s");
            if (!GRID[y+1][x]) make_border_side(val, x, y, "n");
            if (!GRID[y][x+1]) make_border_side(val, x, y, "e");
            if (!GRID[y][x-1]) make_border_side(val, x, y, "w");
        }
    }
}

/* Generate all cavities for a given grid block (to be substracted) */
module make_cavity(x, y) {
    val = GRID[y][x];
    if (val) {
        translate([x*BLOCK_SIDE, y*BLOCK_SIDE, 0]) {
            if (!GRID[y-1][x]) make_cavity_side(val, x, y, "s");
            if (!GRID[y+1][x]) make_cavity_side(val, x, y, "n");
            if (!GRID[y][x+1]) make_cavity_side(val, x, y, "e");
            if (!GRID[y][x-1]) make_cavity_side(val, x, y, "w");
                
//            translate([ 0.5 * BLOCK_SIDE, 0.5 * BLOCK_SIDE, BLOCK_HEIGHT*IS_INV])
//            sphere(r=CAVITY_RADIUS3);
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
module make_etches(etch) {
    union() { for (y = [0 : len(GRID)-1] ) for (x = [0 : len(GRID[y])-1] ) make_etch(x, y, etch); }
}

/* Generate all grips of the grid */
module make_grips() {
    union() { for (y = [0 : len(GRID)-1] ) for (x = [0 : len(GRID[y])-1] ) make_grip(x, y); }
}

/* Generate clips */
module make_borders() {
    union() { for (y = [0 : len(GRID)-1] ) for (x = [0 : len(GRID[y])-1] ) make_border(x, y); }
}

/* Generate all cavities of the grid */
module make_cavities() {
    union() { for (y = [0 : len(GRID)-1] ) for (x = [0 : len(GRID[y])-1] ) make_cavity(x, y); }
}

///////////////////////////////////////////////////////////////////////////////
// Everything together

module make_chamfer_slice(i) {
    difference() {
        resize([0, 0, SLICE_THIKHNESS], auto=[false,false,true]) 
        make_blocks();
        make_etches(BLOCK_TOLERANCE + (i+1)*SLICE_RECESSION);
    }
}

module make_chamfer() {
    for (i=[0:SLICES]) {
        translate([0,0,BLOCK_HEIGHT + i*SLICE_THIKHNESS])
        make_chamfer_slice(i);

        translate([0,0, -(i+1)*SLICE_THIKHNESS])
        make_chamfer_slice(i);
    }
}


/* Generate all objects by combining additive and substractive elements */
module make_all() {
    difference()
    {
        union() {
            //union() {
            difference() {
                make_blocks();
                make_etches(BLOCK_TOLERANCE);
            }
            make_grips();
            make_borders();
//            make_chamfer();
        }
        make_cavities();
    }
}

/* Go for it and fix orientation */
scale([SCALE_FACTOR, SCALE_FACTOR, 1])
rotate([0, 180*1, 180*1]) {
    make_all();
}


// End