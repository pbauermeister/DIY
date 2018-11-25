$fn = 180;

OVERALL_DIAMETER= 120; //80;
OVERALL_HEIGHT = 90;
CAVITY_DIAMETER = 40;
BOTTOM_THICKNESS = 13;
BOTTOM_FLATTENING = 2.5;
CENTER_HOLE_DIAMETER = 25;

IS_SPHERE = false;

CANDLE_DIAMETER = 38;
CANDLE_HEIGHT = 15;
CANDLE_WICK_DIAMETER = 1;
CANDLE_WICK_HEIGHT = 22;

ACRYL_THICKNESS = 3;
ACRYL_CUTOUTS_DIAMETER_MARGIN = 7;
ACRYL_CUTOUTS_DIAMETER_MARGIN = -2;
N = 6;

ATOM = 0.001;
PLAY = 0.17;

OVERALL_DIAMETER= 90; //80;
OVERALL_HEIGHT = 60;

module three_quarters() {
    difference() {
        children();    
        translate([0, 0, -ATOM]) {
            a = 15;
            rotate([0, 0, -a]) cube([OVERALL_DIAMETER, OVERALL_DIAMETER, OVERALL_HEIGHT+ATOM*2]);
            rotate([0, 0,  a]) cube([OVERALL_DIAMETER, OVERALL_DIAMETER, OVERALL_HEIGHT+ATOM*2]);
        }
    }
}

module candle() {
    color("white") {
        cylinder(d=CANDLE_DIAMETER, h=CANDLE_HEIGHT);
        cylinder(d=CANDLE_WICK_DIAMETER, h=CANDLE_WICK_HEIGHT);
    }
}

module body() {
    difference() {
        if (IS_SPHERE)
            translate([0, 0, OVERALL_HEIGHT/2 - BOTTOM_FLATTENING])
            resize([0, 0, OVERALL_HEIGHT + BOTTOM_FLATTENING]) sphere(d=OVERALL_DIAMETER);
        else
            cylinder(d=OVERALL_DIAMETER, h=OVERALL_HEIGHT);

        translate([0, 0, BOTTOM_THICKNESS])
            cylinder(d1=CAVITY_DIAMETER,
                     d2=CAVITY_DIAMETER + OVERALL_HEIGHT/CAVITY_DIAMETER*4,
                     h=OVERALL_HEIGHT-BOTTOM_THICKNESS+ATOM);
        translate([0, 0, -OVERALL_DIAMETER/2])
            cube(OVERALL_DIAMETER, true);
        
//        translate([0, 0, -ATOM])
//            cylinder(d=CENTER_HOLE_DIAMETER, h=OVERALL_HEIGHT);
    }
}

module insert(substractive=false) {
    three_quarters()
    intersection() {
        if (!substractive)
            body();

        difference() {
            union() {
                translate([0, 0, OVERALL_HEIGHT/2])
                cube([OVERALL_DIAMETER, OVERALL_DIAMETER, ACRYL_THICKNESS], true);

                translate([0, 0, OVERALL_HEIGHT * .75])
                cube([OVERALL_DIAMETER, OVERALL_DIAMETER, ACRYL_THICKNESS], true);
            }
 
            d = ACRYL_CUTOUTS_DIAMETER_MARGIN > 0
                ? (OVERALL_DIAMETER-CAVITY_DIAMETER)/2-ACRYL_CUTOUTS_DIAMETER_MARGIN*2
                : -ACRYL_CUTOUTS_DIAMETER_MARGIN;
            for (i=[0:N-1]) {
                rotate([0, 0, 360/N*i])
                translate([(CAVITY_DIAMETER+OVERALL_DIAMETER)/4, 0, 0])
                cylinder(d=d, h=OVERALL_HEIGHT);
            }
        }
    }
}

module concrete() {
    color("lightgrey")
    difference() {
        body();
        insert(substractive=true);
    }
}

module all() {
    concrete();
    //%color("red", 0.1) insert();
}


three_quarters() all();

translate([0, 0, BOTTOM_THICKNESS+PLAY])
candle();
