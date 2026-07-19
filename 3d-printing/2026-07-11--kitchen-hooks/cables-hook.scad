//use <../chamferer.scad>

GROOVE_TH= 25;
D = 80;
WALL = 15;

ATOM = 0.01;

$fn = $preview ? 20 : 100;

module tire(d, r, xr) {
    rotate_extrude(convexity = 10)
        translate([d/2, 0, 0])
        hull() {
            circle(r=r);

            translate([xr, 0, 0])
            circle(r=r);
        }
}

module shape() {
    difference() {
        
        hull() {
            for (k=[-1, 1]) {
                translate([0, 0, k*WALL])
                tire(D, GROOVE_TH/6, 0);
            }

            translate([0, 0, -GROOVE_TH/2-GROOVE_TH/3.5])
            cylinder(d=D+GROOVE_TH/3, h=WALL);
        }

        tire(D*.75, GROOVE_TH/2, GROOVE_TH);
    }
}

module hook() {
    difference() {
        shape();
        
        rotate([90, 0, 0])
        cylinder(r=D, h=D*4);
    }

    scale([1, 1/ATOM*(D/2), 1])
    intersection() {
        shape();    
        rotate([90, 0, 0])
        cylinder(r=D, h=ATOM);
    }
}

rotate([90, 0, 0])
hook();