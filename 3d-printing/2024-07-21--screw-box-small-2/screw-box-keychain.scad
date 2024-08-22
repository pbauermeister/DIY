INNER_DIAMETER       = 25;
INNER_HEIGHT         =  5.5;
WALL_THICKNESS       =  0.8;
SCREW_CUBE_THICKNESS =  0.8*2;
SCREW_STEP           =  1.5;
SCREW_HEAD_HEIGHT    =  2;
CAP_HEIGHT           =  5.5;
SCREW_HEAD_WIDTH     = 32;
CHAMFER              =  0.75;


TURNS = INNER_HEIGHT / SCREW_STEP;
FN = $preview? 180/6 : 180/2;
ANGLE_STEP = 360 / FN;
ANGLE_MAX = TURNS*360;

PLAY= 0.35;

$fn = FN;

module screw_el(angle, extra=0) {
    z = INNER_HEIGHT / ANGLE_MAX * angle;
    //echo(angle, z);
    translate([0, 0, z])
    rotate([0, 0, angle])
    translate([INNER_DIAMETER/2, 0, 0])
    rotate([0, 45, 0])
    cube(SCREW_CUBE_THICKNESS + extra*2, center=true);
}

module screw_envelope() {
    r = SCREW_CUBE_THICKNESS;
    diameter = INNER_DIAMETER + SCREW_CUBE_THICKNESS*2 -PLAY*2.8;
    translate([0, 0, INNER_HEIGHT - r])
    rotate_extrude(convexity=10)
    translate([diameter/2 - r, 0, 0])
    circle(r=r, $fn=60);
    
    cylinder(d=diameter, h=INNER_HEIGHT - r);
}

module head_0(with_hole) {
    chamfer = $preview ? 0 : CHAMFER;
    screw_head_d = sqrt(5/4)*SCREW_HEAD_WIDTH - chamfer;    
    translate([0, 0, -WALL_THICKNESS+chamfer])
    minkowski() {
        if (!with_hole) {
            //cylinder(d=screw_head_d*1.1, h=SCREW_HEAD_HEIGHT*2 - 2*chamfer, $fn=6);
            cylinder(d=screw_head_d*.9, h=CAP_HEIGHT - 2*chamfer);
        }
        else {
            d = screw_head_d*.5 + 4 -2;
            difference() {
                hull() {
                    cylinder(d=screw_head_d*.9, h=SCREW_HEAD_HEIGHT - 2*chamfer);
                    translate([d, 0, 0])
                    cylinder(d=screw_head_d*.4, h=SCREW_HEAD_HEIGHT - 2*chamfer);
                }
                translate([d, 0, 0])
                cylinder(d=7, h=SCREW_HEAD_HEIGHT);
            }
        }
        if (!$preview)
        sphere(chamfer, $fn=6*2);
    }
}

module screw_0(h=INNER_HEIGHT, extra=0) {
    turns = h / SCREW_STEP;
    angle_max = turns*360;
    for (angle=[-180:ANGLE_STEP:angle_max + 360]) {
        hull() {
            screw_el(angle, extra=extra);
            screw_el(angle + ANGLE_STEP, extra=extra);
        }
    }
    cylinder(d=INNER_DIAMETER, h=INNER_HEIGHT);
}

module screw() {
    intersection() {
        if (!$preview)
            screw_0();
        screw_envelope();
%        screw_envelope();
    }
    head_0(true);
}

module inner_cut() {
    cylinder(d=INNER_DIAMETER -WALL_THICKNESS*2, h=INNER_HEIGHT*1.5, $fn=90);
}

module top_cut() {
    translate([0, 0, INNER_HEIGHT + INNER_DIAMETER])
    cube(INNER_DIAMETER*2, center=true);
}

module bottom_cut() {
    translate([0, 0, -INNER_DIAMETER])
    cube(INNER_DIAMETER*2, center=true);
}


module main() {
    difference() {
        screw();
        inner_cut();
        top_cut();
    }
}

module screw_cut() {
    difference() {
        union() {
            screw_0(h=SCREW_HEAD_HEIGHT, extra=PLAY);
            inner_cut();
        }
        bottom_cut();
    }
}

module cap() {
    r = WALL_THICKNESS;
    diameter = INNER_DIAMETER + WALL_THICKNESS*2;
    difference() {
        union() {
            translate([0, 0, CAP_HEIGHT - SCREW_HEAD_HEIGHT])
            head_0(true);
            head_0();
        }
        rotate([0, 0, 180])
        screw_cut();

        translate([0, 0, SCREW_HEAD_HEIGHT-r + WALL_THICKNESS*.4])
        rotate_extrude(convexity=10)
        translate([diameter/2 - r, 0, 0])
        circle(r=r, $fn=60);

        translate([0, 0, CAP_HEIGHT-r])
        rotate_extrude(convexity=10)
        translate([diameter/2 - r, 0, 0])
        circle(r=r*2, $fn=60);

    }
}

scale([1, 1, 1.2])
//translate([0, 0, CAP_HEIGHT+.8]) rotate([180, 0, 0])
translate([0, 0, WALL_THICKNESS])
main();


scale([1, 1, 1.2])
//translate([0, 0, CAP_HEIGHT]) rotate([180, 0, 0])
translate([SCREW_HEAD_WIDTH*1.75, 0, 0])
translate([0, 0, CAP_HEIGHT - SCREW_HEAD_HEIGHT + 1.2])
rotate([180, 0, 0])
cap();

//%translate([0, 0, INNER_HEIGHT]) rotate([180, 0, 0]) cap();
