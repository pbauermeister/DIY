
linear_extrude(height=1)
scale([10, 10, 1])
import("a1 base.dxf");

linear_extrude(height=3)
scale([10, 10, 1])
import("a2 base.dxf");

linear_extrude(height=1+5.2 +2+0.3)
scale([10, 10, 1])
import("a3 base.dxf");
