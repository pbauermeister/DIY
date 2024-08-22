

MARGIN = /*              */ 4;
WIDTH = /*              */ 99 - MARGIN * 0;
LENGTH = /*            */ 102 - MARGIN * 0;
HEIGHT = /*             */ 15;

FRONT_SLIT = /*         */ 12 - 1;
BACK_SLIT = /*          */ 15 - 1;

TENON_HEIGHT = /*        */ 2;

ARM_HEIGHT_MARGIN = 10;
ARM_HEIGHT = 95 + HEIGHT + ARM_HEIGHT_MARGIN + 26.5;

ARM_THICKNESS = 20;
ARM_WIDTH = 30;

DIAL_DIAMETER = 60 + ARM_THICKNESS / 4;
DIAL_WIDTH = 60;
DIAL_POS_Y = LENGTH / 2 + ARM_THICKNESS / 4;
DIAL_POS_Z = ARM_HEIGHT - ARM_HEIGHT_MARGIN;
DIAL_PIN_DIAMETER = 1;

$fn = $preview ? 30 : 160;
ATOM = 0.01;
PLAY = .35;

module cylinder0(factor = 0, height = 0, l = LENGTH, w = WIDTH, margin = 0) {
    h = factor ? HEIGHT * factor : height;
    resize([ w - margin, l - margin, h ]) cylinder(d = 10, h = 1);
}

module channel() {
    excess = 10;
    if (0) {
        translate([ 0, 0, -HEIGHT / 2 + HEIGHT * .75 ])
        hull() {
            translate([ 0, -LENGTH / 2 - excess, 0 ])
            cube([ FRONT_SLIT, ATOM, HEIGHT ], center = true);

            translate([ 0, LENGTH / 2 + excess, 0 ])
            cube([ BACK_SLIT, ATOM, HEIGHT ], center = true);
        }            
    } else {
        hull() {
            for (i = [ -1, 1 ]) {
                translate([ 0, i * LENGTH, -FRONT_SLIT * .2 ])
                rotate([ 90, 0, 0 ])
                scale([ 1, 1.7, 1 ]) cylinder(d = FRONT_SLIT * 1.25, h = ATOM);
            }
        }
    }
}

module base() {
    cylinder0(factor = 1, margin = MARGIN);

    intersection() {
        h = HEIGHT / 3 + TENON_HEIGHT;
        translate([ 0, 0, HEIGHT * .75 ])
        hull() {
            translate([ 0, -LENGTH / 2, h / 2 ])
            cube([ FRONT_SLIT, ATOM, h ], center = true);

            translate([ 0, LENGTH / 2, h / 2 ])
            cube([ BACK_SLIT, ATOM, h ], center = true);
        }
        union() {
            translate([ 0, LENGTH / 2, 0 ])
            cylinder0(factor = 2, margin = MARGIN);
            cylinder0(factor = 2, margin = MARGIN);
        }
    }
}

module arm(play = 0) {
    difference() {
        union() {
            h = ARM_HEIGHT - ARM_HEIGHT_MARGIN;
            translate([ 0, LENGTH / 2, h / 2 ])
            cube([ ARM_WIDTH + play, ARM_THICKNESS, h ], center = true);

            translate([ 0, LENGTH / 2 + ARM_THICKNESS / 4, ARM_HEIGHT - ARM_HEIGHT_MARGIN ])
            resize([ ARM_WIDTH + play, ARM_THICKNESS / 2, ARM_THICKNESS ]) rotate([ 0, 90, 0 ])
            cylinder(d = ARM_THICKNESS, h = ARM_WIDTH + play, center = true);
        }

        translate([ 0, 0, HEIGHT ])
        cylinder0(factor = 20);
        channel();

        // pin
        if (!play) {
            translate([ 0, DIAL_POS_Y, DIAL_POS_Z ])
            rotate([ 0, 90, 0 ])
            cylinder(d = DIAL_PIN_DIAMETER, h = DIAL_WIDTH * 2, center = true);
        }
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

module dial() {
    chamfer = 2;
    difference() {
        translate([ 0, +DIAL_DIAMETER / 2 - ARM_THICKNESS / 3, 0 ])

        minkowski() {
            difference() {
                rotate([ 0, 90, 0 ])
                cylinder(d = DIAL_DIAMETER, h = DIAL_WIDTH, center = true);

                rotate([ 0, 90, 0 ])
                cylinder(d = DIAL_DIAMETER * .45, h = DIAL_WIDTH * 2, center = true);
            }
            if (!$preview) sphere(r=chamfer, $fn=20);
        }

        // pin
        hull() {
            translate([-.1, 0, 0])
            rotate([ 0, 90, 0 ])
            cylinder(d = DIAL_PIN_DIAMETER, h = DIAL_WIDTH + chamfer*2 - .25, center = true);

            rotate([ 0, 90, 0 ])
            cylinder(d = DIAL_PIN_DIAMETER+1, h = DIAL_WIDTH - 5*2, center = true);
        }

        for (a = [0:180 / 8:180]) {
            rotate([ 180 + a, 0, 0 ])
            translate([ 0, -DIAL_POS_Y, -DIAL_POS_Z ])
            arm(play = PLAY * 2);
        }
    }
}

module stand_holder() {
    difference() {
        union() {
            base();
            arm();
        }
        channel();
    }
    % concrete();

    if (1) {
        % translate([ 0, DIAL_POS_Y, DIAL_POS_Z ])
        rotate([ 180, 0, 0 ])
        dial();
    }
}

if (0) {
    stand_holder();
}
else {
    rotate([ 0, 90, 180 ])
    dial();
}
