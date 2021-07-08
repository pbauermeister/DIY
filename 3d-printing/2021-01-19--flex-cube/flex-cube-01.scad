K = 2;
SIZE = 60  /K;
HEIGHT = SIZE/1;
THICKNESS = .5; //.45; //.16; //0.1;
Z_THICKNESS = .3; //.2; //.12; //0.2;
STEPS = 6 /K;
Z_STEPS = floor(HEIGHT/Z_THICKNESS/4);
echo(Z_STEPS);

module Layer(z, last=false) {
    // y-lines
    for (i=[0:STEPS]) {
        x = i*SIZE/STEPS;
        translate([x, 0, z])
        cube([THICKNESS, SIZE+THICKNESS, Z_THICKNESS]);
    }

    // x-lines
    for (i=[0:STEPS]) {
        y = i*SIZE/STEPS;
        translate([0, y, z+Z_THICKNESS])
        cube([SIZE+THICKNESS, THICKNESS, Z_THICKNESS]);
    }

    if(!last) {
        // supports along x
        for (i=[0:STEPS]) {
            x = (i)*SIZE/STEPS;
            translate([x, 0, z+Z_THICKNESS*2])
            cube([THICKNESS, THICKNESS, Z_THICKNESS*3]);
        }
        for (i=[0:STEPS]) {
            x = (i)*SIZE/STEPS;
            translate([x, SIZE, z+Z_THICKNESS*2])
            cube([THICKNESS, THICKNESS, Z_THICKNESS*3]);
        }
    }

    // supports along y
    for (i=[0:STEPS-1]) {
        y = (i+0.5)*SIZE/STEPS;
        translate([0, y, z+Z_THICKNESS])
        cube([THICKNESS, THICKNESS, Z_THICKNESS*2]);
    }
    for (i=[0:STEPS-1]) {
        y = (i+0.5)*SIZE/STEPS;
        translate([SIZE, y, z+Z_THICKNESS])
        cube([THICKNESS, THICKNESS, Z_THICKNESS*2]);
    }

    // y-lines, shifted
    for (i=[0:STEPS-1]) {
        x = (i+0.5)*SIZE/STEPS;
        translate([x, 0, z+Z_THICKNESS*2])
        cube([THICKNESS, SIZE+THICKNESS, Z_THICKNESS]);
    }

    // x-lines, shifted
    for (i=[0:STEPS-1]) {
        y = (i+0.5)*SIZE/STEPS;
        translate([0, y, z+Z_THICKNESS*3])
        cube([SIZE+THICKNESS, THICKNESS, Z_THICKNESS]);
    }
}

for (i=[0:Z_STEPS]) {
    Layer(i*Z_THICKNESS*4, i==Z_STEPS);
}
