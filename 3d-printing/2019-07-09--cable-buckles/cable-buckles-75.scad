/* OpenSCAD project.
 * Buckles to hold cables together. 4 different sizes.
 *
 * (C) 2019-2022 by P. Bauermeister
 *
 * See https://github.com/pbauermeister/DIY/tree/master/3d-printing/2019-07-09--earphone-buckles
*/
use <cable-buckles.scad>;

// Object sizes
HEIGHT         =  9.5;
WALL_THICKNESS =  3.8;
LENGTH         = 75.0;
WIDTH          = 32.0;
PRONG_SIZE     = 10.0;

unit(HEIGHT, WALL_THICKNESS, LENGTH, WIDTH, PRONG_SIZE);
