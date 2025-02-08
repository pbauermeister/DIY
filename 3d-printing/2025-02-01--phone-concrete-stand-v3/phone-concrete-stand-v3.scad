PIPE_THICKNESS      =   2.5;
PIPE_DIAMETER_INNER = 102;
PIPE_HEIGHT         = 180;
PLUG_WIDTH          =  13;

FRONT_THICKNESS     =  40;
SLANT_1             =  35;
MARGIN_1            =  20;
THICKNESS_1         =  12;

PHONE_THICKNESS     =  20; 
SLANT_2             =  50;

SLANT_3             =  65;

PIPE_DIAMETER_OUTER = PIPE_DIAMETER_INNER + 2 * PIPE_THICKNESS;

ATOM      = 0.01;
TOLERANCE = 0.17;
PLAY      = 0.4;

$fn       = 200;

module pipe() {
    difference() {
        cylinder(d=PIPE_DIAMETER_OUTER, h=PIPE_HEIGHT);
        translate([0, 0, -ATOM])
        cylinder(d=PIPE_DIAMETER_INNER, h=PIPE_HEIGHT+ATOM*2);
    }
}

//%pipe();

difference() {
    cylinder(d=PIPE_DIAMETER_INNER - PLAY, h=PIPE_HEIGHT);

    d = PIPE_DIAMETER_INNER*2;

    // first slant
    translate([0, -d/4, FRONT_THICKNESS])
    rotate([SLANT_1, 0, 0]) {
        translate([0, d/2 + MARGIN_1, d/2])
        cube([d, d, d], center=true);
        translate([0, 0, d/2])
        cube([PLUG_WIDTH, d, d], center=true);
    }

    // shave front rest
    translate([0, -d/4, FRONT_THICKNESS])
    rotate([SLANT_1, 0, 0])
    translate([0, d/3, d/2 + THICKNESS_1])
    cube([d, d, d], center=true);

    // medium slant
    translate([0, -d/4 + d*.18, FRONT_THICKNESS + d*.02])
    rotate([SLANT_2, 0, 0]) {
        translate([0, d/2, PHONE_THICKNESS/2]) 
        cube([d, d, PHONE_THICKNESS], center=true);

        translate([0, 0, d/2])
        cube([PLUG_WIDTH, d, d], center=true);
    }

%    // steep slant
    translate([0, -d/4 + d*.28, FRONT_THICKNESS + d*.02])
    rotate([SLANT_3, 0, 0]) {
        translate([0, d/2, PHONE_THICKNESS/2]) 
        cube([d, d, PHONE_THICKNESS], center=true);

        translate([0, 0, d/2])
        cube([PLUG_WIDTH, d, d], center=true);
    }
}