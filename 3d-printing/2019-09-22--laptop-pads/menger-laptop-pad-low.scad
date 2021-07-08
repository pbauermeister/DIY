// Menger Sponge

// Size of edge of sponge

$fn=60;

D=8*9 +2  +4;
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

module cuts() {
	// bottom clearance
	dx = D/9;
	w0 = D/27 * 8;
	h0 = D/27 * 8 + .5;
	h0 = 19;
	dx = D/9 ;
	w0 = 17.4;
	translate([dx-.2 -.5 -.2, -D/2, 0]) cube([w0, D*2, h0]);

	// top cut
	h = D/9 * 3;
	translate([-D/2, -D/2, h])
	cube(D*2);

	translate([D/9*4 -2.2 -1, D/9 -.3, 10.3])
	cube(D*2);

	// floor	
	translate([-D/2, -D/2, -2*D])
	cube(D*2);
}

herbie = 23.4 - D/9*2-.1 +1.5;

difference() {
	union() {
		translate([D/2, D/2, D/2])
		sponge();
		translate([D/2, D/2, D/2-D])
		sponge();

		// ceilings
		translate([0,     0, 23.4 + 19]) cube([D/27*7, D/3, 0.6]);
		translate([0, D/3*2, 23.4 + 19]) cube([D/27*7, D/3, 0.6]);
	}

	translate([-6  +.5, 0, herbie])
	cuts();
}

translate([D/3-1, 0, D/9*2 -.3])
cube([D/3*2 +1, D, 0.6]);

translate([1, 0, 19+herbie])
cube([D/9*2.7, D/3, 0.4]);

translate([1, D/3*2, 19+herbie])
cube([D/9*2.7, D/3, 0.4]);
