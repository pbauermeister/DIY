//$fn = 180;

WALL_THICKNESS = 0.6; //1;

CANDLE_CAVITY_DIAMETER = 41;
CANDLE_CAVITY_HEIGHT = 15;

BLOCK_HEIGHT = 30;
BLOCK_LENGTH = 100;
BLOCK_WIDTH = 60;

SHIFT = 10;

ATOM = 0.02;
N = 6;

module basic_shape(with_groves=false) {
    translate([-BLOCK_LENGTH/2, -BLOCK_WIDTH/2, 0])
    difference() {
        cube([BLOCK_LENGTH, BLOCK_WIDTH, BLOCK_HEIGHT]);

        if (with_groves)
        for (i=[-N:N-1]) {
            translate([i*BLOCK_LENGTH/N - GROVE/2, 0, -WALL_THICKNESS])
            rotate([0, 0, -45])
            cube([GROVE, BLOCK_WIDTH*2, BLOCK_HEIGHT]);
        }

        translate([CANDLE_CAVITY_DIAMETER/2 + SHIFT,
                   SHIFT,
                   BLOCK_HEIGHT-CANDLE_CAVITY_HEIGHT+ATOM])
        cylinder(d=CANDLE_CAVITY_DIAMETER, h=CANDLE_CAVITY_HEIGHT);

        translate([BLOCK_LENGTH - CANDLE_CAVITY_DIAMETER/2 - SHIFT,
                   BLOCK_WIDTH- SHIFT,
                   BLOCK_HEIGHT-CANDLE_CAVITY_HEIGHT+ATOM])
        cylinder(d=CANDLE_CAVITY_DIAMETER, h=CANDLE_CAVITY_HEIGHT);
    }
}

module stripes()
        for (i=[-N:N-1]) {
            translate([i*BLOCK_LENGTH/N - BLOCK_LENGTH/2, -BLOCK_WIDTH/2, WALL_THICKNESS])
            rotate([0, 0, -45])
            cube([WALL_THICKNESS, BLOCK_WIDTH*2, BLOCK_HEIGHT/2-WALL_THICKNESS]);
        }


module mink() {
    minkowski() {
        basic_shape();
//        sphere(WALL_THICKNESS*2);
        cube(WALL_THICKNESS*2, true);
    }
}

module skin() {
    difference() {
        mink();
        basic_shape();
    }
}

if(0)
intersection() {
    union() {
        intersection() {
            skin();
            
            translate([-BLOCK_LENGTH, -BLOCK_WIDTH, WALL_THICKNESS])
            cube([BLOCK_LENGTH*2, BLOCK_WIDTH*2, BLOCK_HEIGHT-WALL_THICKNESS-ATOM]);
        }
    }
    translate([0, 0, BLOCK_HEIGHT/2])
    cube([BLOCK_LENGTH-1, BLOCK_WIDTH+1, BLOCK_HEIGHT], true);    
}



difference() {
    cube([BLOCK_LENGTH, WALL_THICKNESS, BLOCK_HEIGHT]);
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

    translate([SHIFT, 0, BLOCK_HEIGHT*.2])
    cube([1, BLOCK_WIDTH, BLOCK_HEIGHT*.6]);    

    translate([SHIFT, 0, BLOCK_HEIGHT*.5 - WALL_THICKNESS])
    cube([BLOCK_HEIGHT*.6, BLOCK_WIDTH, 1]);    


    translate([BLOCK_LENGTH-SHIFT, 0, BLOCK_HEIGHT*.2])
    cube([1, BLOCK_WIDTH, BLOCK_HEIGHT*.5]);    

    translate([BLOCK_LENGTH-BLOCK_HEIGHT*.6-SHIFT, 0, BLOCK_HEIGHT*.5 -WALL_THICKNESS])
    cube([BLOCK_HEIGHT*.6, BLOCK_WIDTH, 1]);    

