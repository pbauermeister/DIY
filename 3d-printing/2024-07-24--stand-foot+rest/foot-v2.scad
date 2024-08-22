
WIDTH = /*             */ 100 -.1;
LENGTH = /*            */ 103 -.1;
HEIGHT = /*              */ 5;

FRONT_SLIT = /*         */ 6 + 2;
BACK_SLIT = /*          */ 21.3 + 2.5;

$fn = $preview ? 60 : 160;
ATOM = 0.01;
PLAY = .35;

module cylinder0(factor = 0, height = 0, l = LENGTH, w = WIDTH) {
    h = factor ? HEIGHT * factor : height;
    resize([ w, l, h ]) cylinder(d = 10, h = 1);
}

module base() {
    difference() {
        cylinder0(factor = 1);
        
        cube([ FRONT_SLIT, LENGTH, HEIGHT*3 ], center = true);

        translate([ 0, LENGTH / 4, 0])
        cube([ BACK_SLIT, LENGTH, HEIGHT*3 ], center = true);
    }
    
    for (k=[-.4, 0, .4])
        translate([-LENGTH/4, -1.5 + WIDTH*k, 0])
        cube([LENGTH/2, 3, .3]);
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
//        channel();
    }
}

%concrete();
stand_holder();
