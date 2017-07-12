

linear_extrude(height=2)
scale([10, 10, 1])
import("e1 Cage bottom base.dxf");

linear_extrude(height=2 +15.5)
scale([10, 10, 1])
import("e2 Cage bottom clip.dxf");
