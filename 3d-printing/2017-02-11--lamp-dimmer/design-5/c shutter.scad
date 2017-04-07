EXTRA_H = 0;

linear_extrude(height=0.5 + EXTRA_H)
scale([10, 10, 1])
import("c1 shutter.dxf");

linear_extrude(height=2.8 + EXTRA_H)
scale([10, 10, 1])
import("c2 shutter.dxf");
