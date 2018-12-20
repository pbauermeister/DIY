D = 90;
THICKNESS = 1;

/*
 * Generate a segment
 */
module seg(x1, y1, x2, y2) {
    hull() {
        translate([x1, y1, 0]) cylinder(d=THICKNESS);
        translate([x2, y2, 0]) cylinder(d=THICKNESS);
    }
}

// Mesh: cartesian -> polar -> distortion -> cartesian
function aa(x, y, r) = atan2(y, x);
function rr(x, y) = sqrt(x*x + y*y) / 1.7 * pow(1-1/110, 2);

function xx1(x, y) = let(r=rr(x, y), a=aa(x, y, r))
                     fr(r, a)*cos(fa(r, a));
function yy1(x, y) = let(r=rr(x, y), a=aa(x, y, r))
                     fr(r, a)*sin(fa(r, a));

function xx2(x, y) = let(r=rr(x, y), a=aa(x, y, r))
                     fr(r, a)*cos(fa(r, a));
function yy2(x, y) = let(r=rr(x, y), a=aa(x, y, r))
                     fr(r, a)*sin(-fa(r, a));

// Mesh distortion
function fr(r, a) = r;
function fa(r, a) = a + r*r/50;

/*
 * Generate distored mesh
 */
module mesh() {
    space = 20;
    step = 5;

    // X mesh lines
    for (y=[-D:space:D]) {
        for (x=[-D:step:D-step]) {
            seg(xx1(x, y), yy1(x, y),
                xx1(x+step, y), yy1(x+step, y));

            seg(xx2(x, y), yy2(x, y),
                xx2(x+step, y), yy2(x+step, y));
        }
    }

    // Y mesh lines
    for (y=[-D:space:D]) {
        for (x=[-D:step:D-step]) {
            seg(xx1(y, x), yy1(y, x), 
                xx1(y, x+step), yy1(y, x+step));

            seg(xx2(y, x), yy2(y, x), 
                xx2(y, x+step), yy2(y, x+step));
        }
    }
}


mesh();
