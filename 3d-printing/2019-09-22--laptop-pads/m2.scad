
N=3;

ETCH = .8;
D = 78;

CW = 17.8;
CH = 19;
CX = D/3 -1.85 - CH;

H = D/3 - D/27*1.7;

echo(CX);
echo(H-CH);
echo(D/9);

EPSILON = 1.1; //0.01;

module cavity(l, w, h, size, depth=2) {
	if (depth) {
		o = size;
		for (x=[o:size*3:l-size]) {
			for (y=[o:size*3:w-size]) {
				translate([x, y, -EPSILON])
				cube([size, size, h+EPSILON*2]);
			}
		}
		for (x=[o:size*3:l-size]) {
			for (z=[o:size*3:h-size]) {
				translate([x, -EPSILON, z])
				cube([size, w+EPSILON*2, size]);
			}
		}
		for (z=[o:size*3:h-size]) {
			for (y=[o:size*3:w-size]) {
				translate([-EPSILON, y, z])
				cube([l+EPSILON*2, size, size]);
			}
		}
		cavity(l, w, h, size/3, depth-1);
	}
}


module cuts() {
	translate([CX, -D/2, 0]) cube([CW, D*2, CH]);
}

module part(l, w, h, size, n, skin) {
	difference() {
		cube([l, w, h]);
		cavity(l, w, h, size, n);
	}
	translate([skin, skin, 0])
	cube([l-skin*2, w-skin*2, h-skin]);
}

module all(k) {
	difference() {
		union() {
			hh = H + (k-1)*D/9;
			hhh = H + D/9;
			part(D, D, D/9*2, D/3, N, ETCH);

			part(CX*2 + CW, D/3, hh, D/3, N, ETCH);

			translate([0, D/3*2, 0])
			part(CX*2 + CW, D/3, hh, D/3, N, ETCH);

			part(D, D/9-1, hhh, D/3, N, ETCH);
		}
		cuts();
	}
}

all(1);

translate([-D/9, 0, 0])
mirror([1, 0, 0])
all(2);

translate([-D*2-D/9*2, 0, 0])
all(2);
