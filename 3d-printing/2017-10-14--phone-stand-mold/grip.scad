use <all-parts.scad>

module one() {
    rotate([90, 0, 0])
    diagonal_grip(flat=true);

    translate([30, -.4, -36.26-1])
    cube([17.5, .4, 70]);

    /*
    translate([47.1, -.4, -36.26])
    cube([.4, 15, 70]);
    */
}


one();
translate([0, 30, 0]) one();
