

WALL_THICKNESS = 3;
SIZE = 30;
STEPS = 7;
TOTAL_ROTATION = 70;
LAYER = 0.2;

module make_cube_edges(size, rotation, thickness, etch_base) {
    //thickness = WALL_THICKNESS;
    d1 = size - thickness*2; // to keep walls
    d2 = size + thickness*2 + 2; // to dig face
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

SIZE2 = SIZE - WALL_THICKNESS*2;
F = SIZE2/SIZE;
A = acos(SIZE/SIZE2/sqrt(2)) - 45;

module recurse(to_go, size, angle, thickness, first) {
    if (to_go) {
        echo(thickness);
        make_cube_edges(size, angle, thickness, !first);
        recurse(to_go -1, size*F, angle + A, thickness*F, false);
    }
}

recurse(STEPS, SIZE, 0, WALL_THICKNESS, true);