$fn = 180;

D1 = 62 + 3;
D2 = 78 + 3;
H  = 90 + 5;
THICKNESS = 3.2;

SW = 78;
SH = 50;
STHICKNESS = 5;
SW2 = SW+STHICKNESS*2;
SD2 = D2 + 5;

COIN_D = 28;
COIN_H = 3;
BLOCK1_H = H * .66;

FILAMENT = 0.2;

////////// CUP //////////

module cup() {
	difference() {
		cylinder(d1=D1, d2=D2, h=H);

		translate([0, 0, THICKNESS*0-.1])
		cylinder(d1=D1 - THICKNESS*2, d2=D2 - THICKNESS*2, h=H+.2);

		translate([0, 0, H]) {
			step = 45;
			for (a=[0: step: 180-step])
			rotate([0, 0, a])
			cube([D2/6, D2, 10], center=true);
		}
	}

	rotate([0, 0, -90])
	intersection() {
		translate([-D2/2, -D2/2 + 8, 0])
		cube([D2, D2/2, THICKNESS]);
		cylinder(d1=D1, d2=D2, h=H);
	}
}

module block1() {
	shift = -THICKNESS;
	difference() {
		intersection() {
			union() {
				translate([-D2/2, 8 + shift, THICKNESS + BLOCK1_H-COIN_D/2-5])
				cube([D2, D2/2, COIN_D/2+5]);

				translate([-D2/2, 8+shift, THICKNESS])
				cube([D2, THICKNESS, BLOCK1_H]);
			}

			translate([0, 0, THICKNESS])
			cylinder(d1=D1 - THICKNESS*2, d2=D2 - THICKNESS*2, h=H-THICKNESS+1);
		}
		shift2 = BLOCK1_H + 5; //COIN_D/2-5;
		translate([0, shift + 14           , shift2]) coin();
		translate([0, shift + 14+COIN_H*2.5, shift2]) coin();
		translate([0, shift + 14+COIN_H*5  , shift2]) coin();
	}
}

module block2() {
	difference() {
		intersection() {
			translate([-D2/2, THICKNESS, THICKNESS])
			cube([D2, D1/2, BLOCK1_H]);

			translate([0, 0, THICKNESS])
			cylinder(d1=D1 - THICKNESS*2, d2=D2 - THICKNESS*2, h=H-THICKNESS+1);
		}
		translate([THICKNESS/2 - D2, THICKNESS + THICKNESS, 0])
		cube([D2*2, D2, H]);
	}
}

module coin() {
//	translate([0, 0, BLOCK1_H-COIN_D/2-5])
	rotate([90, 0, 0])
	hull() {
		cylinder(d=COIN_D, h=COIN_H);
		translate([0, -3, 0])
		cylinder(d=COIN_D, h=COIN_H);
	}
}

union() {	
	rotate([0, 0, -90])
	block1();
	rotate([0, 0, 180-90])
	block2();
	cup();
}

////////// CAP //////////

module cap() {
     shift = SW2 - D2 - STHICKNESS;
	intersection() {
		difference() {
			translate([0, -shift, 0])
			translate([-SD2/2, -SW/2-STHICKNESS, 0])
			cube([SD2, SW2, SH]);

			translate([0, -shift, 10])
			translate([SD2/2, -SW/2, THICKNESS])
			rotate([0, 20, 0]) {
				translate([-SD2*2 + THICKNESS, 0, 0])
				cube([SD2*2, SW, SH]);
			}

			translate([-SD2, -10/2, 9])
			cube([D2*2, 10, 20]);

			translate([0, 0, -1])
			cylinder(d=D2-THICKNESS*2, h=H);

			rotate([0, 0, -1])
			translate([0, 0, -H+5])
			cup();

			rotate([0, 0, 1])
			translate([0, 0, -H+5])
			cup();

			translate([-D2*.7, D2*.7, -D2/5])
			sphere(d=D2);
			translate([-D2*.7, -D2*.7, -D2/5])
			sphere(d=D2);
		}

		translate([-SD2*.125 + THICKNESS/2, 0, 0])
		rotate([90, 0, 0])
		cylinder(d= SD2*1.25, h=D2*2, center=true);
	}
}


//translate([0, 0, H -5])
!translate([D2+10, 0, 0])
cap();
