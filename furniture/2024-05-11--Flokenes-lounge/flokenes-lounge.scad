
// https://www.ikea.com/ch/de/p/slaekt-sitzkissen-matratze-faltbar-10362963/
// slaekt

L = 900 *0 +480;
l = 600 *0 +620;
h = 140 *0 + 90;
h2 = 20;

RADIUS = 10;
ATOM = 0.125;

module person_sitting(angle=0) {
	translate([-80, -290,   0])
	translate([0, 0, 440+80])
	rotate([-angle, 0, 0]) translate([0, 0, -440-80])
	scale([1, 0.6, 1]) cylinder(r=80, h=440+80);

	translate([80, -290,   0])
	translate([0, 0, 440+80])
	rotate([-angle, 0, 0]) translate([0, 0, -440-80])
	scale([1, 0.6, 1]) cylinder(r=80, h=440+80);

	translate([-80, -50, 500]) rotate([90, 0, 0])
	scale([1, 0.6, 1]) cylinder(r=80, h=250);
	translate([80, -50, 500]) rotate([90, 0, 0])
	scale([1, 0.6, 1]) cylinder(r=80, h=250);

	scale([1, 0.6, 1]) translate([  0,    0, 440]) cylinder(r=180, h=580);
	
	translate([ 190, 0, 440]) cylinder(r=40, h=580);
	translate([-190, 0, 440]) cylinder(r=40, h=580);

	translate([0, 0, 1300-125 ]) sphere(r=125);
}

dx = 100;
dy = 100;
rr  = 30;

module block(dx=0, dy=0) {

	color("#f0f0f0")
	minkowski() {
		translate([RADIUS, RADIUS, RADIUS])
		cube([L-RADIUS*2, l-RADIUS*2, h-RADIUS*2]);
		sphere(RADIUS);
	}

    dx2 = dx - rr;
    dy2 = dy - rr;    
    if (dx || dy) {    
        color("maroon")
        translate([-dx2, -dy2, -h2])
        minkowski() {
            cube([L+dx2*2, l+dy2*2, h2]);
                cylinder(r=rr, h=ATOM);
        }
    }
}

open = true;

module all() {
    //

	translate([0, l, 0])
	rotate([open ? -5 : 0, 0, 0])
	translate([0, -l, 0])
	translate([0, 1, h]) block(dx=dx, dy=0);

    // back
	translate([0, l, h*2]) rotate([open? -20 : 90, 0, 0])
	translate([0, h, 0]) rotate([90, 0, 0]) block(dx=dx, dy=dy);
}

N_SEATS = 4;
dh = h*1;
for (i=[0:N_SEATS-1]) translate([L*i, 0, dh]) all();

N_PERSONS = 1;
if (N_PERSONS)
for (j=[0:N_PERSONS-1]) translate([L*j, 0, 0])
	translate([N_SEATS/2*L + (j-N_PERSONS/2+.5)*600, 350, -180]) person_sitting(48);

