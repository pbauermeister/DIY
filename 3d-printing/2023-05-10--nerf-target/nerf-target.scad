DIAMETER_OUTER  = 200 - 30;
DIAMETER_MEDIUM = 100;
DIAMETER_INNER  =  40;

HOLLOWING       =   2.5;
HOLLOWING_WALL  =   2.4;
HOLLOWING_STEP1 =   1.5*5;
HOLLOWING_STEP2 =   1.3;
HOLLOWING_WALL2 =   0.2;

THICKNESS       =   4.0;
GAP             =   1;
CARVE           =   0.7;
CARVE_TEXT      =   THICKNESS-HOLLOWING + .1;

CONTACT_SIZE    =  10;
TOLERANCE       =   1;
TRAVEL          =   5;
ATOM            =   .05;
$fn = 90;

module cross(d1) {
        translate([-d1, -GAP/4, THICKNESS-CARVE])
        cube([d1*2, GAP/2, THICKNESS]);

        rotate([0, 0, 90])
        translate([-d1, -GAP/4, THICKNESS-CARVE])
        cube([d1*2, GAP/2, THICKNESS]);
}

module torus(d1, d2, h=THICKNESS) {
    difference() {
        cylinder(d=d1, h=h);
        if (d2) cylinder(d=d2 + GAP*2, h=h*4, center=true);
    }
}

module numbers(d1, d2, value, size) {
    r1 = d1 / 2;
    r2 = d2 / 2;
    d = d2==0 ? 0 : (d1 + (d2-d1)/2) / sqrt(2) / 2;
    positions = d2==0 ? [[0, 0]] : [[d, d], [-d, d], [-d, -d], [d, -d]];
    for (pos=positions) {
        translate([pos[0], pos[1], THICKNESS-CARVE_TEXT])
        linear_extrude(10)
        text(value, font="helvetica:style=bold", size=size,
             valign="center", halign="center", $fn=30);
    }
}

module hollowing(d1, d2) {
    rotate([0, 0, 45])
    translate([0, 0, -THICKNESS+HOLLOWING])
    difference() {
        torus(d1-HOLLOWING_WALL, d2 ? d2+HOLLOWING_WALL : 0);
        steps1 = floor(d1/2 / HOLLOWING_STEP1);
        for (i=[-steps1:steps1]) {
            translate([0, i*HOLLOWING_STEP1, 0])
            cube([d1, HOLLOWING_WALL2, THICKNESS*3], true);
        }

        steps2 = floor(d1/2 / HOLLOWING_STEP2);
        for (i=[-steps2:steps2]) {
            translate([i*HOLLOWING_STEP2, 0, 0])
            cube([HOLLOWING_WALL2, d1, THICKNESS*3], true);
        }

    }
}

module disc(d1, d2, carve, value, size) {
    difference() {
        torus(d1, d2);

        if (carve) cross(d1);
        numbers(d1, d2, value, size);
        hollowing(d1, d2);
    }
}


module plates() {
    disc(DIAMETER_OUTER, DIAMETER_MEDIUM, true, "10", 15);

    disc(DIAMETER_MEDIUM, DIAMETER_INNER, true, "20", 15);

    disc(DIAMETER_INNER, 0, false, "50", 15);
}

plates();

module central_target_body() {
    thickness = (THICKNESS+TRAVEL+THICKNESS/2) * 2;
    h = DIAMETER_INNER*1.5;
    offset_y = thickness/2-THICKNESS;
    width = DIAMETER_INNER *.75;

    difference() {
        union() {
            translate([0, thickness-THICKNESS, 0])
            rotate([90, 0, 0])
            torus(DIAMETER_INNER, 0, h=thickness);

            translate([0, offset_y, 0])
            difference() {
                translate([-width/2, -THICKNESS/2, 0])
                cube([width, THICKNESS, h+THICKNESS/2]);
                
                translate([0, 0, h])
                rotate([0, 90, 0])
                cylinder(d=THICKNESS/2, h=DIAMETER_INNER, center=true);
            }
        }

        translate([0, thickness-THICKNESS-HOLLOWING_WALL, 0])
        rotate([90, 0, 0])
        torus(DIAMETER_INNER-HOLLOWING_WALL*2, 0, h=thickness);
        
        translate([0, offset_y, 0])
        cylinder(d=THICKNESS*2, h=DIAMETER_INNER/2+THICKNESS);
    }
}

module central_target_holder() {
    thickness = (THICKNESS+TRAVEL+THICKNESS/2) * 2;
    h = DIAMETER_INNER*1.5;
    offset_y = thickness/2-THICKNESS;
    width = DIAMETER_INNER *.75;

    translate([0, offset_y, 0])
    difference() {
        translate([-DIAMETER_INNER/2, -THICKNESS/2, h-THICKNESS])
        cube([DIAMETER_INNER, THICKNESS/2+thickness/2+TRAVEL, THICKNESS*4]);

        w = width + TOLERANCE;
        translate([-w/2, -THICKNESS, h-THICKNESS*2])
        cube([w, thickness*2, THICKNESS*3]);

        translate([0, 0, h])
        rotate([0, 90, 0])
        cylinder(d=THICKNESS/2, h=DIAMETER_INNER*2, center=true);
    }

    translate([0, thickness-THICKNESS + TRAVEL, 0]) {
        translate([-DIAMETER_INNER/2, 0, 0])
        cube([DIAMETER_INNER, THICKNESS, h+THICKNESS*3]);

        rotate([-90, 0, 0])
        cylinder(d=CONTACT_SIZE, h=THICKNESS);
    }
}


module mid_target_body() {
    rotate([90, 0, 0])
    torus(DIAMETER_MEDIUM, DIAMETER_INNER, h=THICKNESS);
}

module ext_target_body() {
    rotate([90, 0, 0])
    torus(DIAMETER_OUTER, DIAMETER_MEDIUM, h=THICKNESS);
}

/*
color("red") translate([0, ATOM, 0]) central_target_body();
color("orange") central_target_holder();
mid_target_body();
ext_target_body();
*/