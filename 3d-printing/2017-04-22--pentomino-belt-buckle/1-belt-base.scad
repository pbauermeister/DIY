/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

// Layer (with filds) to cover the original belt buckle.
// Shape designed to fit a particular bucklle.
// Top surface will fit Pentomino bbuckle (file 2-pentominos-or-frame.scad)
//
//                                    fold      |                |
//  =====_================_=====      --->      '================'

scale([10, 10, 0.6])
linear_extrude(height=1) import("1-belt-base-a.dxf"); 

scale([10, 10, 0.3])
linear_extrude(height=1) import("1-belt-base-b.dxf");
