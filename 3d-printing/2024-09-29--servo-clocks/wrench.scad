use <all.scad>

//servo_shaft_wrench();

module fixture() {
    h = 5.5;
    difference() {
        cylinder(d=10, h=h, $fn=200);

        translate([0, 0, .3])
        shaft_hollowing();

        translate([0, 0, h-1])
        shaft_hollowing(1, true);
    }
}

fixture();

translate([0, 13, 0])
fixture();
