INNER_DIAMETER = 40;
INNER_HEIGHT = 143;
WALL_THICKNESS = 4;
SCREW_STEP = 3;
SCREW_HEAD_HEIGHT=15;
SCREW_HEAD_WIDTH = 50;
CHAMFER=2;
TURNS = INNER_HEIGHT / SCREW_STEP;
FN = $preview? 180/25 : 180/2;
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
    cube(WALL_THICKNESS + extra*2, center=true);
}

module screw_envelope() {
    r = WALL_THICKNESS;
    diameter = INNER_DIAMETER + WALL_THICKNESS*2;
    translate([0, 0, INNER_HEIGHT-r])
    rotate_extrude(convexity=10)
    translate([diameter/2-r, 0, 0])
    circle(r=r, $fn=100);
    
    cylinder(d=diameter, h=INNER_HEIGHT-r);
}

module head_0() {
    screw_head_d = sqrt(5/4) * SCREW_HEAD_WIDTH - CHAMFER;    
    translate([0, 0, -WALL_THICKNESS+CHAMFER])
    minkowski() {
        cylinder(d=screw_head_d, h=SCREW_HEAD_HEIGHT-2*CHAMFER, $fn=6);
        sphere(CHAMFER, $fn=6*2);
    }
}

module screw_0(h=INNER_HEIGHT, extra=0) {
    turns = h / SCREW_STEP;
    angle_max = turns*360;
    for (angle=[-180:ANGLE_STEP:angle_max+360]) {
        hull() {
            screw_el(angle, extra=extra);
            screw_el(angle+ANGLE_STEP, extra=extra);
        }
    }
}

module screw() {
    intersection() {
        screw_0();
        screw_envelope();
    }
    head_0();
}

module inner_cut() {
    cylinder(d=INNER_DIAMETER, h=INNER_HEIGHT*1.5, $fn=90);
}

module top_cut() {
    translate([0, 0, INNER_HEIGHT+INNER_DIAMETER])
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
        head_0();
        //rotate([0, 0, -360/6 * .25]) 
        screw_cut();

        r = WALL_THICKNESS;
        diameter = INNER_DIAMETER + WALL_THICKNESS*2;
        translate([0, 0, SCREW_HEAD_HEIGHT-r + WALL_THICKNESS*.4])
        rotate_extrude(convexity=10)
        translate([diameter/2-r, 0, 0])
        circle(r=r, $fn=100);
    }
}
