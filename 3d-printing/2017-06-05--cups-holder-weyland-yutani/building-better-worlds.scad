include <defs.scad>

BODY_HEIGHT = 60;

module cavity() {
    translate([0, 0, -1])
    scale([10, 10, HEIGHT/100+1])
    linear_extrude(h=1)
    import("cavity.dxf");
}

module body() {
    translate([0, RECESS, 0])
    cube([LENGTH, WIDTH - RECESS, BODY_HEIGHT]);
}

module all() {
    difference() {
        body();

        cavity();

        translate([0, RECESS-ATOM, 0])
        rotate([90, 0, 0])
        logo();

        translate([0, RECESS, 7])
        rotate([20, 0, 0])
        translate([-LENGTH/2, -5, -7*2])
        cube([LENGTH*2, 5, 7*2]);
    }
}



module logo() {
    delta = .1/4;
    depth = 1.5;
    
    for (z=[0:delta:depth]) {
        translate([0, 0, -z])
        linear_extrude(delta+ATOM)
        offset(r=-z)
        import("logo-bbw.dxf");
    }
}



scale(RATIO) all();
