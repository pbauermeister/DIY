

linear_extrude(height=1)
scale([10, 10, 1])
import("d1 cage top base.dxf");

linear_extrude(height=1 +3)
scale([10, 10, 1])
import("d2 cage top mid.dxf");

linear_extrude(height=1 +4)
scale([10, 10, 1])
import("d3 cage top ring.dxf");

linear_extrude(height=1+4 +4)
scale([10, 10, 1])
import("d4 cage top ring2.dxf");

linear_extrude(height=17.5)
scale([10, 10, 1])
import("d5 cage top pillar.dxf");

