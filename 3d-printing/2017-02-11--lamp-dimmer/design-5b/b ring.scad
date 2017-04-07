
linear_extrude(height=0.22)
scale([10, 10, 1])
import("b0 ring.dxf");

translate([0, 0, 0.2])
linear_extrude(height=1.8)
scale([10, 10, 1])
import("b1 ring.dxf");

linear_extrude(height=2 + 2.0 -.2)
scale([10, 10, 1])
import("b2 ring.dxf");

linear_extrude(height=8)
scale([10, 10, 1])
import("b3 ring.dxf");
