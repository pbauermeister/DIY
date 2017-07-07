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



module grip(length) {
    height = 1.5;
    hull() {
        translate([0, 0, height])
        rotate([0, 90, 0])
        scale([1, 1, length])
        cube([0.1,10 + height*2,1], true);

        translate([0, 0, 0])
        rotate([0, 90, 0])
        scale([1, 1, length])
        cube([0.1,10,1], true);
    }
}

module top() {
    grip(50);
    thickness = 1.1;
    recess = 1;

    thickness = 4;
    recess = 1;
    
    translate([-78.582/2*1.07, 76.159/2*1.07, 0])
    rotate([180, 0, 0])
    scale([1.07, 1.07, 1])
    {
        difference() {
            scale([10, 10, thickness])
            linear_extrude(height=1) import("belt-base-e2.dxf");

            scale([10, 10, thickness+1])
            linear_extrude(height=1) import("belt-base-cd.dxf");

            translate([0, 0, thickness -recess +.001])
            scale([10, 10, 1])
            linear_extrude(height=1) import("belt-base-cd2.dxf");
        }
        
            //translate([0, 0, 3.5])
            scale([10, 10, recess/2])
            linear_extrude(height=1) import("belt-base-e2.dxf");    
    }
}

if(0)
base();

//translate([80, 0, 0])
{
top();
}