use <./gyroid-sphere.scad>
use <../chamferer.scad>

$fn = $preview ? 16 : 120;


translate([0, 100, 0])
scale([1, 1, -1])
ring(-20);


module slice() {
    translate([0, 0, 2.5])
    intersection(){
        rotate([0, 90, 0])
        rotate([0, 0, 90])
        lamp(true);
        
        cylinder(d=230, h=5, center=true);
    }
}

%slice();

intersection() {
    chamferer(12, "cylinder", shrink=false)
    difference() {
        hull() slice();
        slice();
    }
    
    slice();
}