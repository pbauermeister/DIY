INNER_DIAMETER    =  35;
INNER_HEIGHT      =  35;
WALL_THICKNESS    =   4;
BOTTOM_THICKNESS  =   8;
SCREW_STEP        =   3;
SCREW_CAP_HEIGHT  =  35 + 3;
SCREW_HEAD_HEIGHT =  13;
SCREW_HEAD_WIDTH  =  50;
CHAMFER           =   2;
TURNS             = INNER_HEIGHT / SCREW_STEP;
FN                = $preview? 180/25*2 : 180/2;

K                 = 1.333;

SOAP_W            = 20;
SOAP_L            = 30;
SOAP_BRAND_HEIGHT = .6;
SOAP_R            =  1;
SOAP_MIN_HEIGHT   =  5;

ANGLE_STEP        = 360 / FN;
ANGLE_MAX         = TURNS*360;
PLAY              = 0.35;
$fn               = FN;
ATOM              = 0.01;


function get_bottom_thickness() = BOTTOM_THICKNESS;
function get_screw_head_width() = SCREW_HEAD_WIDTH;
function get_k() = K;

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

module head_0(screw_head_height) {
    screw_head_d = sqrt(5/4) * SCREW_HEAD_WIDTH - CHAMFER;    
    translate([0, 0, -BOTTOM_THICKNESS+CHAMFER])
    minkowski() {
        cylinder(d=screw_head_d, h=screw_head_height - 2*CHAMFER, $fn=6);
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
    head_0(SCREW_HEAD_HEIGHT);
}

module inner_cut(k=1.5) {
    cylinder(d=INNER_DIAMETER, h=INNER_HEIGHT*k, $fn=90);
}

module top_cut() {
    translate([0, 0, INNER_HEIGHT+INNER_DIAMETER])
    cube(INNER_DIAMETER*2, center=true);
}

module bottom_cut() {
    translate([0, 0, -INNER_DIAMETER])
    cube(INNER_DIAMETER*2, center=true);
}


module soap_piston_cavity(soap_r=SOAP_R) {
    hull()
    for (i=[-1, 1]) {
        for (j=[-1, 1]) {
            for (k=[0, 1]) {
                dx = k * SOAP_L/SOAP_L * SOAP_R;
                dy = k * SOAP_W/SOAP_L * SOAP_R;
                
                translate([i*(SOAP_L/2-SOAP_R+dx), j*(SOAP_W/2-SOAP_R+dy), SOAP_R + k*INNER_HEIGHT])
                sphere(r=soap_r);
            }
        }
    }
}

module brand(reverse=true) {
    difference() {
        translate([-SOAP_L/2, -SOAP_W/2, 0])
        cube([SOAP_L, SOAP_W, SOAP_BRAND_HEIGHT]);

        scale([1.1 * (reverse?-1:1), 1.0, 1])
        translate([-SOAP_L/2-ATOM, -SOAP_L/2-ATOM, -1])
        resize([SOAP_L +ATOM*2, SOAP_L+ATOM*2, 3])
        linear_extrude(height=1)
        import("Fight-Club-Movie.dxf");
    }
}

module main() {
    difference() {
        union() {
            screw();
            inner_cut(1);
        }
        soap_piston_cavity();
        top_cut();
    }
    brand();
}

module screw_cut(screw_cap_height) {
    difference() {
        union() {
            screw_0(h=screw_cap_height, extra=PLAY);
            inner_cut();
        }
        bottom_cut();
    }
}

module cap() {
    difference() {
        head_0(SCREW_CAP_HEIGHT);
        //rotate([0, 0, -360/6 * .25]) 
        screw_cut(SCREW_CAP_HEIGHT);

        r = WALL_THICKNESS;
        diameter = INNER_DIAMETER + WALL_THICKNESS*2;
        translate([0, 0, SCREW_CAP_HEIGHT - r + WALL_THICKNESS*.4])
        rotate_extrude(convexity=10)
        translate([diameter/2-r, 0, 0])
        circle(r=r, $fn=100);
    }
}

module soap_piston() {
    difference() {
        translate([0, 0, -SOAP_R + SOAP_BRAND_HEIGHT])
        intersection() {
            translate([-SOAP_L, -SOAP_W, SOAP_R])
            cube([SOAP_L*2, SOAP_W*2, INNER_HEIGHT-SOAP_MIN_HEIGHT]);

            soap_piston_cavity(SOAP_R-PLAY/2);
        }
    
        for (i=[-1, 1])
        hull() {
            translate([SOAP_W*.38*i, 0, INNER_HEIGHT])
            sphere(d=SOAP_W*.65);

            translate([SOAP_W*.38*i, 0, INNER_HEIGHT/2])
            sphere(d=SOAP_W*.65);
        }
    }
    brand(false);
}

function get_piston_height() = INNER_HEIGHT-SOAP_MIN_HEIGHT+SOAP_BRAND_HEIGHT;

//main();
soap_piston();

