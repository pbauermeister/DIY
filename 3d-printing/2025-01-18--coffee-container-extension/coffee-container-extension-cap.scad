BEND_H      =  4;
THICKNESS   =  9.9;
BASE_LIP_XY =  3;
BASE_LIP_z  =  1.7;
TOLERANCE   =  0.2;

module shape() {
    k = .92;
    scale([.92, .915, 1])
    translate([-160.42, -50.7, 0])
    import("coffee-container-extension-cap.dxf");

}

module bending() {
    r = 1400;
    translate([0, 0, -r + BEND_H])
    rotate([90, 0, 0])
    cylinder(r=r, h=300, center=true, $fn=400);
}


module wall(outer, inner, h, z, full=false, bend=true) {

    translate([0, 0, z])
    intersection() {
        difference() {
            linear_extrude(h)
            difference() {
                offset(r=outer) shape();
                if (!full)
                    offset(r=-inner) shape();
            }
//            bending();
        }
        if (bend)
            translate([0, 0, h-BEND_H])
            bending();
    }
}


//translate([0, 0, THICKNESS/2]) %cube([69.5, 48.5, THICKNESS], center=true);

//shape();

module envelope(xtra) {
    hull() {
        translate([0, 0, -1.4])
        wall(+TOLERANCE+xtra/2, 0, THICKNESS, 0, true);

        d = 10;

        translate([0, 0, d*1.5])
        wall(-d, -d*2, THICKNESS, 0, true);
    }
}

module body(xtra) {
    h = 7.8;
    difference() {
        union() {
            intersection() {
                wall(+TOLERANCE+xtra/2, 0, THICKNESS+1, 0, true);
                envelope(xtra);

                translate([0, 0, -10])
                cylinder(d=1000, h=20.4);
            }

            translate([0, 0, -BASE_LIP_z])
            wall(BASE_LIP_XY+xtra/2, 0, BASE_LIP_z, 0, full=true, bend=false);
        }
    
        translate([0, 0, 0])
        wall(5, TOLERANCE-xtra/2, h, 0, full=false, bend=true);

        r = TOLERANCE*4;

        translate([0, 0, h-5 - r*.75*0])
        minkowski() {
            wall(4, TOLERANCE-xtra/2 -r, 5, 0, full=false, bend=true);
            sphere(r=r, $fn=$preview?7:16);
        }

        if(1)
        hull() {
            translate([0, 0, THICKNESS-2])
            wall(-23, 0, 2, 0, true);

            translate([0, 0, -2])
            wall(0, 0, 2, 0, true);
        }
    }
}

intersection() {
//    body(0);
    body(1);
    
    if (0) union() {
        cube([3, 999, 999], center=true);
        cube([999, 3, 999], center=true);
    }
}


//sphere($fn=8);