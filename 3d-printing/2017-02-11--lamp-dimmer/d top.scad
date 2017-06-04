 EXTRA_H = 0.5;
 
linear_extrude(height=1  + EXTRA_H)
scale([10, 10, 1])
import("d1 top.dxf");

linear_extrude(height=1 +2 + EXTRA_H)
scale([10, 10, 1])
import("d2 top.dxf");
