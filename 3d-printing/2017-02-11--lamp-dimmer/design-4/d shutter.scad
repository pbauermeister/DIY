
linear_extrude(height=1.5)
scale([10, 10, 1])
import("d1 shutter.dxf");

linear_extrude(height=1.5 +3.2)
scale([10, 10, 1])
import("d2 shutter.dxf");

linear_extrude(height=3)
scale([10, 10, 1])
import("d3 shutter.dxf");
