$fn = 90;
CABLE_D1 = 5.5;
CABLE_D2 = 3.5 + .25;

HEIGHT = 10;

BLOCK_LENGTH = 30;
BLOCK_WIDTH  = 8;

TOLERANCE = 0.2;

EPSILON = 0.05;


module hole_central_1() {
	resize([CABLE_D1*1.4 + TOLERANCE, CABLE_D2+TOLERANCE, HEIGHT])
	cylinder(d=1, h=HEIGHT);
}

module hole_central_3() {
	translate([-CABLE_D2*.9/2, 0, 0])
	cube([CABLE_D2*.9, BLOCK_WIDTH, HEIGHT]);
}

difference() {
	translate([-BLOCK_LENGTH/2, -BLOCK_WIDTH/2, EPSILON])
	cube([BLOCK_LENGTH, BLOCK_WIDTH, HEIGHT-EPSILON*2]);
	hole_central_1();

	hole_central_3();

	for (i=[0:5]) {
		j = i; //i==0 ? 1 : (i==1 ? 0 : i);

		translate([CABLE_D2*2.1 + i*CABLE_D2*.75 , 0, 0])
		cylinder(d=CABLE_D2 * (.85 +j/5) , h=HEIGHT);

		translate([-CABLE_D2*2.1 - i*CABLE_D2*.75 , 0, 0])
		cylinder(d=CABLE_D2 * (.85 +j/5) , h=HEIGHT);
	}
}
