// Menger Sponge

// Size of edge of sponge

$fn=60;

D=8*9 +2;
// Fractal depth (number of iterations)
n=3;

echo(version=version());

module menger() {
  difference() {
    cube(D, center=true);
    for (v=[[0,0,0], [0,0,90], [0,90,0]])
      rotate(v) menger_negative(side=D, maxside=D, level=n);
  }
}

module menger_negative(side=1, maxside=1, level=1) {
  l=side/3;
  cube([maxside*1.1, l, l], center=true);
  if (level > 1) {
    for (i=[-1:1], j=[-1:1])
      if (i || j)
        translate([0, i*l, j*l])
          menger_negative(side=l*1.05, maxside=maxside, level=level-1);
  }
}

module sponge() {
	//rotate([-180, 0, 0])
	rotate([-45, 0, 0])
	rotate([0, -atan(1/sqrt(2)), 0])
	difference() {
	  rotate([45, atan(1/sqrt(2)), 0]) menger();
	}
}

module support() {
	// wall
	d = .6;
	d2 = 1.5;

	if(0)
	difference() {
		union() {
			translate([0, D/6 + D/12*2 -d, 0])	cube([D, d, 19]);
			translate([0, D/6 + D/12*2 - d2, 0])	cube([D, d2, .5]);
		}
		intersection() {
			translate([0, D/6 + D/12*2 -d, 0])	cube([D, d, 19]);
			translate([0, D/6 + D/12*2 - d2, 0])	cube([D, d2, .5]);
		}
	}

	// ceiling
	thickness = 0.6;
	h = D/27 * 9 - D/27 +.5;
	h = 19;
	w = D/9*4-.5;
	w = 17;

	translate([0, 0, h])
	cube([D/3, D/3, thickness]);

	translate([D/3*2, 0, h])
	cube([D/3, D/3, thickness]);

	translate([D/3, 0, h])
	cube([D/3, D/3, thickness]);

}

module supports() {
	support();
	translate([D/3, D/3, 0]) {
		/*
		cylinder(d=1.5, h=19);
		cylinder(d=3, h=1);
		*/

		translate([-.5, -.5, 0])
		cube([10, 1, 19]);
		cube([9.5, 3, 1]);

		translate([-.5, -.5, 0])
		cube([1, 10, 19]);
		cube([3, 9.5, 1]);

	}

	translate([0, D, 0])
	rotate([0, 0, -90])
	support();
}

%translate([-44, 21, -4]) cube(8); // to give sense of size

difference() {
	union() {
		translate([D/2, D/2, D/2])
		sponge();
	}

	// bottom clearance
	dx = D/9;
	w0 = D/27 * 8;
	h0 = D/27 * 8 + .5;
	h0 = 19;
	dx = D/9 ;
	w0 = 17;
	translate([dx-.2, -D/2, 0]) cube([w0, D*2, h0]);
	translate([-D/2, dx-.2, 0]) cube([D*2, w0, h0]);

	// top cut
     dh = D/9 - .25;
     dv = D/9 * 3;
	translate([dh, dh, dv])
	cube(D);

	h = D/9 * 4 - .25;
	translate([-D/2, -D/2, h])
	cube(D*2);
}

supports();
