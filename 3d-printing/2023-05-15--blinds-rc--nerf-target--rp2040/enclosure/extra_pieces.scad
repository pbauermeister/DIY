include <defs.scad>

/*
19
27
35
*/

module plate() {
    cube([48, BOARD_WIDTH - TOLERANCE, 4]);
}


plate();