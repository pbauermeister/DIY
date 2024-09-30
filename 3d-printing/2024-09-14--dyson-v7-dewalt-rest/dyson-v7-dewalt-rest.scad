/*
This piece is to be inserted into the bottom lid of the Dyson V7's dust container,
and secured with a central screw, to form a resting spacer when a battery adapter
for Dewalt battery is used.
*/


REST_HEIGHT        =  52;
INNER_DIAMETER     =  37 - .3;
INNER_HEIGHT       =  17;
EXTERNAL_DIAMETER  = 110;

INNER_LIP_DIAMETER =   .75;
INNER_LIP_HEIGHT   =   3;
INNER_SLIT_RADIUS  = INNER_DIAMETER/2 * .7;

GROOVE_DIAMETER    =   2;
SLIT_THICKNESS     =   1.5;

SCREW_LENGTH       =  REST_HEIGHT + INNER_HEIGHT - .5; //15;
SCREW_SLIT_TH      =   0.5;
SCREW_SLIT_D       =   8;

ATOM = 0.01;

$fn = $preview ? 50 : 120;

module oring(d1, d2, d3=0) {
    rotate_extrude(convexity = 10)
    translate([d1/2, 0, 0])
    resize([d2, d3 ? d3 : d2])
    circle(d=d2);
}

module space() {
    cylinder(d=EXTERNAL_DIAMETER, h=REST_HEIGHT);
}

module body_0() {
    cylinder(d=INNER_DIAMETER, h=REST_HEIGHT+INNER_HEIGHT);
    //cylinder(d=INNER_DIAMETER*2, h=REST_HEIGHT);

    intersection() {
        translate([0, 0, REST_HEIGHT/2])
        sphere(d=INNER_DIAMETER*2);
        space();
    }

    translate([0, 0, REST_HEIGHT + INNER_HEIGHT - INNER_LIP_HEIGHT/2])
    oring(INNER_DIAMETER, INNER_LIP_DIAMETER, INNER_LIP_HEIGHT);

}

module body() {
    difference() {
        body_0();

        // o-ring
        translate([0, 0, REST_HEIGHT + GROOVE_DIAMETER/2])
        oring(INNER_DIAMETER, GROOVE_DIAMETER);

        // spokes
        n = 8;
        z = REST_HEIGHT + GROOVE_DIAMETER/2;
        for (i=[1:n]) {
            rotate([0, 0, 360/n*i]) {
                translate([-SLIT_THICKNESS/2, INNER_SLIT_RADIUS, z])
                cube([SLIT_THICKNESS, INNER_DIAMETER, INNER_HEIGHT*2]);
            }
        }
        
        // ring
        translate([0, 0, z])
        difference() {
            cylinder(r=INNER_SLIT_RADIUS + SLIT_THICKNESS, h=INNER_HEIGHT*2);
            cylinder(r=INNER_SLIT_RADIUS, h=INNER_HEIGHT*2);
        }
        
        // screw
        n2 = 5;
        z2 = REST_HEIGHT + INNER_HEIGHT - SCREW_LENGTH;
        for (i=[1:n2]) {
            rotate([0, 0, 360/n2*i]) {
                translate([-SCREW_SLIT_TH/2, 0, z2])
                cube([SCREW_SLIT_TH, SCREW_SLIT_D/2, SCREW_LENGTH*2]);
            }
        }
       
    }
 }

%space();
body();

