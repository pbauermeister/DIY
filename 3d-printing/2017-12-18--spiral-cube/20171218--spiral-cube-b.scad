

WALL_THICKNESS = 3;
SIZE = 35;
STEPS = 150;
TOTAL_ROTATION = 30;
K = 2;
LAYER = 0.17;

module make_cube_edges(size, rotation, etch_base) {
    d1 = size - WALL_THICKNESS*2; // to keep walls
    d2 = size + WALL_THICKNESS; // to dig face
    rotate([0, 0, rotation])
    difference() {
        cube([size, size, size], true); // full cube
        cube([d2, d1, d1], true); // dig along X axis
        cube([d1, d2, d1], true); // dig along Y axis
        cube([d1, d1, d2], true); // dig along Z axis
        
        if (etch_base)
            translate([0, 0, -size/2])
            cube([d1, d2, LAYER*2], true); // dig along Z axis
    }        
}

for (i=[0:WALL_THICKNESS*4:STEPS]) {
    make_cube_edges(SIZE * (1 - i/STEPS), TOTAL_ROTATION*pow(i/STEPS*K, 2), i);
}
