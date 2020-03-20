$fn = 4;

THICKNESS = 2;
K = 0.3;
L = 0.75;
R = 100;

function spiro_x(t, dt, k, l, r) = r*( (1-k)*cos(dt+t) + l*k*cos(dt+(1-k)/k*t) );
function spiro_y(t, dt, k, l, r) = r*( (1-k)*sin(dt+t) - l*k*sin(dt+(1-k)/k*t) );
function spiro(t, dt, k, l, r) = [spiro_x(t, dt, k, l, r), spiro_y(t, dt, k, l, r)];

module segment(a, b, thickness) {
	hull() {
		translate(a) cylinder(d=thickness, center=true);
		translate(b) cylinder(d=thickness, center=true);
	}
}

MAX_T = 360 * 4;
DT = 20/5;

module slice(k, l, r, dt, thickness) {
	points = [ for (t=[0:DT:MAX_T]) spiro(t, dt, k, l, r) ];

	for (i=[0:len(points)-2]) {
		a = points[i];
		b = points[i+1];
		segment(a, b, thickness);
	}
}

module slice1(i, second=true) {
//  k = 0.8;
//  l = 0.3 + .1 + i/50;
//  dt = i;
    k = 0.3;
    l = .95;
    dt = 0;

	if(!second)
        slice(k, l, 180 + 5 * i, dt, THICKNESS);
	if(second)
		slice(k/2, l*1.5, 100, dt, THICKNESS);
}

module slice2(i) {
	slice1(i, false);
	slice1(i/2, !false);
}

module all() {
	for (i=[0:9  *1+1]) {
		translate([0, 0, i]) {
			slice2(i);
		}
	}
}

all();
//slice2(0);
