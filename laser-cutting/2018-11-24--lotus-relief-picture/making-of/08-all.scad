ATOM = 0.01;
AMAX = 180;

STEP1 = 1;
K = 10;
D = 90;

THICKNESS = 1;

COLORS = [
    "Blue",
    "Blue",
    "Blue",

    "Gold",
    "Blue",
    "Blue",

    "DarkSlateGray"
];

/*
 * Generate a segment
 */
module seg(x1, y1, x2, y2, thickness_k=1) {
    hull() {
        translate([x1, y1, 0])
        cylinder(d=THICKNESS*thickness_k);
        translate([x2, y2, 0])
        cylinder(d=THICKNESS*thickness_k);
    }
}

////////////////////////////////////////////////////////////////////
// LOTUS
////////////////////////////////////////////////////////////////////

/*
 * Generate various lotus shapes
 */

// https://podcollective.com/polar-graph-art-quickgraph-a/lotus-equasion/
function r1(t) = (1+(((abs(cos(t*3)))+(0.25-(abs(cos(t*3+AMAX/2))))*2)
                    / (2+abs(cos(t*6+AMAX/2))*8))
                 ) * 0.7;
function r2(t) = (2+(((abs(cos(t*3)))+(0.25-(abs(cos(t*3+AMAX/2))))*2)
                    / (2+abs(cos(t*6+AMAX/2))*8))
                 ) *0.6;
function r3(t) = (3+(((abs(cos(t*6)))+(0.25-(abs(cos(t*6+AMAX/2))))*2)
                    / (2+abs(cos(t*12+AMAX/2))*8))
                 ) * 0.6;

function r4_(t) = //(1.0 * min(1/abs(cos(t)), 1/abs(sin(t))) *
                 (3+(((abs(cos(t*8)))+(0.25-(abs(cos(t*8+AMAX/2))))*2)
                    / (2+abs(cos(t*16+AMAX/2))*8))
                 ) *0.8;

function r4(t) = (3+(((abs(cos(t*6)))+(0.25-(abs(cos(t*6+AMAX/2))))*2)
                    / (2+abs(cos(t*12+AMAX/2))*8))
                 ) * 0.8;

function r0(t, n)
    = n==1 ? r1(t) : n==2 ? r2(t) : n==3 ? r3(t) : r4(t);
function fx(t, n) = cos(t) * r0(t, n) * K;
function fy(t, n) = sin(t) * r0(t, n) * K;
function points(n) = [ for(t=[0:STEP1:360]) [fx(t, n), fy(t, n)]];

/*
 * Generate filled lotus
 */
module lotus(n) {
    linear_extrude(1)
    polygon(points(n));
}

/*
 * Generate lotus border
 */
module lotus_border(n) {
    difference() {
        linear_extrude(1)
        offset(delta=THICKNESS)
        polygon(points(n));

        linear_extrude(1)
        polygon(points(n));
    }
}

////////////////////////////////////////////////////////////////////
// MESHS
////////////////////////////////////////////////////////////////////

// Mesh: cartesian -> polar -> distortion -> cartesian
function aa(x, y, i, r) = atan2(y, x); // + i*sin(r);
function rr(x, y, i) = sqrt(x*x + y*y) / 1.7 * pow(1-i/110, 2);

function xx1(x, y, i) = let(r=rr(x, y, i), a=aa(x, y, i, r))
                    fr(r, a)*cos(fa(r, a));
function yy1(x, y, i) = let(r=rr(x, y, i), a=aa(x, y, i, r))
                    fr(r, a)*sin(fa(r, a));

function xx2(x, y, i) = let(r=rr(x, y, i), a=aa(x, y, i, r))
                    fr(r, a)*cos(fa(r, a));
function yy2(x, y, i) = let(r=rr(x, y, i), a=aa(x, y, i, r))
                    fr(r, a)*sin(-fa(r, a));

// Mesh distortion
function fr(r, a) = r;
function fa(r, a) = a + r*r/50;

/*
 * Generate distored mesh
 */
module mesh(index) {
    space = 20;
    step = 5;
    //thickness_k = 1;
    thickness_k = 3 - index/1.5;

    // X mesh lines
    for (y=[-D:space:D]) {
        for (x=[-D:step:D-step]) {
            x0 = x;
            y0 = y;
            x1 = x+step;
            y1 = y;
            seg(xx1(x0, y0, index), yy1(x0, y0, index),
                xx1(x1, y1, index), yy1(x1, y1, index),
                thickness_k);

            seg(xx2(x0, y0, index), yy2(x0, y0, index),
                xx2(x1, y1, index), yy2(x1, y1, index),
                thickness_k);
        }
    }

    // Y mesh lines
    for (y=[-D:space:D]) {
        for (x=[-D:step:D-step]) {
            x0 = x;
            y0 = y;
            x1 = x+step;
            y1 = y;
            seg(xx1(y0, x0, index), yy1(y0, x0, index),
                xx1(y1, x1, index), yy1(y1, x1, index),
                thickness_k);
            seg(xx2(y0, x0, index), yy2(y0, x0, index),
                xx2(y1, x1, index), yy2(y1, x1, index),
                thickness_k);
        }
    }
}

/*
 * Generate plate with mesh cutouts and lotus hole
 */
module mesh_plate(z, n, next=0) {
    n2 = 1 + z/2.75;
    color(COLORS[z])
    translate([0, 0, z])
    difference() {
        // clip
        intersection() {
            translate([0, 0, .5])
            cube([D, D, 1-ATOM*2], true);

            union() {
                // mesh
                mesh(n2);
                
                // lotus border
                lotus_border(n);

                // next lotus
                if (next) {
                    lotus(next);
                    lotus_border(next);
                }

                // frame
                translate([0, 0, .5])
                difference() {
                    cube([D, D, 1], true);
                    cube([D-THICKNESS*2, D-THICKNESS*2, 2], true);
                }

            }
        }
        // bore lotus
        translate([0, 0, -.5])
        scale([1, 1, 2])
        lotus(n);
    }
}

module all() {
    mesh_plate(0, 1, 1);
    mesh_plate(1, 1, 2);

    mesh_plate(2, 2, 2);
    mesh_plate(3, 2, 3);

    mesh_plate(4, 3, 3);
    mesh_plate(5, 3, 4);

    mesh_plate(6, 4);
}

all();
