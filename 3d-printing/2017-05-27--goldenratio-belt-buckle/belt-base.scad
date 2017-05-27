// Layer (with filds) to cover the original belt buckle.
// Shape designed to fit a particular bucklle.
// Top surface will fit Pentomino bbuckle (file 2-pentominos-or-frame.scad)
//
//                                    fold      |                |
//  =====_================_=====      --->      '================'

scale([10, 10, 0.3])
linear_extrude(height=1) import("1-belt-base-a.dxf"); 

translate([0, 0, 0.3])
scale([10, 10, 0.3])
linear_extrude(height=1) import("1-belt-base-b.dxf");

scale([10, 10, .8])
linear_extrude(height=1) import("1-belt-base-e.dxf");

translate([80, 0, 0])
scale([1.07, 1.07, 1])
{
    scale([10, 10, 4])
    linear_extrude(height=1) import("1-belt-base-e.dxf");

    scale([10, 10, 4.5])
    linear_extrude(height=1) import("1-belt-base-c.dxf");

    scale([10, 10, 5])
    linear_extrude(height=1) import("1-belt-base-d.dxf");
}