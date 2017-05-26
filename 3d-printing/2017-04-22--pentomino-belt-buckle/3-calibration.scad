/*
PENTOMINO BLOCKS GENERATOR
==========================
(C) 2017 by Pascal Bauermeister.

(This is a part of the project "Pentomino Belt Buckle", focused on the
Pentomino pieces. It can however be used standalone. The other parts, not in this
file, include: frame, belt clip.)

This OpenSCAD script generates Pentomino blocks, with tabs and cavities to
allow them to hold together.

This is freeware. Enjoy and modify freely. You may kindly mention this project.
*/

// GENERAL
//H_SCALE_FACTOR = 1.58 / 1.63 ; 
//H_SCALE_FACTOR = 1.56 / 1.63 ; 
H_SCALE_FACTOR = 1.55 / 1.63 ; 

include <common.scad>

///////////////////////////////////////////////////////////////////////////////
// Map defining the Pentomino shapes
_ = 0; // no block
GRID = [
    [_, _, _, _, _, _, _],
    [_, 1, 1, 1, _, 1, _],
    [_, _, _, _, _, 1, _],
    [_, 1, 1, 1, _, 1, _],
    [_, _, _, _, _, _, _],
];

make_all();

// End