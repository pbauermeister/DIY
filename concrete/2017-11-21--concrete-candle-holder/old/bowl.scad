$fn = 180;

SIDE = 90;
THICKNESS = 1;
N = 12;
SQ2 = sqrt(2);
CANDLE_DIAMETER = 40;
CANDLE_HEIGHT = 15 + THICKNESS;

ELEVATION = 17.5; // ADJUST OR DO MORE MATH ;-)
BASE_DIAMETER = SIDE*0.88; // ADJUST OR DO MORE MATH ;-)

module barrel(outer_radius, inner_radius, height) {
    scale([1, 1, height])
    difference() {
        cylinder(r=outer_radius);
        if (inner_radius)
            translate([0, 0, -0.5]) scale([1, 1, 2])
            cylinder(r=inner_radius);
    }
}

module enveloppe() {
    intersection() {
        children();
        scale([1, 1, .66])
        sphere(d=SIDE);
    }
}

module blades() {
    enveloppe() {
        for (i=[0:N-1]) {
            rotate([0, 0, 360/N*i])
            translate([SIDE/1.5, 0, 0])
            rotate([56.25, 0, 0])
            rotate([0, 0, 45])
            difference() {
                cube([SIDE, SIDE, THICKNESS], true);
                
                // hollow out blades
                if(0) {
                    d= SIDE/4;
                    translate([-d,d,0])
                    cylinder(r=SIDE/6, h= THICKNESS*2, center=true);
                } else {
                    d = SIDE/3.5;
                    translate([-d ,d ,0])
                    cube(SIDE/4, h= THICKNESS*2, center=true);
                }
            }
        }
    }
 }

module all() {
    difference() {
        union() {
            blades();

            // candle holder
            translate([0, 0, -CANDLE_HEIGHT +ELEVATION])
            cylinder(d=CANDLE_DIAMETER, h=CANDLE_HEIGHT);
            
            // base ring
            enveloppe()
            translate([0, 0, -SIDE * 1/6])
            barrel(BASE_DIAMETER/2, BASE_DIAMETER/2-THICKNESS*3 , h=THICKNESS);
        }

        // candle holder cavity
        translate([0, 0, -CANDLE_HEIGHT + ELEVATION + THICKNESS])
        cylinder(d=CANDLE_DIAMETER -THICKNESS*2, h=CANDLE_HEIGHT);

        // flatten base
        translate([0, 0, -SIDE * (1-1/3)])
        cube([SIDE, SIDE, SIDE], true);
    }
}

color("orange")
all();


