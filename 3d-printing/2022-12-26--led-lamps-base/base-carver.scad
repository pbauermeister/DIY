/* This file provides the carve_base() module to hollow-out the base of an object
 * by a given height h, leaving out a border of r thickness.
 *
 * By default the hollowing is cylindric. Optionally, if cylindric=false, the
 * hollowing uses Minkowski with a radius of fn.
 */


module carve_base(h=1.3, r=2, world=1e5, fn=5, cylindric=true) {
    //if(1) children(); else
    if (cylindric) {
       carve_base_cylinder(h, r, world) children();
    }
    else {
       carve_base_minkowski(h, r, world, fn) children();
    }
}


ATOM      = 0.01;


module carve_base_minkowski(h=1.5, r=2.5, world=1e5, fn=4+1) {
    difference() {
        // original
        children();
        
        // shaved foot
        translate([0, 0, -ATOM])
        difference() {
            cylinder(r=world, h=h-ATOM);
            minkowski() {
                difference() {
                    cylinder(r=world, h=h+ATOM);
                    translate([0, 0, -ATOM])
                    intersection() {
                        children();
                        cylinder(r=world, h=h+ATOM);
                    }
                }
                cylinder(r=r, h=ATOM, $fn=fn);
            }
        }
    }
}


module carve_base_cylinder(h=.4, r=2.5, world=1000) {
    difference() {
        // original
        children();
                    
        // shaved foot
        translate([0, 0, -ATOM*2])
        linear_extrude(height=h)
        offset(r=-r)
        projection(cut=true)
        children();
    }
}


intersection() {
    //carve_base_minkowski()
    carve_base(cylindric=true)
    intersection() {
        //translate([0, 0, 3]) sphere(d=10, $fn=64);
        cylinder(d1=10, d2=25, h=6, $fn=40);
    }

    translate([0, -15, -15])
    cube(30);
}