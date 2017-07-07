// Layer (with filds) to cover the original belt buckle.
// Shape designed to fit a particular bucklle.
// Top surface will fit Pentomino bbuckle (file 2-pentominos-or-frame.scad)
//
//                                    fold      |                |
//  =====_================_=====      --->      '================'

module base() {
    scale([10, 10, 0.3])
    linear_extrude(height=1) import("belt-base-a.dxf"); 

    translate([0, 0, 0.3])
    scale([10, 10, 0.3])
    linear_extrude(height=1) import("belt-base-b.dxf");

    scale([10, 10, .8])
    linear_extrude(height=1) import("belt-base-e.dxf");
}

module top() {
    translate([-78.582/2*1.07, 76.159/2*1.07, 0])
    rotate([180, 0, 0])
    scale([1.07, 1.07, 1])
    {
        difference() {
            scale([10, 10, 4])
            linear_extrude(height=1) import("belt-base-e2.dxf");

            scale([10, 10, 5])
            linear_extrude(height=1) import("belt-base-cd.dxf");

            translate([0, 0, 3.001])
            scale([10, 10, 1])
            linear_extrude(height=1) import("belt-base-cd.dxf");
        }
        
            //translate([0, 0, 3.5])
            scale([10, 10, 0.5])
            linear_extrude(height=1) import("belt-base-e2.dxf");    
    }
}

if(0)
base();

translate([80, 0, 0])
{
top();
}