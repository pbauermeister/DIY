use <lib.scad>


difference() {

    union() {
        main();

        if(1)
        translate([0, 0, 35 +.1])
        rotate([180, 0, 0])
        cap();

        translate([0, 0, 5 + 0])
        soap_piston();
    }

    rotate([90, 0, 0]) cylinder(d=1000, h=1000);    
}
