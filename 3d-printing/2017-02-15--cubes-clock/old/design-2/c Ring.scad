

linear_extrude(height=1)
scale([10, 10, 1])
import("c1 Ring bottom.dxf");

linear_extrude(height=6.7)
scale([10, 10, 1])
import("c2 Ring top.dxf");
