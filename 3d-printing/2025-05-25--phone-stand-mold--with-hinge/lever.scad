H      = 12.2;
D      =  4;
AXIS_D =  1.125;

ATOM   =  0.01;
$fn    = $preview?9:100;

module shape() {
    translate([0, -297, 0])
    import("lever.dxf");
}


module skeleton() {
    linear_extrude(H)
    difference() {
        shape();
        d = 0.01;
        translate([-d, d, 0])
        shape();

        translate([-.1, -69 - 1+.2])
        square(10);
    }
}

module lever() {
    intersection() {
        minkowski() {
            skeleton();
            cylinder(d=D*2, ATOM);
        }

        union() {
            linear_extrude(H)
            shape();
            translate([-5+1, -60, 0])
            cube([5, 60, H]);
        }
        
        // cut bottom
        translate([-5, -66.84 + 1.1, 0])
        rotate([0, 0, 35])
        cube([100, 70, H]);
        
        // cut top
        translate([-6, -70 - D/2, 0])
        cube([60, 70, H]);
    }

    // end
    translate([4.68 +.15 -.245, -59, 0])
    cylinder(d=D, h=H, $fn=100);

    // elbow
    x = 5.235 - .24  + 2;
    x2 = x+D;
    difference() {
        hull() {
            translate([x, -D/2, 0])
            cylinder(d=D, h=H, $fn=100);

            translate([x2, -D/2, 0])
            cylinder(d=D, h=H, $fn=100);
        }
        
        translate([x2, -D/2, 0])
        cylinder(d=AXIS_D, h=H*3, center=true);
    }
}

lever();
