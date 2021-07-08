/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

$fn = 36;

module clip() {
    cylinder(r=2, h=20, center=true);

    rotate([90, 0, 0])
    cylinder(r=3, h=20, center=true);
}

module chamfer(radius) {
    INF = 999999;
    minkowski() {
        difference() {
            cube(INF-radius*2, center=true);
            minkowski() {
                difference() {
                    cube(INF, center=true);
                    children();
                }
                sphere(radius, $fn=12);
            }
        }
        sphere(radius, $fn=12);
    }
}

chamfer(0.5)
clip();

translate([7, 0, 0])
clip();
