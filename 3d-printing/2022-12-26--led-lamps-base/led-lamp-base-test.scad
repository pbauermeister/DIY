use <led-lamp-base.scad>
use <base-carver.scad>
CARVE_R = 1.9;

module test1() {
    intersection() {
        translate([43+15, 0, 0]) union() {
            first();
            translate([-20, 0, 0])
            second();
        }
        //if(0) translate([-10, 0, 0])
        cube([80, 100, 17], true);
    }
}

module test2() {
    carve_base(r=CARVE_R)
    cube([80, 20, 10]);
}


test2();


// make flying, forcing support
translate([0, 0, -6]) cube([.1, .1, .2], true);
