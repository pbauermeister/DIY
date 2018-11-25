$fn = 180;

WALL_THICKNESS = 0.6; //1;

CANDLE_CAVITY_DIAMETER = 40.5;
CANDLE_CAVITY_HEIGHT = 18;

BLOCK_HEIGHT = 30;
BLOCK_LENGTH = 100;
BLOCK_WIDTH = 60;

SHIFT = 10;

ATOM = 0.02;
N = 6;

module wall() {
    difference() {
        cube([BLOCK_LENGTH, WALL_THICKNESS*1.5, BLOCK_HEIGHT]);
        translate([BLOCK_LENGTH - CANDLE_CAVITY_DIAMETER/2 - SHIFT,
                   CANDLE_CAVITY_DIAMETER/2- SHIFT,
                   BLOCK_HEIGHT-CANDLE_CAVITY_HEIGHT+ATOM])
        cylinder(d=CANDLE_CAVITY_DIAMETER, h=CANDLE_CAVITY_HEIGHT);
    }
    difference() {
        translate([BLOCK_LENGTH - CANDLE_CAVITY_DIAMETER/2 - SHIFT,
                   CANDLE_CAVITY_DIAMETER/2- SHIFT,
                   BLOCK_HEIGHT-CANDLE_CAVITY_HEIGHT+ATOM])
        cylinder(d=CANDLE_CAVITY_DIAMETER+WALL_THICKNESS*2, h=CANDLE_CAVITY_HEIGHT);

        translate([BLOCK_LENGTH - CANDLE_CAVITY_DIAMETER/2 - SHIFT,
                   CANDLE_CAVITY_DIAMETER/2- SHIFT,
                   BLOCK_HEIGHT-CANDLE_CAVITY_HEIGHT+WALL_THICKNESS])
        cylinder(d=CANDLE_CAVITY_DIAMETER, h=CANDLE_CAVITY_HEIGHT);
     
        translate([0, -BLOCK_WIDTH, WALL_THICKNESS])
        cube([BLOCK_LENGTH, BLOCK_WIDTH, BLOCK_HEIGHT]);    
    }
    
    r = 4;
    t = 1.5;
    translate([r, 0, r])
    cube([t, WALL_THICKNESS + t, BLOCK_HEIGHT-r*2]);

    translate([BLOCK_LENGTH-WALL_THICKNESS-r, 0, r])
    cube([t, WALL_THICKNESS +t, BLOCK_HEIGHT-r*2]);
}

module pillars(width=BLOCK_WIDTH, pwidth1=1, pwidth2=1) {
    shift = SHIFT -WALL_THICKNESS - .1;
    
    translate([shift, 0, BLOCK_HEIGHT*.2])
    cube([1, width, BLOCK_HEIGHT*.6]);    
    translate([shift, 0, BLOCK_HEIGHT*.4 - WALL_THICKNESS -1])
    cube([BLOCK_HEIGHT*.6 * pwidth1, width, 1]);    


    translate([BLOCK_LENGTH-shift, 0, BLOCK_HEIGHT*.2])
    cube([1, width, BLOCK_HEIGHT*.6]);    
    translate([BLOCK_LENGTH-BLOCK_HEIGHT*.6*pwidth2 -shift, 0, BLOCK_HEIGHT*.4 -WALL_THICKNESS -1])
    cube([BLOCK_HEIGHT*.6*pwidth2, width, 1]);    
}

rotate([90, 0, 0]) {
    wall();
    pillars(pwidth2=0.25);

    thickness = 1.6;
    translate([0, 0, BLOCK_HEIGHT+10]) {
        wall();
        translate([0, 1, 0])
        difference() {
            minkowski() {
                pillars(thickness);
                cube(1.25, true);
            }
            minkowski() {
                pillars(thickness+1);
                cube(0.25, true);
            }
        }
    }
}