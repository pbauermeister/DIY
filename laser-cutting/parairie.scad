//$fn = 4;

ATOM = 0.01;
pi = 180;

STEP1 = 1;
K = 10;
D = 90;

THICKNESS = 1;

COLORS = [
"LightYellow",
    "PowderBlue",
    "LightBlue",
"Yellow",
    "SkyBlue",
    "LightSkyBlue",
"Gold",
    "DeepSkyBlue",
    "DodgerBlue",
"Orange",
    "CornflowerBlue",
    "RoyalBlue",
"DarkOrange",
    "Blue",
    "MediumBlue",
"OrangeRed",
    "DarkBlue",
    "Navy",
"Tomato",
    "MidnightBlue"
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

////////////////////////////////////////////////////////////////////////////////
// BUTTERFLY
////////////////////////////////////////////////////////////////////////////////

/*
 * Generate various butterfly shapes
 */

// http://www.matcmp.ncc.edu/~glassr/y2m_2005/samples.htm
function r1(t) = (abs(1 + 2*pow(cos(4*t), 3) - sin(2*t)) + .75)
                 * (1 + cos(t-45)*.2);

function rn(t, n) = r1(t+11) * pow(3, n*.5) / 20;
function fx(t, n) = cos(t) * rn(t, n) * K;
function fy(t, n) = sin(t) * rn(t, n) * K;
function points(n) = [ for(t=[0:STEP1:360]) [fx(t, n), fy(t, n)]];

/*
 * Generate filled butterfly
 */
module butterfly(n) {
    linear_extrude(1)
    polygon(points(n));
}

/*
 * Generate butterfly border
 */
/*
module butterfly_border(n) {
    difference() {
        linear_extrude(1)
        offset(delta=THICKNESS)
        polygon(points(n));

        linear_extrude(1)
        polygon(points(n));
    }
}
*/

/*
 * Generate plate with a butterfly hole
 */
module butterfly_plate(n) {
    translate([0, 0, n])
    difference() {
        translate([0, 0, .5])
        cube([D, D, 1-ATOM*2], true);
        
        translate([D/4, D/4, -.5])
        scale([1, 1, 2])
        butterfly(n);
    }
}

if(0)
for (i=[1: 0.5: 4]) {
    color(COLORS[i*2])
    butterfly_plate(i);
}
butterfly_plate(2);

////////////////////////////////////////////////////////////////////////////////
// FLOWER
////////////////////////////////////////////////////////////////////////////////

/*
 * Generate various flower shapes
 */

function rfn(t, k) = (0.1+cos(k*t)) / 2; //  rf1(t+11) * pow(3, n*.5) / 20;
function ffx(t, k) = cos(t) * rfn(t, k) * K;
function ffy(t, k) = sin(t) * rfn(t, k) * K;
function fpoints(k) = [ for(t=[0:STEP1:360]) [ffx(t, k), ffy(t, k)]];

/*
 * Generate filled flower
 */
NN = 6;
module flower(k) {
    linear_extrude(1) {
        for(n=[1:NN]) {
            for(d=[1:NN]) {
                k = n/d;
                translate([((n-1)-(NN-1)/2)*D/8, ((d-1)-(NN-1)/2)*D/8, 0])
                polygon(fpoints(k));
            }
        }
    }
}

/*
 * Generate plate with a flower hole
 */
module flower_plate(n) {
    translate([0, 0, n])
    intersection() {
        translate([0, 0, .5])
        cube([D, D, 1-ATOM*2], true);
        
        translate([0, 0, -.5])
        scale([1, 1, 2])
        flower(n);
    }
}

if(0)
    for (i=[1: 0.5: 4]) {
    color(COLORS[i*2])
    flower_plate(i);
}

color("lightblue")      flower_plate(1);
//color("blue")           flower_plate(2);
//color("darkblue")       flower_plate(3);
//color("LightSkyBlue")   flower_plate(4);

////////////////////////////////////////////////////////////////////////////////
// MESHS
////////////////////////////////////////////////////////////////////////////////

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
function fr(r, a) = r; //         +sin(a*8)*4;
function fa(r, a) = a + r*r/50;

/*
 * Generate distored mesh
 */
module mesh1(index) {
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
module mesh2() {
    STEP2 = 12;
    R = D/2;
    for (i=[0:STEP2:360-STEP2]) {
        x= R * cos(i);
        y= R * sin(i);
        translate([x, y, 0])
        difference() {
            cylinder(d=R+THICKNESS/2);
            translate([0, 0, -.75])
            cylinder(d=R-THICKNESS/2, h=2);
        }
    }
}
*/

/*
 * Generate plate with mesh cutouts and butterfly hole
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
                mesh1(n2);
                
                // butterfly border
                butterfly_border(n);

                // next butterfly
                if (next) {
                    butterfly(next);
                    butterfly_border(next);
                }

                // frame
                translate([0, 0, .5])
                difference() {
                    cube([D, D, 1], true);
                    cube([D-THICKNESS*2, D-THICKNESS*2, 2], true);
                }

            }
        }
        // bore butterfly
        translate([0, 0, -.5])
        scale([1, 1, 2])
        butterfly(n);
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
    mesh_plate(7, 4);
}


//all();