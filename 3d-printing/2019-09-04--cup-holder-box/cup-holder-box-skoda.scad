$fn = 180;

D1 = 63.5;
D2 = 69;
H  = 60;
THICKNESS = 2.5;

SW = 78;
SH = 50;
STHICKNESS = 5;
SW2 = SW+STHICKNESS*2;
SD2 = D2 + 5;

COIN_D = 28;
COIN_H = 3;
BLOCK1_H = H * .66;

SPACE = 11;

FILAMENT = 0.2;

ATOM = 0.01;

////////// CUP //////////

module cup() {
	difference() {
		cylinder(d1=D1, d2=D2, h=H);

		translate([0, 0, THICKNESS*0-.1])
		cylinder(d1=D1 - THICKNESS*2, d2=D2 - THICKNESS*2, h=H+.2);
	}

	rotate([0, 0, -90])
	intersection() {
		cylinder(d1=D1, d2=D2, h=H);

		translate([-D2/2, -D2 + SPACE+2.5, 0])
		cube([D2, D2, THICKNESS]);
	}
}

module block1() {
	shift = -THICKNESS +2;
	difference() {
		intersection() {
			union() {
				elevation = THICKNESS + BLOCK1_H-COIN_D/2-5;

				translate([-D2/2, SPACE + shift, elevation])
				cube([D2, D2/2, COIN_D/2+5]);

				translate([-D2/2, SPACE+shift, THICKNESS])
				cube([D2, THICKNESS, BLOCK1_H]);

				// supports
				spacing = 2;
				thickness = .5; color("red")
				for(y=[spacing/2:spacing:D1/2]) {
					translate([y, SPACE, elevation - thickness])		
					cube([1,D1,1]);
					translate([-y, SPACE, elevation - thickness])		
					cube([1,D1,1]);
				}
			}

			translate([0, 0, THICKNESS])
			cylinder(d1=D1, d2=D2, h=H-THICKNESS+1);
		}

		shift2 = BLOCK1_H + 5;;
		translate([0, shift + 10+COIN_H*2.5, shift2]) coin();
		translate([0, shift + 10+COIN_H*5  , shift2]) coin();
	}
}

module block2() {
	shift = -THICKNESS;
	intersection() {
		translate([0, 0, THICKNESS])
		cylinder(d1=D1, d2=D2, h=H-THICKNESS+1);

		union() {
			translate([-D1/4 * 1.2, -THICKNESS, THICKNESS])
			cube([THICKNESS, D2, BLOCK1_H]);

			translate([-D2/2, -THICKNESS -0, THICKNESS])
			cube([D2, THICKNESS, BLOCK1_H]);
		}
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

