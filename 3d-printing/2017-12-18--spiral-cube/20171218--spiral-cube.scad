

WALL_THICKNESS = 1;
SIZE = 50;
STEPS = 150;
TOTAL_ROTATION = 30;
K = 2;

module make_cube_edges(size, rotation) {
    d1 = size - WALL_THICKNESS*2; // to keep walls
    d2 = size + WALL_THICKNESS; // to dig face
    rotate([rotation, rotation, rotation])
    difference() {
        cube([size, size, size], true); // full cube
        cube([d2, d1, d1], true); // dig along X axis
        cube([d1, d2, d1], true); // dig along Y axis
        cube([d1, d1, d2], true); // dig along Z axis
    }        
}

for (i=[0:STEPS]) {
    make_cube_edges(SIZE * (1 - i/STEPS), TOTAL_ROTATION*pow(i/STEPS*K, 2));
}
