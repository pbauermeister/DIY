

DIAMETER = 20;
WALL     =  0.65;
ATOM     = 0.01;

$fn = $preview ? 15 : 100;

KD = .7;
KH = .04;
A  = 12;
N  = 20;

module slice(d1, a, adjust, end=false) {
    max_a = acos(KD);
    c = cos(a/N * max_a);
    d = d1 * c;

    translate([(d-d1)/2, 0, a*d*KH])
    rotate([0, -a, 0])
    if (!end)
        cylinder(d=d-adjust*2, h=adjust?ATOM*2:ATOM, center=true);
    else {
        translate([0, 0, -WALL/2])
        scale([1, 1, .33])
        sphere(d=d+WALL/2 - adjust*2);
    }
}

module segment_0(d1, adjust=0, end=false) {
    for (a=[1:N]) {
        hull() {
            slice(d1, a-1, adjust);
            slice(d1, a, adjust);
        }
    }
    if (end)
        slice(d1, N, adjust, true);
}

module segment_1(d, adjust=0, end=false) {
    // top side (round)
    intersection() {
        translate([0, -ATOM, 0])
        rotate([-90, 0, 0])
        cylinder(d=DIAMETER*10,h=DIAMETER);

        segment_0(d, adjust, end);
    }

    // bottom side (flattened)
    scale([1, .5, 1])
    intersection() {
        rotate([90, 0, 0])
        cylinder(d=DIAMETER*10,h=DIAMETER);

        segment_0(d, adjust, end);
    }
}

module segment(d, end=false) {
    difference() {
        segment_1(d, 0, end=end);
        segment_1(d, WALL, end=end);
    }
}


module all() {
    segment(DIAMETER);
    segment(DIAMETER * KD);
    segment(DIAMETER * KD * KD, true);

//    scale([1, 1, -1]) segment(DIAMETER);
}

difference() {
    all();
    //cube(1000);
}

echo(acos(.97));
echo(cos(25)*cos(25));