/****************************************************\
Mid Century modern table
(C) P. Bauermeister, 2018-06-21.
\****************************************************/


BODY_LENGTH = 1200;
BODY_WIDTH = 400;
BODY_HEIGHT = 120;
BODY_BOTTOM_RECESS = 10*1.5;
PLANK_THICKNESS = 20;

LEG_HEIGHT = 860;
LEG_PIN_DIAMETER = 8;
LEG_PIN_DISPLACEMENT = 60;
LEG_PIN_SPACING = 50;
LEG_PLATE_MARGIN = 20;
LEG_PLATE_THICKNESS = 5;

BACK_THICKNESS = 10;
BACK_HOLE_DIAMETER = 50;
BACK_HOLE_NB = 10 *0;

inner_height = BODY_HEIGHT-PLANK_THICKNESS*2;
echo("recess=", BODY_BOTTOM_RECESS);
angle = atan(BODY_BOTTOM_RECESS/BODY_HEIGHT);
echo("angle=", angle);
sl = inner_height / cos(angle);
echo("side_length=", sl);

module BodyFaceTrapeze() {
    translate([-BODY_LENGTH/2, 0, 0])
    polygon(points=[
        [0, BODY_HEIGHT],
        [BODY_LENGTH, BODY_HEIGHT],
        [BODY_LENGTH-BODY_BOTTOM_RECESS, 0],
        [BODY_BOTTOM_RECESS, 0]
    ]);
}

module Back() {
    rotate([90, 0, 0])
    linear_extrude(height=BACK_THICKNESS)
    difference() {
        offset(r=-PLANK_THICKNESS) BodyFaceTrapeze();
        if (BACK_HOLE_NB)
        for (i=[0:BACK_HOLE_NB-1]) {
            d = BODY_LENGTH/(BACK_HOLE_NB+0.5);
            x = (i-BACK_HOLE_NB/2+.5) * d;
            translate([x, BODY_HEIGHT/2, 0])
            circle(d=BACK_HOLE_DIAMETER);
            
            }
    }
}

module Body() {
    translate([0, BODY_WIDTH/2, 0])
    rotate([90, 0, 0])
    linear_extrude(height=BODY_WIDTH)
    difference() {
        BodyFaceTrapeze(false);
        offset(r=-PLANK_THICKNESS) BodyFaceTrapeze(false);
    }
}

module Leg() {
    d1 = LEG_PIN_DISPLACEMENT+LEG_PIN_SPACING;
    d2 = LEG_PIN_DISPLACEMENT;
    alpha = atan((d1)/LEG_HEIGHT);
    beta = atan((LEG_PIN_DISPLACEMENT)/LEG_HEIGHT);
    l1 = sqrt(LEG_HEIGHT*LEG_HEIGHT + d1*d1 *2);
    l2 = sqrt(LEG_HEIGHT*LEG_HEIGHT + d2*d2 *2);

    union() {
        rotate([-beta, alpha, 0])
        cylinder(h=l1, d=LEG_PIN_DIAMETER);

        rotate([-beta, beta, 0])
        cylinder(h=l2, d=LEG_PIN_DIAMETER);

        rotate([-alpha, beta, 0])
        cylinder(h=l1, d=LEG_PIN_DIAMETER);
    }
    
    c = LEG_PIN_SPACING + LEG_PLATE_MARGIN * 2;
    d = LEG_PIN_DISPLACEMENT+LEG_PIN_SPACING/2-c/2;
    translate([d, d, LEG_HEIGHT-LEG_PLATE_THICKNESS])
    difference() {
        cube([c, c, LEG_PLATE_THICKNESS]);
        //translate([c/2, c/2, 0]) cube([c, c, LEG_PLATE_THICKNESS]);
    }
}

module Stereo() {
    l = 440; w= 250; h= 130;
    color("Maroon")
    translate([0, -w, 0])
    cube([l, w, h]);
    
    color("black") {
        d=100; o = 15;
        translate([d/2+o, -w, d/2 + (h-d)/2])
        rotate([90, 0, 0]) cylinder(d=d);
        translate([l-(d/2+o), -w, d/2 + (h-d)/2])
        rotate([90, 0, 0]) cylinder(d=d);

        ll = 130; hh = 25;
        translate([l/2-ll/2, -w-1, h-hh-20])
        cube([ll, 1, hh]);

        d3 = 30;
        translate([l/2, -w, d3/2+20])
        rotate([90, 0, 0]) cylinder(d=d3, h=20);

    }

}


translate([0, 0, LEG_HEIGHT])
color("peru")
color("chocolate")
color("sienna")
Body();

translate([0, BODY_WIDTH/2 - PLANK_THICKNESS, LEG_HEIGHT])
color("chocolate")
Back();

translate([-BODY_LENGTH/2, -BODY_WIDTH/2, 0])
color("white")
Leg();

translate([BODY_LENGTH/2, -BODY_WIDTH/2, 0])
rotate([0, 0, 90])
color("white")
Leg();

translate([BODY_LENGTH/2, BODY_WIDTH/2, 0])
rotate([0, 0, 180])
color("white")
Leg();

translate([-BODY_LENGTH/2, BODY_WIDTH/2, 0])
rotate([0, 0, -90])
color("white")
Leg();

translate([-BODY_LENGTH/2, BODY_WIDTH/2, LEG_HEIGHT+BODY_HEIGHT+1])
Stereo();

%cube([2000, 2000, 1], true);