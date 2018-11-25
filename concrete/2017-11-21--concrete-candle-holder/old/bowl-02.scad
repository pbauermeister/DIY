$fn = 180;

SIDE = 100;
THICKNESS = 1;
N = 12;
SQ2 = sqrt(2);
CANDLE_DIAMETER = 40 + THICKNESS*2;
CANDLE_HEIGHT = 15 + THICKNESS;

ELEVATION = 3.9; // ADJUST OR DO MORE MATH ;-)
BASE_DIAMETER = SIDE*0.75; // ADJUST OR DO MORE MATH ;-)
BASE2_DIAMETER = SIDE*0.53;
ANGLE = 56.25;
ANGLE = 45;
SHIFT = 10.8;

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
            k = (i%2==0 ? 1:-1);
            translate([0, 0, -SIDE/12])
            rotate([0, 0, 360/N*i + k*SHIFT])
            translate([SIDE/1.4, 0, 0])
            rotate([k * ANGLE, 0, 0])
            rotate([0, 0, 45])
            difference() {
                th = THICKNESS*1.5;
                cube([SIDE, SIDE, th], true);
                
                // hollow out blades
                if(1) {
                    d= SIDE/3.4;
                    translate([-d,d,0])
                    cylinder(r=SIDE/8, h= THICKNESS*2, center=true);
                } else if(1){
                    d = SIDE/3;
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
            translate([0, 0, -SIDE/4.25])
            barrel(BASE_DIAMETER/2, BASE2_DIAMETER/2 , h=THICKNESS);

            // top ring
            TOP_DIAMETER = SIDE * .92;
            enveloppe()
            translate([0, 0, SIDE/6.9])
            barrel(TOP_DIAMETER/2, TOP_DIAMETER/2-THICKNESS*3 , THICKNESS*2);

        }

        // candle holder cavity
        translate([0, 0, -CANDLE_HEIGHT + ELEVATION + THICKNESS])
        cylinder(d=CANDLE_DIAMETER -THICKNESS*2, h=CANDLE_HEIGHT);

        // flatten base
        translate([0, 0, -SIDE/2-SIDE/4.25])
        cube([SIDE, SIDE, SIDE], true);
    }
}

color("orange")
all();


