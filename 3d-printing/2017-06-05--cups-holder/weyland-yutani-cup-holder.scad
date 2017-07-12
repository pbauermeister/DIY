/* WEYLAND-YUTANI CORP ESPRESSO CUPS HOLDER
 *
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */


LENGTH = 220;
HEIGHT = 83;
WIDTH = 81;
RECESS = 3; // 5 is too deep
CUP_DIAMETER = 62; // in mm

RATIO = CUP_DIAMETER / 65;
scale(RATIO)
rotate([90, 0, 0])
all();

module main() {
    if(1)
    translate([0, WIDTH, 0])
    rotate([90, 0, 0])
    scale([10, 10, WIDTH/100])
    linear_extrude(h=1)
    import("logo.dxf");

       
    translate([0, RECESS, HEIGHT-12])
    cube([LENGTH, WIDTH - RECESS, 12]);    
}

module side_cut() {
    translate([0, WIDTH, 0])
    rotate([90, 0, 0])
    scale([10, 10, WIDTH/100])
    linear_extrude(h=1)
    import("side-cut.dxf");
}

module cavity() {
    scale([10, 10, HEIGHT/100+1])
    linear_extrude(h=1)
    import("cavity.dxf");
}

module wall() {
    scale([10, 10, HEIGHT/100])
    linear_extrude(h=1)
    import("wall.dxf");
}

module all() {
    translate([0, 0, 2])
    difference() {
        union() {
            difference() {
                main();
               cavity();
            }
            wall();
        }
        side_cut();
    }

    cube([LENGTH, WIDTH, 2]);
}
