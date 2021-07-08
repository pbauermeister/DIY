$fn = 180;
INNER_DIAMETER = 1.6;
OUTER_DIAMETER = 2.6;
HEIGHT = 20;

OPENING = 1.2; //1.5;
TURN = 360;

module piece(turn, extra=0) {
    difference() {
        // main body
        cylinder(d=OUTER_DIAMETER+extra*2, h=HEIGHT);
        
        // remove central hole
        translate([0, 0, -.5])
        cylinder(d=INNER_DIAMETER, h=HEIGHT+1);

        // carve screw
        for (i=[0:OPENING/50:HEIGHT]) {
            j = i+1;
            k = i-1;
            rotate([0, 0, i/HEIGHT*turn])
            translate([0, -OPENING/2, i])
            cube([OUTER_DIAMETER, OPENING, OPENING]);
        }
    }
}

// make 4 pieces
for (i=[0:3]) {
    translate([0, OUTER_DIAMETER*6*i, 0])
    piece(TURN*3, .50);
}
