
linear_extrude(height=1.5)
scale([10, 10, 1])
import("c1 top.dxf");

linear_extrude(height=1.5 + 1.25)
scale([10, 10, 1])
import("c2 top.dxf");

linear_extrude(height=6)
scale([10, 10, 1])
import("c3 top.dxf");
