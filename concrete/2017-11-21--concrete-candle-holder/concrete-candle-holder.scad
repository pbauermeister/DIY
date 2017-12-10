
//// PARAMETERS
WALL_THICKNESS = 1; // 1.2;
WALL_THICKNESS2 = 0.8;

SLICE_HEIGHT = 0.125;
SLICE_HEIGHT = 0.2;

CANDLE_DIAMETER = 40.5;
CANDLE_HEIGHT = 17;
CANDLE_WICK_DIAMETER = 1;
CANDLE_WICK_HEIGHT = 22;

LEAVES_NB = 18;
LEAF_RADIUS = 50;

//HEIGHT = 28;
//LEAF_RADIUS = 35;
HEIGHT = 40;
LEAF_RADIUS = 42;

//// CONSTANTS
$fn = 180;
ATOM = 0.02;
PLAY = 0.4;
TOLERANCE = 0.17;

//// COMPUTED VALUES
LEAF_ANGLE = 360 / LEAVES_NB / 2;
LEAF_NARROWNESS_FACTOR = 120;
LEAF_RADIUS_COS = LEAF_RADIUS * cos(LEAF_ANGLE/LEAF_NARROWNESS_FACTOR);
LEAF_RADIUS_SIN = LEAF_RADIUS * sin(LEAF_ANGLE/LEAF_NARROWNESS_FACTOR);
CANDLE_CHAMBER_HEIGHT = CANDLE_HEIGHT + WALL_THICKNESS;
CANDLE_CHAMBER_DIAMETER = CANDLE_DIAMETER + 0.5;
CAVITY_RADIUS = CANDLE_CHAMBER_DIAMETER/2 + WALL_THICKNESS2+ATOM*2;

//// COMPUTATIONS
module barrel(outer_radius, inner_radius, height) {
    scale([1, 1, height])
    difference() {
        cylinder(r=outer_radius);
        if (inner_radius!=0)
            translate([0, 0, -0.5]) scale([1, 1, 2])
            cylinder(r=inner_radius>0 ? inner_radius : outer_radius+inner_radius);
    }
}

// 2D cut of one layer
module footprint(k) {
    scale([k, k, 1])
    for (i=[0:LEAVES_NB-1]) {
        rotate([0, 0, LEAF_ANGLE*i*2])
        polygon(points=[
            [0,-ATOM] ,[LEAF_RADIUS,-ATOM],
            [LEAF_RADIUS,ATOM], [0, ATOM]
            ]
        );
    }
    circle(d=CANDLE_CHAMBER_DIAMETER);
}

// One layer
module layer(thickness, k) {
    linear_extrude(height=thickness)
    difference() {
        offset(delta=WALL_THICKNESS/2) footprint(k);
        footprint(k);
    }
}

// Axial rotation of leaves
function twist(h) = sin(h/HEIGHT*360 * .75 + 45) * 9;

// Leaf shape in the vertical plane
function profile0(h) = 1-tan(360/2/PI * ( pow ((h/HEIGHT)*1.5-0.8,2)  *PI/2)) + h/HEIGHT;
// Experiment on Google: https://www.google.ch/search?dcr=0&ei=ycgrWq2dOcPwUsycieAI&q=1-tan%28%28%28x*1.5-0.8%29%5E2*pi%2F2%29%29+%2B+x&oq=1-tan%28%28%28x*1.5-0.8%29%5E2*pi%2F2%29%29+%2B+x
function profile(h) = profile0(h) / 3 + 0.5;

// All leaves
module shape() {
    for (h=[0:SLICE_HEIGHT:HEIGHT-SLICE_HEIGHT]) {
        k = profile(h);
        rotate([0, 0, twist(h)])
        translate([0, 0, h])
        layer(SLICE_HEIGHT, k);
    }
}

// Whole holder
module all() {
    difference() {
        // leaves
        translate([0, 0, 0.19])
        shape();
        // bottom cavity to connect chambers
        translate([0, 0, -WALL_THICKNESS])
        cylinder(r=CAVITY_RADIUS, h=HEIGHT-CANDLE_CHAMBER_HEIGHT +ATOM);
        
        // hole to connect chambers
        translate([0, 0, HEIGHT - CANDLE_CHAMBER_HEIGHT*.925])
        barrel(LEAF_RADIUS*.85, CANDLE_CHAMBER_DIAMETER/2 + LEAF_RADIUS*0, CANDLE_CHAMBER_HEIGHT/1.3);
        
        translate([0, 0, -6 -0.75])
        cylinder(r=LEAF_RADIUS, h=10);
    }
    // bottom ring
    translate([0, 0, WALL_THICKNESS*2.6])
    barrel(CANDLE_CHAMBER_DIAMETER/2+WALL_THICKNESS2*2, -WALL_THICKNESS, WALL_THICKNESS);

    // top ring
    translate([0, 0, HEIGHT-WALL_THICKNESS])
    barrel(LEAF_RADIUS*.872, - WALL_THICKNESS, WALL_THICKNESS);

    // mid ring
    translate([0, 0, HEIGHT*.66-WALL_THICKNESS])
    barrel(LEAF_RADIUS*1.019 + WALL_THICKNESS, - WALL_THICKNESS, WALL_THICKNESS);

    // candle holder
    translate([0, 0, HEIGHT - CANDLE_CHAMBER_HEIGHT])
    difference() {
        cylinder(d=CANDLE_CHAMBER_DIAMETER + WALL_THICKNESS2*2, h=CANDLE_CHAMBER_HEIGHT);
        
        translate([0, 0, -ATOM])
        cylinder(d=CANDLE_CHAMBER_DIAMETER, h=CANDLE_CHAMBER_HEIGHT +ATOM*2);
    }
}

// Bottom plate of candle cavity.
// Successive partial layers help bridging the horizontal hangover.
module plate() {
    d = CANDLE_CHAMBER_DIAMETER+WALL_THICKNESS2*2;
    for(a=[[4, 0, 1.75], [3, 90, 2], [2, 45, 3], [2, -45, 3]])
        rotate([0, 0, a[1]*45])
        difference() {
            h = a[0]*PLAY;
            cylinder(d=d, h=h);
            translate([0, 0, h/2+ATOM])
            cube([d+PLAY, d/a[2], h+ATOM*4], true);
        }

    translate([0, 0, PLAY-WALL_THICKNESS])
    cylinder(d=d, h=WALL_THICKNESS);
}

// Candle
module candle() {
    translate([0, 0, HEIGHT - CANDLE_CHAMBER_HEIGHT])
    color("white") {
        cylinder(d=CANDLE_DIAMETER, h=CANDLE_CHAMBER_HEIGHT);
        cylinder(d=CANDLE_WICK_DIAMETER, h=CANDLE_WICK_HEIGHT);
    }
}

// Everything
translate([0, 0, HEIGHT])
rotate([180, 0, 0]) 
{
    translate([0, 0, HEIGHT-CANDLE_CHAMBER_HEIGHT-WALL_THICKNESS])
    plate();
    all();
    %candle();
}
