use <../chamferer.scad>

LENGTH         = 147.4;
WIDTH          =  22.2;
HEIGHT         =  33.0;
CHAMFER        =   0.9;
SCREW_DIAMETER = 1.25;

module raw_branch_0() {
    intersection() {
       translate([0, 30, 0])
       rotate([90, 0, 0])
        linear_extrude(50)
        translate([0, -264, 0])
        import("img/branch-side-view.dxf");

        linear_extrude(100)
        translate([0, -274.8, 0])
        import("img/branch-top-view.dxf");
    }
}

module raw_branch_1() {
    difference() {
        raw_branch_0();
        
        // hole for strap
        hull() {
            translate([8, 0, 5.4]) {
                rotate([-90, 0, 0]) cylinder(d=3, h=60, $fn=10, center=true);

                translate([1.5, 0, .5])
                rotate([-90, 0, 0]) cylinder(d=3, h=60, $fn=10, center=true);
            }
        }
    }
}

module raw_branch_2() {
    intersection() {
        raw_branch_1();

        // keep but diagonal cut
        union() {
            translate([0, 34.18, 14.52 + 15.7/2])
            rotate([0, 0, -8])
            cube([LENGTH*3, 9, 15.7], center=true);

            translate([-34.25, 0, 0])
            rotate([0, 24, 0])
            cube([LENGTH*2, LENGTH, LENGTH*3], center=true);
        }
    }

}

module chamfer() {
    if (0 && $preview) children();
    else {
        KX = LENGTH / (LENGTH + CHAMFER*2);
        KY = WIDTH / (WIDTH + CHAMFER*2);
        KZ = HEIGHT / (HEIGHT + CHAMFER*2);
        translate([CHAMFER, CHAMFER, CHAMFER]) scale([KX, KY, KZ]) chamferer(CHAMFER, "octahedron", shrink=false, grow=true)
        children();
    }
}

module branch() {
    difference() {
        chamfer()
        raw_branch_2();

        // hollowing
        translate([139 - 4, -.4 +.7, 19.5])
        rotate([0, 0, -8+2])
        {
            l = 30;
            translate([-l+7, 0, -2.5])
            chamferer(3.52, "octahedron", shrink=true, grow=true)
            cube([l, 17, 10.5]);
        }

        // screw hole
        translate([145.2 -.86, 16.1-.04 -.3, 0])
        cylinder(d=SCREW_DIAMETER, h=HEIGHT, $fn=20);
    }
}

//%cube([LENGTH, WIDTH, HEIGHT]);
//branch()

scale([1, 1, -1])
branch();