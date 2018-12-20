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

function xx(x, y) = let(r=rr(x, y), a=aa(x, y, r))
                    fr(r, a)*cos(fa(r, a));
function yy(x, y) = let(r=rr(x, y), a=aa(x, y, r))
                    fr(r, a)*sin(fa(r, a));

// Mesh distortion
function fr(r, a) = r;
function fa(r, a) = a + r*r/50;

/*
 * Generate distorted mesh
 */
module mesh() {
    space = 20;
    step = 5;

    // X mesh lines
    for (y=[-D:space:D]) {
	for (x=[-D:step:D-step]) {
            x0 = x;
            y0 = y;
            x1 = x+step;
            y1 = y;
            seg(xx(x, y), yy(x, y),
		xx(x+step, y), yy(x+step, y));
	}
    }

    // Y mesh lines
    for (y=[-D:space:D]) {
	for (x=[-D:step:D-step]) {
            x0 = x;
            y0 = y;
            x1 = x+step;
            y1 = y;
            seg(xx(y, x), yy(y, x),
		xx(y, x+step), yy(y, x+step));
	}
    }
}

mesh();

