use <lego-lib.scad>

$fn = 90;
ATOM = .01;

A = [1, 0, .1, -.3, 0, 0, 0, 8, 0];

B = [1, 0, 0, 0, 0, 0, 0, 6, 1];
C = [5, 0, 0, 0, 0, 0, 3, 4, 0];

MAP2 = [
    [
        [A],
        [0],
        [B],
        [1],
        [C],
    ],
];


lego_build(MAP2);