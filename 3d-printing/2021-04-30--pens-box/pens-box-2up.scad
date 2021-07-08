ATOM = 0.001*200;
WALL = 1.75;
LENGTH = 140;
WIDTH1 = 32;
WIDTH2 = 39;
HEIGHT = 16;

TOTAL_WIDTH = WALL + WIDTH1 + WALL + WIDTH2 + WALL;
TOTAL_LENGTH = WALL + LENGTH + WALL;
TOTAL_HEIGHT = WALL + HEIGHT;

echo(TOTAL_WIDTH);

module compartment(length, width, height, hole=false) {
    difference() {
        cube([length + WALL*2, width + WALL*2, height+WALL]);
        
        translate([ATOM, ATOM, ATOM])
        cube([length + WALL*2-ATOM*2, width + WALL*2-ATOM*2, height + WALL+ATOM]);
        
        if (hole)
            translate([WALL, WALL*3, WALL*3])
            cube([length + WALL*2, width - WALL*4, height+WALL]);
    }
}

module skeleton() {
    compartment(LENGTH, WIDTH1, HEIGHT, true);
    
    translate([0, WIDTH1 + WALL*2, 0])
    compartment(LENGTH, WIDTH2, HEIGHT, true);
}

module all() {
    minkowski() {
        skeleton();
        scale([1, 1, 0.66])
        sphere(WALL/2);
    }
}

difference() {
    all();
    //cube(LENGTH/2, center=true);
}