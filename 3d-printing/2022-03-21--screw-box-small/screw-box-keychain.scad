INNER_DIAMETER = 25;
INNER_HEIGHT = 5.5;
WALL_THICKNESS = .8;
SCREW_CUBE_THICKNESS = .8*2;
SCREW_STEP = 1.5;
SCREW_HEAD_HEIGHT = 3;
SCREW_HEAD_WIDTH = 32;
CHAMFER = 0.5;


TURNS = INNER_HEIGHT / SCREW_STEP;
FN = $preview? 180/30 : 180/2;
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
    diameter = INNER_DIAMETER + SCREW_CUBE_THICKNESS*2;
    translate([0, 0, INNER_HEIGHT - r])
    rotate_extrude(convexity=10)
    translate([diameter/2 - r, 0, 0])
    circle(r=r, $fn=100);
    
    cylinder(d=diameter, h=INNER_HEIGHT - r);
}

module head_0(with_hole) {
    screw_head_d = sqrt(5/4)*SCREW_HEAD_WIDTH - CHAMFER;    
    translate([0, 0, -WALL_THICKNESS+CHAMFER])
    minkowski() {
        if (!with_hole) {
            cylinder(d=screw_head_d, h=SCREW_HEAD_HEIGHT - 2*CHAMFER, $fn=6);
        }
        else {
            difference() {
                hull() {
                    cylinder(d=screw_head_d*.9, h=SCREW_HEAD_HEIGHT - 2*CHAMFER);
                    translate([screw_head_d*.5 + 4, 0, 0])
                    cylinder(d=screw_head_d*.4, h=SCREW_HEAD_HEIGHT - 2*CHAMFER);
                }
                translate([screw_head_d*.5 + 4, 0, 0])
                cylinder(d=7, h=SCREW_HEAD_HEIGHT);
            }
        }
        sphere(CHAMFER, $fn=6*2);
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
        screw_0();
        screw_envelope();
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
    difference() {
        head_0(false);
        screw_cut();

        r = WALL_THICKNESS;
        diameter = INNER_DIAMETER + WALL_THICKNESS*2;
        translate([0, 0, SCREW_HEAD_HEIGHT-r + WALL_THICKNESS*.4])
        rotate_extrude(convexity=10)
        translate([diameter/2 - r, 0, 0])
        circle(r=r, $fn=100);
    }
}

main();

translate([SCREW_HEAD_WIDTH*1.75, 0, 0]) cap();