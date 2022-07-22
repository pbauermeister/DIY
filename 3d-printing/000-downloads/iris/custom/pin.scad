$fn=90;

/*
cylinder(h=0.5, r=5);
cylinder(h=1.6, r=3.25);
cylinder(h=5, r=1.5);
*/

/*
translate([0, 0, 0.5]) cylinder(h=0.5, r=3.5);
cylinder(h=1, r=3.3);
cylinder(h=5, r=1.5);
*/

translate([10, 0, 0]) {
    cylinder(h=0.5, r=3.3);
    cylinder(h=5, r=1.5);
}

difference() {
    cylinder(h=0.5, r=4.9);
    translate([0, 0, -1]) cylinder(h=5, r=1.75);
}
