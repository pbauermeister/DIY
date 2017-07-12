/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

EXTRA_H = 0.5;
 
linear_extrude(height=1  + EXTRA_H)
scale([10, 10, 1])
import("1d1-top.dxf");

linear_extrude(height=1 +2 + EXTRA_H)
scale([10, 10, 1])
import("1d2-top.dxf");
