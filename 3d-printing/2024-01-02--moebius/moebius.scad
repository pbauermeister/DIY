

DIAMETER         =  80;
WIDTH            =  25;
NB_PARTS         =  90;

MIN_DISTANCE     = 0.3;
CORE_DIAMETER    = 2.5;

ATOM             = .01;

module core() {
    rotate_extrude(convexity = 10)
    translate([DIAMETER/2, 0, 0])
    scale([.5, 1, 1])
    circle(d=CORE_DIAMETER, $fn=12);
}

module band() {
    a = 360/NB_PARTS;
    r2 = WIDTH * sqrt(2) / 2;
    r = DIAMETER/2 - r2;
    h = r * sin(a) - MIN_DISTANCE;
    
    for (i=[0:NB_PARTS-1]) {
        a = 360/NB_PARTS*i;
        rotate([0, 0, a])
        translate([DIAMETER/2, 0, 0])
        rotate([0, a/4, 0])
        cube([WIDTH, h, WIDTH], center=true);
    }
}


module moebius() {
    band();
    core();
}

moebius();
