use <lib.scad>

intersection() {
    union() {   
        translate([-.17, 0, 0])
        plateau_1_a_1();
        plateau_1_a_2();
    }

    translate([0, -100, 0])
    cube([100, 200, 100]);
}

!plateau_1_a_2();
