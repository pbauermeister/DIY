
linear_extrude(height=0.5)
scale([10, 10, 1])
import("c1 top.dxf");

linear_extrude(height=1.5)
scale([10, 10, 1])
import("c3 top.dxf");

linear_extrude(height=1.5 +0.2)
scale([10, 10, 1])
import("c2 top.dxf");