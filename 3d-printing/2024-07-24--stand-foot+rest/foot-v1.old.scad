
WIDTH = /*             */ 100;
LENGTH = /*            */ 103;
HEIGHT = /*              */ 5;

FRONT_SLIT = /*         */ 6;
BACK_SLIT = /*          */ 21.3;

TENON_HEIGHT = /*        */ 2;


$fn = $preview ? 60 : 160;
ATOM = 0.01;
PLAY = .35;

module cylinder0(factor = 0, height = 0, l = LENGTH, w = WIDTH) {
    h = factor ? HEIGHT * factor : height;
    resize([ w, l, h ]) cylinder(d = 10, h = 1);
}

module channel() {
    hull() {
    for (i = [ -1, 1 ]) {
        translate([ 0, i * LENGTH, -FRONT_SLIT * .2 ])
        rotate([ 90, 0, 0 ])
        scale([ 1, 1.7, 1 ]) cylinder(d = FRONT_SLIT * 1.25, h = ATOM);
    }
    }
}

module base() {
    cylinder0(factor = 1);

    intersection() {
        h = HEIGHT / 3 + TENON_HEIGHT;
        translate([ 0, 0, HEIGHT * .75 ])
        hull() {
%            translate([ 0, -LENGTH / 2, h / 2 ])
            cube([ FRONT_SLIT, LENGTH, h ], center = true);

 %           translate([ 0, LENGTH / 2, h / 2 ])
            cube([ BACK_SLIT, LENGTH, h ], center = true);
        }
        cylinder0(factor = 2);
    }
}

module concrete() {
    translate([ 0, 0, HEIGHT ])
    difference() {
        cylinder0(height = 96);

        // slanted top
        translate([ 0, LENGTH / 2, 96 ])
        rotate([ 38, 0, 0 ])
        translate([ 0, -LENGTH / 2, 0 ])
        cylinder(d = LENGTH * 4, h = 100);
    }
}

module stand_holder() {
    difference() {
        base();
        channel();
    }
}

%concrete();
stand_holder();
