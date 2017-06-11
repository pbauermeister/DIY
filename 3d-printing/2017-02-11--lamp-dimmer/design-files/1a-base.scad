EXTRA_H = 0.5;

linear_extrude(height=1 + EXTRA_H)
scale([10, 10, 1])
import("1a1-base.dxf");

linear_extrude(height=EXTRA_H + 3 + 1.5+2 + 0.3 -0.1  + EXTRA_H/2)
scale([10, 10, 1])
import("1a2-base.dxf");
