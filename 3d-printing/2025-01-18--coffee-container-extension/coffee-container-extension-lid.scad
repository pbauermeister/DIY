use <coffee-container-extension.scad>

TOP_H = 12.5;

BEND_H      =  4;
xTHICKNESS   =  9.9;
BASE_LIP_XY =  3;
BASE_LIP_z  =  1.7;
TOLERANCE   =  0.2;

DEPTH = 15*0 + 6;

THICKNESS = 3.5;

ATOM = 0.01;
$fn = 30;



module bottom_part() {
    h = DEPTH;
    
    translate([0, 0, -THICKNESS])
    difference() {
        union() {
            translate([0, -1*1.5, 0])
            wall_inner(4, 0, THICKNESS, 0, bending=false, hollowing=false);

            translate([0, -1.8, -h])
            wall_inner(-.5, 0, h, 0, bending=false, hollowing=!true);
        }

        /*
        translate([0, -189.77, 0])
        cube([300, 300, 300], center=true);
        */

        // shave for outer gasket
        translate([-50, -49.5 -10.5 +6, -ATOM])
        cube([100, 20, 10]);
        
        // shave for inner gasket
        grove();

        // reinforcement cracks
        intersection() {
            difference() {
                step = 3;
                union() {
                    for(x=[-40:step:40]) for(y=[-45:step:25])
                        translate([x, y, .4])
                        cube([step/2, step/2, .1]);
                }
                
                translate([0, 0, -THICKNESS])
                grove(full=true, extra=-1);
            }
            
            translate([0, -1*1.5, 0])
            wall_inner(2, 0, THICKNESS, 0, bending=false, hollowing=false);
        }
        
        // hole for rib
        translate([0, 2.5 -40, 0])
        cube([7, 5, 100], center=true);
    }

    // gripping balls
    for (x=[1, -1]) {
        translate([-32*x, -39.5, -h/2 - THICKNESS])
        sphere(r=1);

        translate([-32*x, 20.45, -h/2 - THICKNESS])
        sphere(r=1);
    }
}

module shape(offset) {
    k = .92;
    offset(r=offset) //shape_outer();
    scale([.92, .915, 1])    
    translate([-160.42, -50.7, 0])
    import("coffee-container-extension-cap.dxf");
}


module top_part(extra_offset=0) {
    translate([0, 12.301 -5.5, 0])
    linear_extrude(TOP_H-THICKNESS)
    translate([0, -12.7, 0])
    rotate([0, 0, 180])
    shape(-.67 + extra_offset);
}


bottom_part();
top_part();

module grove(full=false, extra=0) {
    translate([0, 0, 3.5 - 2.5])
    difference() {
        union() {
            top_part(3 + extra);
            translate([0, -20, 0]) top_part(-1);
        }
        if (!full)
            top_part(0);
    }
}

/*
module ___all() {
    difference() {
        union() {
            inner_lid();
 
            translate([0, 0, THICKNESS])
%            linear_extrude(TOP_H-THICKNESS)
            translate([0, -12.7, 0])
            shape(-.67);
        }
     }
}

//%translate([0, -12.6, 0]) cube([69, 48, 100], center=true);
//translate([-160.7, -65, 0]) import("coffee-container-extension-inner.dxf");
*/