
D = 37;
L = 200; //250;
L2 = 150;
W = 60;
H0 = 107;
H = H0 + D/2;
PX = 30;
W0 = 15;
H1 = 15;

PH = H + D/2;

EPSILON = 0.01;



L = 60;
BH = 20;
module body(just_base=false) {
	if (!just_base)
	translate([0, 0, BH])
	difference() {
		translate([0, -W/2, 0])
		cube([L/2, W, H]);

		translate([-L/2, -W0/2, -EPSILON])
		cube([L*2, W0, H]);

		translate([-L/2, 0, H0+D/2])
		rotate([0, 90, 0])
		cylinder(d=D, h=L*2);
	}

	delta = just_base ? 0.17 : 0;
	translate([0, -L/2 -delta, 0])
	cube([L/2+delta*2, L+delta*2, BH]);
}

LL = 200;
MA = 10;
WW = 100;
DD = 30;
HH = 8;

module pillars(just_base=false) {
	translate([0, 0, 0])
	body(just_base);

	translate([LL-L/2, 0, 0])
	body(just_base);
}

module base() {
	difference() {
		minkowski() {
			translate([DD/2, -WW/2, 0])
			cube([LL-DD, WW, HH]);
			cylinder(d=DD, h=.1);
		}
		pillars(true);

		d = 20;
		dd = WW+DD-d;
		ww = LL-W-d;
		translate([(LL-ww)/2, -dd/2, 0])
		cube([ww, dd, HH*2]);
	}
}


base();
//pillars();

translate([W+H/2, H-20, 0])
rotate([0, 270, 0])
body(false);

translate([W+H/2, H+W, 0])
rotate([0, 270, 0])
body(false);
