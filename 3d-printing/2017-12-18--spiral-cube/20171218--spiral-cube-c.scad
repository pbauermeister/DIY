WALL_THICKNESS = 3;
SIZE = 35;
STEPS = 12;
TOTAL_ROTATION = 60;
LAYER = 0.2;

module make_cube_edges(size, rotation, etch_base) {
    thickness = WALL_THICKNESS;
    d1 = size - thickness*2; // to keep walls
    d2 = size + thickness; // to dig face
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

for (i=[0:STEPS]) {
    make_cube_edges(SIZE / exp(i/STEPS), i/STEPS * TOTAL_ROTATION, i);
}
