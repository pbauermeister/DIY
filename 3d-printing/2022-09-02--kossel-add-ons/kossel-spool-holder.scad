SHAFT_DIAMETER = 4.2;
SHAFT_LENGTH = 100;
BEARING_INNER_DIAMETER = 8;
BEARING_OUTER_DIAMETER = 22;
BEARING_THICKNESS = 7;
MARGIN = 2.5;
PLAY = .17 * 4;
TOLERANCE = .17;
ATOM = .01;

BARREL_DIAMETER = 35;
BARREL_DIAMETER2 = 45;

$fn = $preview ? 30 : 60;


module balls(r, d) {
    for (a=[0,120,240])
        rotate([0, 0, a]) translate([d/2, 0, 0]) scale([.5, 1, 1]) sphere(r=r);
}

module bearing() {
    cylinder(d=BEARING_OUTER_DIAMETER, h=BEARING_THICKNESS);
}

module axis() {
    difference() {
        union() {
            cylinder(d=BEARING_INNER_DIAMETER, h=SHAFT_LENGTH);

            translate([0, 0, MARGIN*0 + BEARING_THICKNESS +TOLERANCE])
            cylinder(d=BEARING_INNER_DIAMETER + MARGIN*2, h=SHAFT_LENGTH-BEARING_THICKNESS*2-MARGIN*0 -TOLERANCE*2);
        }

        translate([0, 0, -ATOM])
        cylinder(d=SHAFT_DIAMETER+TOLERANCE, h=SHAFT_LENGTH+ATOM*2);
        
        if (0) {
            translate([0, 0, BEARING_THICKNESS*2])
            cylinder(d=SHAFT_DIAMETER+PLAY*2, h=SHAFT_LENGTH-BEARING_THICKNESS*4);
        }
        else hull() {
            translate([0, 0, BEARING_THICKNESS+MARGIN+SHAFT_DIAMETER/2])
            sphere(d=SHAFT_DIAMETER+PLAY*2, $fn=12);
            translate([0, 0, SHAFT_LENGTH-(BEARING_THICKNESS+MARGIN+SHAFT_DIAMETER/2)])
            sphere(d=SHAFT_DIAMETER+PLAY*2, $fn=12);
        }

        if ($preview) translate([0, 0, -ATOM]) cube(SHAFT_LENGTH*2);
    }
    %translate([0, 0, MARGIN*0]) bearing();
    %translate([0, 0, SHAFT_LENGTH - BEARING_THICKNESS - MARGIN*0]) bearing();
    
    translate([0, 0, MARGIN-TOLERANCE])
    balls(TOLERANCE*2, BEARING_INNER_DIAMETER-TOLERANCE);

    translate([0, 0, SHAFT_LENGTH-MARGIN+TOLERANCE])
    balls(TOLERANCE*2, BEARING_INNER_DIAMETER-TOLERANCE);
}

module barrel() {
    difference() {
        union() {
            cylinder(d=BARREL_DIAMETER, h=SHAFT_LENGTH);

            translate([0, 0, MARGIN])
            cylinder(d1=BARREL_DIAMETER2, d2=BARREL_DIAMETER, h=MARGIN/2);
            cylinder(d=BARREL_DIAMETER2, h=MARGIN);

            translate([0, 0, SHAFT_LENGTH-MARGIN*1.5])
            cylinder(d2=BARREL_DIAMETER2, d1=BARREL_DIAMETER, h=MARGIN/2);
            translate([0, 0, SHAFT_LENGTH-MARGIN])
            cylinder(d=BARREL_DIAMETER2, h=MARGIN);

        }
        translate([0, 0, -ATOM])
        cylinder(d=BEARING_OUTER_DIAMETER+TOLERANCE, h=BEARING_THICKNESS+MARGIN);

        translate([0, 0, SHAFT_LENGTH-BEARING_THICKNESS-MARGIN])
        cylinder(d=BEARING_OUTER_DIAMETER+TOLERANCE, h=BEARING_THICKNESS+MARGIN+ATOM);

        cylinder(d=BEARING_OUTER_DIAMETER-MARGIN*2, h=SHAFT_LENGTH);
        if ($preview) translate([0, 0, -ATOM]) cube(SHAFT_LENGTH*2);
    }

    %translate([0, 0, MARGIN*0]) bearing();
    %translate([0, 0, SHAFT_LENGTH - BEARING_THICKNESS - MARGIN*0]) bearing();

    translate([0, 0, MARGIN-TOLERANCE])
    balls(TOLERANCE*2, BEARING_OUTER_DIAMETER+TOLERANCE);

    translate([0, 0, SHAFT_LENGTH-MARGIN+TOLERANCE])
    balls(TOLERANCE*2, BEARING_OUTER_DIAMETER+TOLERANCE);
}

translate([0, $preview ? 0 : BARREL_DIAMETER2, 0]) axis();

//barrel();