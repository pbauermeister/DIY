/*
PENTOMINO BLOCKS GENERATOR
==========================

(C) 2017 by Pascal Bauermeister.
License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.

(This is a part of the project "Pentomino Belt Buckle", focused on the
Pentomino pieces. It can however be used standalone. The other parts, not in this
file, include: frame, belt clip.)

This OpenSCAD script generates blocks, with tabs and cavities to
allow them to hold together.

Do not run this script directly, as it is the common part for pentomino.scad
and frame.scad.

Being completely parametric allows individual control such as:
- size and thickness,
- tolerances (important for 3D printing), and also
- creating any kind of pieces, including 2D Polyminos of N cells for any N.
*/

echo("H_SCALE_FACTOR=", H_SCALE_FACTOR);
$fn = 16; // facets for spheres (grips)

// TOLERANCES
BLOCK_TOLERANCE = 0.15/2; // in mm - recession of each block's lateral sides
GRIP_TOLERANCE = 0.15/2;  // in mm - radial recession of each grips
DH = 0.1; // in mm - Displacement of grip/cavity above/below block middle

// BLOCK
BLOCK_SIDE = 6.5 *6/7;       // in mm
BLOCK_HEIGHT = 3;     // in mm
echo("BLOCK_SIDE=", BLOCK_SIDE*H_SCALE_FACTOR);

// GRIP
GRIP_RADIUS = BLOCK_HEIGHT/4 - GRIP_TOLERANCE; // in mm
//echo(GRIP_RADIUS*2);

// CAVITY
CAVITY_RADIUS = BLOCK_HEIGHT/4; // in mm
//echo(CAVITY_RADIUS*2);

// CHAMFER - adds layers on top+bottom of blocks
SLICES = 5;
SLICE_THIKHNESS = 0.3/SLICES; // in mm
SLICE_RECESSION = 0.4/SLICES; // in mm - how each slice will be horizontally reccessed from its predecessor

// MISC
ATOM = 0.0001; // a tiny value just to produce some offsets, making the 
               // results nicer in preview mode by cancelling effects of
               // boolean operations, but meant to not affect the end result
               // noticeably
_ = 0;

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
    scale([H_SCALE_FACTOR, H_SCALE_FACTOR, 1])
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
            make_chamfer();
        }
        make_cavities();
    }
}
