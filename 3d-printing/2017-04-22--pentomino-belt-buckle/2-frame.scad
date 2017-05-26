/*
PENTOMINO BLOCKS GENERATOR
==========================
(C) 2017 by Pascal Bauermeister.

(This is a part of the project "Pentomino Belt Buckle", focused on the
Pentomino pieces. It can however be used standalone. The other parts, not in this
file, include: frame, belt clip.)

This OpenSCAD script generates the frame to hold the pentominos together, with a
backside border, to fit on the belt buckle.

This is freeware. Enjoy and modify freely. You may kindly mention this project.
*/

// GENERAL
H_SCALE_FACTOR =  (60 - 1.3) / 60; // makes frame a bit smaller, compensating pentominos tolerance
echo("H_SCALE_FACTOR=", H_SCALE_FACTOR);

include <common.scad>

GRID = [
    // Frame block types:
    // 2:none 3:north 4:south 5:east 6:west, 7-10:corners
    [_, _, _, _, _, _, _, _, _, _, _, _, _, _],
    [_, 9, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 10, _],
    [_, 5, _, _, _, _, _, _, _, _, _, _, 6, _],
    [_, 5, _, _, _, _, _, _, _, _, _, _, 6, _],
    [_, 5, _, _, _, _, _, _, _, _, _, _, 6, _],
    [_, 5, _, _, _, _, _, _, _, _, _, _, 6, _],
    [_, 5, _, _, _, _, _, _, _, _, _, _, 6, _],
    [_, 5, _, _, _, _, _, _, _, _, _, _, 6, _],
    [_, 7, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 8, _],
    [_, _, _, _, _, _, _, _, _, _, _, _, _, _],
];

make_all();

// End