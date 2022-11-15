/* OpenSCAD project.
 * Buckles to hold cables together. 4 different sizes.
 *
 * (C) 2019-2022 by P. Bauermeister
 *
 * See https://github.com/pbauermeister/DIY/tree/master/3d-printing/2019-07-09--earphone-buckles
*/
use <cable-buckles.scad>;

// Object sizes
HEIGHT         =  8.4;
WALL_THICKNESS =  3.0;
LENGTH         = 34.0;
WIDTH          = 16.0;
PRONG_SIZE     =  6.0;

unit(HEIGHT, WALL_THICKNESS, LENGTH, WIDTH, PRONG_SIZE);
