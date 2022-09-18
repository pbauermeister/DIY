
HOLE_DIAMETER = 0.4 + .3 + .3;
THICKNESS = 1.8;
THICKNESS2 = .5;

BORDER = 12;
SIZE = 120;
SIZE_Y = SIZE - BORDER;
SIZE_X = SIZE - BORDER*4;
PLAY = .5;

MARGIN = .17 * 1.5;
ATOM = .001;
STEP = 10;

$fn = $preview ? 120 : 60;

module grow() {
    minkowski() {
        children();
        cube(PLAY*2, center=true);
    }
}

module back() {
    difference() {
        cube([SIZE_X, SIZE_Y, THICKNESS]);
        grow() foot();
    }
}

module foot() {
    translate([BORDER, SIZE_Y/2 - THICKNESS/2, 0])
    cube([SIZE_X - BORDER*2, SIZE_Y/2+THICKNESS/2, THICKNESS]);

    translate([-BORDER, SIZE_Y - BORDER, 0])
    cube([SIZE_X + BORDER*2, BORDER, THICKNESS]);
}

module rest() {
    difference() {
        translate([-BORDER * 2, 0, 0])
        cube([SIZE_X + BORDER*4, SIZE_Y + BORDER, THICKNESS]);

        grow() {
            back();
            foot();
        }
        for(y=[STEP*2:STEP:SIZE_Y-BORDER-STEP])
            translate([-BORDER - PLAY*2, y, THICKNESS2])
            cube([SIZE_X + BORDER*2 + PLAY*4, THICKNESS*1.5, THICKNESS]);
    }
}

module all() {
    translate([-SIZE_X/2, -SIZE_Y/2 -BORDER/2, 0])
    difference() {
        union() {
            back();
            foot();
            rest();
        }
        
        dz = THICKNESS/2-HOLE_DIAMETER/2;
        dy = THICKNESS/2;

        translate([-BORDER*2 - BORDER/2, dy, dz])
        cube([SIZE_X+BORDER*5+BORDER, HOLE_DIAMETER*1.25, HOLE_DIAMETER]);

        translate([0, SIZE_Y/2 + dy*0, dz])
        cube([SIZE_X, HOLE_DIAMETER*1.25, HOLE_DIAMETER]);
    }    
}

//rotate([180, 0, 0])
all();

//%cube(SIZE, center=true);