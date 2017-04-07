
linear_extrude(height=2)
scale([10, 10, 1])
import("b1 ring.dxf");

linear_extrude(height=2 + 2.0 -.2)
scale([10, 10, 1])
import("b2 ring.dxf");

linear_extrude(height=8)
scale([10, 10, 1])
import("b3 ring.dxf");
