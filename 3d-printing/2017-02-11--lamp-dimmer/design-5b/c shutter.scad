EXTRA_H = 0;

linear_extrude(height=0.2)
scale([10, 10, 1])
import("c0 shutter.dxf");

translate([0, 0, 0.2])
linear_extrude(height=0.8 + EXTRA_H)
scale([10, 10, 1])
import("c1 shutter.dxf");

translate([0, 0, 0.2])
linear_extrude(height=2.6 + EXTRA_H)
scale([10, 10, 1])
import("c1b shutter.dxf");

translate([0, 0, 2.8-1])
linear_extrude(height=1 + EXTRA_H)
scale([10, 10, 1])
import("c2 shutter.dxf");
