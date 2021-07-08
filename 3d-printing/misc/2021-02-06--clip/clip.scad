/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

$fn = 60;

module clip() {
    translate([-18, -15.1, 0])
    linear_extrude(height=4)
    scale([3, 3, 1])
    import("clip.dxf");
}

module mold() {
    minkowski() {
        difference() {
            cube(30*2, center=true);
            clip();
        }
        sphere(0.5);
    }
}

module final() {
    minkowski() {
        difference() {
            cube(28*2, center=true);
            mold();
        }
        sphere(0.5);
    }
}


final();
