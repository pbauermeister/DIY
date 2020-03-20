/* (C) 2019-08-04 by P. Bauermeister
 * Closing cap for rooftop carrier, with cavity for lock.
 */

$fn=90;

module base() {
    scale([3.5, 3.5, 3.5*5.7])
    translate([-29.6, 23.3, 0])
    linear_extrude(height=1, convexity = 10)
    import(file = "base.dxf", center=true);
    
    *translate([-36.5/2, -51.5/2, 0])
    cube([36.5, 51.5, 20]);
}

module envelope() {
    scale([1, 1, .4])
    rotate([0, 90, 0])
    cylinder(h=50, r=51, center=true);
}

module body() {
    intersection() {
        translate([0, 25, 0])
        base();
        envelope();
    }
}


module cavity() {
    r = 12;
    r2 = r+.25;
    r3 = r2/2 + 1.5;
    w = 17;
    
    translate([4, 8.5+6.5 -r/2 -.5, r/2])
    rotate([0, 90, 0]) {
        // back chamber for lock
        cylinder(d=r2, h=16);
        translate([-r2/2, -r3/2, 0]) cube([r2, r3, 16]);

        // front chamber for guidance
        translate([-20/2, -w/2, 7])
        cube([20, w, 8]);
    }
}

module all() {
    difference() {
        body();

        difference() {
            translate([0, 6.5, 0])
            cavity();
        
            // one layer thick floor, to avoid deformation, to be cut out
            cube([100, 100, .2*2], true);
        }
    }
}

scale([ 1 + .8/36, 1 + 2/50.65, 1])
all();