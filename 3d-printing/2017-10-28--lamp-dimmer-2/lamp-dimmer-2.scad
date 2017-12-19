// Resolution: Medium
// Fill: 50%


INNER_DIAMETER = 32;
LED_DIAMETER = 20;
HEIGHT = 5;
WALL_THICKNESS = 0.6;
LEVER_THICKNESS = 1.5;

N = 6;

$fn = 90;
PLAY = 0.4;
TOLERANCE = 0.17;
ATOM = 0.001;

module barrel(outer_radius, inner_radius, height) {
    scale([1, 1, height])
    difference() {
        cylinder(r=outer_radius);
        translate([0, 0, -0.5]) scale([1, 1, 2])
        cylinder(r=inner_radius);
    }
}

module wheel(recess) {
    difference() {
        cylinder(d=INNER_DIAMETER-recess*2, h=HEIGHT);

        translate([0, 0, -ATOM/2])
        {
            D2 = LED_DIAMETER/2;
            for (a=[0:N-1])
                rotate([0, 0, (a+N/3) * 360/N])
                translate([LED_DIAMETER/3-WALL_THICKNESS/2, 0, 0])
                cylinder(d=D2/3, h=HEIGHT+ATOM);
            cylinder(d=LED_DIAMETER/3-WALL_THICKNESS*2, h=HEIGHT+ATOM);
        }
    }
}

module lever(w, l, thickness, recess) {
    d = sqrt(pow(l, 2) - pow(w/2, 2));
    echo(d);
    translate([d - recess, -w/2, 0])
    cube([l, w, thickness]);
}

translate([0, INNER_DIAMETER*2, 0]) {
    wheel(PLAY);
    lever(INNER_DIAMETER/4, INNER_DIAMETER/2, LEVER_THICKNESS, PLAY);
}

translate([INNER_DIAMETER*2, INNER_DIAMETER*2, 0])
wheel(TOLERANCE/2);

H = HEIGHT*3;
H2 = HEIGHT + LEVER_THICKNESS + PLAY;
difference() {
    barrel(INNER_DIAMETER/2 + WALL_THICKNESS *2, INNER_DIAMETER/2, H);
    translate([0, 0, H-H2+ATOM]) {
        lever(INNER_DIAMETER/4, INNER_DIAMETER/2, H2, PLAY);
        rotate([0, 0, 360/(N*2)])
        lever(INNER_DIAMETER/4, INNER_DIAMETER/2, H2, PLAY);
        rotate([0, 0, 360/(N*4)])
        lever(INNER_DIAMETER/4, INNER_DIAMETER/2, H2, PLAY);
    }
}

