$fn=60;

DIAMETER = 25;

module spheres() {
    union() {
        difference(){
            sphere(r=0.5);
    //        rotate([54.7 + 180, 0, 0])
    //        rotate([0, 0, 45])
            cube(1,1,1);
        }
        sphere(0.25);
    }
}

module support() {
    translate([0, 0, -0.455])
    scale([1, 1, 0.75/DIAMETER])
    difference() {
        cylinder(r=0.295);
        cylinder(r=0.2);
    }
}

module base_etch() {
    translate([0, 0, -2 -0.43])
    cylinder(h=2, r=0.6);
}

scale(DIAMETER) {
    difference() {
        union() {
            spheres();
//            support();
        }
        base_etch();
    }
}
