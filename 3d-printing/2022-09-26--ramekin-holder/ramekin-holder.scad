INNER_DIAMETER = 95;
CUTOUT_DIAMETER = INNER_DIAMETER / 1.75;
WALL_THICKNESS = 3;
WALL_THICKNESS_2 = .75*2;

HEIGHT = 110;
PLAY = 1;
ATOM = 0.01;

$fn = 120;

module block() {
    hull() {
        if (0)
            cylinder(d=INNER_DIAMETER + WALL_THICKNESS*2, h=HEIGHT + WALL_THICKNESS);
        else {
            d = INNER_DIAMETER + WALL_THICKNESS*2;
            translate([-d/2, -d/2, 0]) cube([d, d, HEIGHT+WALL_THICKNESS]);
        }

        if (0)
            translate([0, INNER_DIAMETER/2 + INNER_DIAMETER/2, 0])
            cylinder(d=INNER_DIAMETER+WALL_THICKNESS*2, h=HEIGHT+WALL_THICKNESS);
        else {
            d = INNER_DIAMETER + WALL_THICKNESS*2;
            translate([0, INNER_DIAMETER/2 + INNER_DIAMETER/2, 0])
            translate([-d/2, -d/2, 0]) cube([d, d, HEIGHT+WALL_THICKNESS]);
        }
    }
}

module inner_hole() {
    translate([0, 0, WALL_THICKNESS])
    hull() {
        cylinder(d=INNER_DIAMETER, h=HEIGHT + WALL_THICKNESS);

        translate([0, INNER_DIAMETER, 0])
        cylinder(d=INNER_DIAMETER, h=HEIGHT+WALL_THICKNESS);
    }

    translate([0, 0, WALL_THICKNESS_2])
    {
        cylinder(d1=INNER_DIAMETER-WALL_THICKNESS*2, d2=INNER_DIAMETER, h=WALL_THICKNESS);

        translate([0, INNER_DIAMETER, 0])
        cylinder(d1=INNER_DIAMETER-WALL_THICKNESS*2, d2=INNER_DIAMETER, h=WALL_THICKNESS);
    }


    translate([0, 0, -ATOM])
    {
        cylinder(d=INNER_DIAMETER*.6, h=WALL_THICKNESS);

        translate([0, INNER_DIAMETER, 0])
        cylinder(d=INNER_DIAMETER*.6, h=WALL_THICKNESS);
    }
}

module cutout(factor=1) {
    d = CUTOUT_DIAMETER*factor;
    h = INNER_DIAMETER*2+INNER_DIAMETER*2;
    intersection() {
        difference() {
            children();
            hull() {
                if(0) translate([0, -INNER_DIAMETER, HEIGHT+d])
                rotate([-90, 0, 0])
                cylinder(d=d, h=h);

                translate([0, -INNER_DIAMETER, d/2 + WALL_THICKNESS*3 + 1])
                rotate([-90, 0, 0])
                cylinder(d=d, h=h);
            }
        }

if(0)
        union() {
            cylinder(d=INNER_DIAMETER*4, h=HEIGHT-CUTOUT_DIAMETER/2*.75);
            d2 = d / 1.5;

            hull() {
                translate([d/2+d2*2, -INNER_DIAMETER, HEIGHT+WALL_THICKNESS-d2/2]) rotate([-90, 0, 0]) cylinder(d=d2, h=h);
                translate([d       , -INNER_DIAMETER, HEIGHT+WALL_THICKNESS-d2/2]) rotate([-90, 0, 0]) cylinder(d=d2, h=h);
                translate([d/2+d2/2, -INNER_DIAMETER, 0]) rotate([-90, 0, 0]) cylinder(d=d2, h=h);
            }

            hull() {
                translate([-d/2-d2*2, -INNER_DIAMETER, HEIGHT+WALL_THICKNESS-d2/2]) rotate([-90, 0, 0]) cylinder(d=d2, h=h);
                translate([-d       , -INNER_DIAMETER, HEIGHT+WALL_THICKNESS-d2/2]) rotate([-90, 0, 0]) cylinder(d=d2, h=h);
                translate([-d/2-d2/2, -INNER_DIAMETER, 0]) rotate([-90, 0, 0]) cylinder(d=d2, h=h);
            }
        }
    }
}

module all() {
    cutout(factor=1.75)
    translate([INNER_DIAMETER/2, 0, 0])
    rotate([0, 0, 90])
    difference() {
        cutout() {
            difference() {
                block();
                inner_hole();
            }
        }
    }
}

rotate([0, 90, 0])
intersection() {
    all();
    
    d = INNER_DIAMETER*.9;
    translate([0, 0, d/2])
    cube(d*2, center=true);
    //cube(INNER_DIAMETER*4);
}