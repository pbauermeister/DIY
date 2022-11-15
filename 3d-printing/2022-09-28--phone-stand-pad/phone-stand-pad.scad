LONG_DIAMETER   = 102;
SHORT_DIAMETER  = 100 -4;
MARGIN          =   2;
THICKNESS       =   1.5;
GROOVE_WIDTH    =  23.5 + .5;
GROOVE_WIDTH_2  =   2 +5;

CELL_WALL_WIDTH = .8;
CELL_N          = 10 + 2;

$fn = 90;

module shape(recess=0) { 
    difference() {
        resize([LONG_DIAMETER - MARGIN*2 - recess*2, SHORT_DIAMETER - MARGIN*2 -recess*2, THICKNESS])
        cylinder();
        
        translate([-20-12 +recess, 0, 0])
        cube([LONG_DIAMETER, GROOVE_WIDTH + recess*2, THICKNESS*4], true);

        cube([LONG_DIAMETER*2, GROOVE_WIDTH_2 + recess*2, THICKNESS*4], true);
    }
}

module cutout() {
    translate([0, 0, 0.4])
    intersection() {
        for (i=[0:CELL_N]) {
            for (j=[0:CELL_N]) {
                w = LONG_DIAMETER / CELL_N;
                h = SHORT_DIAMETER / CELL_N;
//                translate([LONG_DIAMETER/CELL_N*(i-CELL_N/2) +CELL_WALL_WIDTH/2, SHORT_DIAMETER/CELL_N*(j-CELL_N/2) +CELL_WALL_WIDTH/2, 0])
//                cube([w-CELL_WALL_WIDTH, h-CELL_WALL_WIDTH, THICKNESS*3]);
                d = (j%2) * w/2;
                translate([ LONG_DIAMETER/CELL_N*(i-CELL_N/2) - CELL_WALL_WIDTH + d,
                           SHORT_DIAMETER/CELL_N*(j-CELL_N/2),
                           0])
                cylinder(d=w-CELL_WALL_WIDTH, h=THICKNESS*3);
            }
        }
        shape(recess=CELL_WALL_WIDTH*2);    
    }
}

difference() {
    shape();
    cutout();
}

translate([LONG_DIAMETER/3-GROOVE_WIDTH/4, -GROOVE_WIDTH/2, 0])
cube([GROOVE_WIDTH/4, GROOVE_WIDTH, .3]);

translate([-LONG_DIAMETER/2+GROOVE_WIDTH/4, -GROOVE_WIDTH/2, 0])
cube([GROOVE_WIDTH/4, GROOVE_WIDTH, .3]);
