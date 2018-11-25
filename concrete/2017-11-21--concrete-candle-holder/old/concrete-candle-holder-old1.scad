$fn = 180;
ATOM = 0.02;
PLAY = 0.4;
TOLERANCE = 0.17;

WALL_THICKNESS = 1;
WALL_THICKNESS_THIN = 0.5;

HEIGHT = 30;
SLICE_HEIGHT = 0.25;

CANDLE_DIAMETER = 40;
CANDLE_HEIGHT = 15;
CANDLE_WICK_DIAMETER = 1;
CANDLE_WICK_HEIGHT = 22;

LEAVES_NB = 6 * 3;
LEAF_RADIUS = 50;

HEIGHT = 25;
LEAF_RADIUS = 50 -10;

/////
LEAF_ANGLE = 360 / LEAVES_NB / 2;
LEAF_NARROWNESS_FACTOR = 120;
LEAF_RADIUS_COS = LEAF_RADIUS * cos(LEAF_ANGLE/LEAF_NARROWNESS_FACTOR);
LEAF_RADIUS_SIN = LEAF_RADIUS * sin(LEAF_ANGLE/LEAF_NARROWNESS_FACTOR);
CANDLE_CHAMBER_HEIGHT = CANDLE_HEIGHT + WALL_THICKNESS;
CANDLE_CHAMBER_DIAMETER = CANDLE_DIAMETER + 0.5;
CAVITY_RADIUS = LEAF_RADIUS/1.75;


module barrel(outer_radius, inner_radius, height) {
    scale([1, 1, height])
    difference() {
        cylinder(r=outer_radius);
        if (inner_radius)
            translate([0, 0, -0.5]) scale([1, 1, 2])
            cylinder(r=inner_radius);
    }
}

module footprint(k) {
    scale([k, k, 1])
    for (i=[0:LEAVES_NB-1]) {
        rotate([0, 0, LEAF_ANGLE*i*2])
        polygon(points=[
            [0,0],
            [LEAF_RADIUS,0],
            [LEAF_RADIUS_COS,LEAF_RADIUS_SIN],
            [0,0]]
        );
    }
    circle(d=CANDLE_CHAMBER_DIAMETER);
}

module layer(thickness, k) {
    linear_extrude(height=thickness)
    difference() {
        offset(r=WALL_THICKNESS) footprint(k);
        footprint(k);
    }
}

function profile(h) = (2+sin(h/HEIGHT*90))/3 * (4+sin(pow(h/HEIGHT,10)*90 + 120))/5;
function twist(h) = sin(h/HEIGHT*360 * .75 + 45) * 9;

module shape() {
    for (h=[0:SLICE_HEIGHT:HEIGHT-SLICE_HEIGHT]) {
        k = profile(h); //(2+sin(h/HEIGHT*90))/3;
        rotate([0, 0, twist(h)])
        translate([0, 0, h])
        layer(SLICE_HEIGHT, k);
    }
}

module all() {
    difference() {
        // leaves
        shape();
        // bottom cavity to connect chambers
        translate([0, 0, -WALL_THICKNESS])
        cylinder(r=CAVITY_RADIUS, h=HEIGHT-CANDLE_CHAMBER_HEIGHT +ATOM);

        // cavity to clip candle chamber plate
        translate([0, 0, -ATOM])
        cylinder(r=CANDLE_CHAMBER_DIAMETER/2 + WALL_THICKNESS+ATOM, h=HEIGHT-CANDLE_CHAMBER_HEIGHT +ATOM);
        
        // hole to connect chambers
        translate([0, 0, HEIGHT - CANDLE_CHAMBER_HEIGHT*.75])
        barrel(LEAF_RADIUS*.8, CANDLE_CHAMBER_DIAMETER/2 + LEAF_RADIUS*.1, CANDLE_CHAMBER_HEIGHT/2);
    }

    // candle holder
    translate([0, 0, HEIGHT - CANDLE_CHAMBER_HEIGHT])
    difference() {
        cylinder(d=CANDLE_CHAMBER_DIAMETER + WALL_THICKNESS*2, h=CANDLE_CHAMBER_HEIGHT);
        
        translate([0, 0, -ATOM])
        cylinder(d=CANDLE_CHAMBER_DIAMETER, h=CANDLE_CHAMBER_HEIGHT +ATOM*2);
    }
}

module candle() {
    translate([0, 0, HEIGHT - CANDLE_CHAMBER_HEIGHT])
    color("white") {
        cylinder(d=CANDLE_DIAMETER, h=CANDLE_CHAMBER_HEIGHT);
        cylinder(d=CANDLE_WICK_DIAMETER, h=CANDLE_WICK_HEIGHT);
    }
}

// body
translate([0, 0, HEIGHT])
rotate([180, 0, 0]) 
{
    all();
    %candle();
}

// plate
translate([LEAF_RADIUS+CANDLE_CHAMBER_DIAMETER/2+10, 0, 0]) {
    cylinder(d=CANDLE_CHAMBER_DIAMETER + WALL_THICKNESS*2, h=WALL_THICKNESS_THIN);
    translate([0, 0, WALL_THICKNESS_THIN])
    cylinder(d=CANDLE_CHAMBER_DIAMETER-TOLERANCE, h=WALL_THICKNESS_THIN);
}