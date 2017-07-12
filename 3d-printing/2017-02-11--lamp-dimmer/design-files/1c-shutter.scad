/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

EXTRA_H = 0;

linear_extrude(height=0.2)
scale([10, 10, 1])
import("1c0-shutter.dxf");

translate([0, 0, 0.2])
linear_extrude(height=0.8 + EXTRA_H)
scale([10, 10, 1])
import("1c1-shutter.dxf");

translate([0, 0, 0.2])
linear_extrude(height=2.6 + EXTRA_H)
scale([10, 10, 1])
import("1c1b-shutter.dxf");

translate([0, 0, 2.8-1])
linear_extrude(height=1 + EXTRA_H)
scale([10, 10, 1])
import("1c2-shutter.dxf");
