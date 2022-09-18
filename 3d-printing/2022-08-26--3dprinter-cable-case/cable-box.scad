
INNER_WIDTH = 14.5;
INNER_HEIGHT = 14.5;
INNER_LENGTH = 65;
OUTER_LENGTH = 80;
THICKNESS = 2;
EXTEND = 16;
DIAMETER_1 = 8;
DIAMETER_2 = 4.5;
MARGIN= 0.17;

$fn = $preview ? 12 : 60;


module box0() {
    cube([INNER_WIDTH, INNER_LENGTH, INNER_HEIGHT]);

    d = INNER_WIDTH;
    translate([INNER_WIDTH/2, 0, INNER_HEIGHT/2])
    rotate([90, 0, 0])
    cylinder(d1=d, d2=DIAMETER_1+1, h=EXTEND);

    translate([INNER_WIDTH/2, INNER_LENGTH, INNER_HEIGHT/2])
    rotate([-90, 0, 0])
    cylinder(d1=d, d2=d, h=EXTEND);
}

module ring(inner_r, l) {
    translate([INNER_WIDTH/2, 0, INNER_HEIGHT/2])
    rotate([90, 0, 0]) difference() {
        cylinder(r=inner_r*2, h=l);
        cylinder(r=inner_r, h=l*2);
    }
}

module box() {
    difference() {
        minkowski() {
            box0();
            sphere(r=THICKNESS);
        }

        cube ([INNER_WIDTH, INNER_LENGTH, INNER_HEIGHT]);

        d = INNER_WIDTH;

        translate([INNER_WIDTH/2, EXTEND/2, INNER_HEIGHT/2])
        rotate([90, 0, 0])
        cylinder(d=DIAMETER_1, h=EXTEND*2);

        translate([INNER_WIDTH/2, INNER_LENGTH-EXTEND/2, INNER_HEIGHT/2])
        rotate([-90, 0, 0])
        cylinder(d=DIAMETER_2, h=EXTEND*2);

        translate([INNER_WIDTH/2, INNER_LENGTH+EXTEND+THICKNESS-DIAMETER_2, INNER_HEIGHT/2])
        rotate([-90, 0, 0])
        cylinder(d1=DIAMETER_2, d2=DIAMETER_2*3, h=DIAMETER_2);


        translate([0, -THICKNESS-1, 0])
        ring(INNER_HEIGHT - THICKNESS*4, 5);

        translate([0, INNER_LENGTH+THICKNESS*1 + 5 +1, 0])
        ring(INNER_HEIGHT - THICKNESS*4, 5);
    }
}

module top_half(margin=0) {
    tab = THICKNESS/2 - margin;
    difference() {
        box();
        translate([-INNER_WIDTH, -INNER_LENGTH, INNER_WIDTH/2])
        cube([INNER_WIDTH*3, INNER_LENGTH*3, INNER_HEIGHT]);
        
        translate([-tab, -tab, INNER_WIDTH/2 - tab])
        cube([INNER_WIDTH + tab*2, INNER_LENGTH + tab*2, INNER_HEIGHT]);
        
    }
}


module bottom_half() {
    translate([INNER_WIDTH, 0, INNER_HEIGHT])
    rotate([0, 180, 0])
    difference() {
        box();
        top_half(margin=MARGIN);
    }
}

top_half();

translate([INNER_WIDTH + THICKNESS + 3, 0, 0])
bottom_half();
