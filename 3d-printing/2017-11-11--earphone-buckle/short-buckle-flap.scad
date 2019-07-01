

$fn = 90;
WALL_THICKNESS = 1.4;
HEIGHT = WALL_THICKNESS*6;
DEPTH = 15;
ATOM = 0.001;
WIDTH = 28;
SPACING = 5;
PLAY = 0.5;

module rounded(offset, h) {
    cube([WIDTH-DEPTH-offset*0, DEPTH-offset*2, h+ATOM*2], true);

    translate([WIDTH/2-DEPTH/2, 0, 0])
    cylinder(d=DEPTH-offset*2, h=h+ATOM*2, center=true);

    translate([-WIDTH/2+DEPTH/2, 0, 0])
    cylinder(d=DEPTH-offset*2, h=h+ATOM*2, center=true);
}

module box(h) {
    translate([0, 0, HEIGHT/2])
    difference() {
        rounded(0, h);
        rounded(WALL_THICKNESS, h+ATOM*2);
    }
}

module flap() {
     width = WIDTH/5;
	difference() {
		union() {
			translate([-width/2, -DEPTH/2 +WALL_THICKNESS, 0])
			cube([width, DEPTH, WALL_THICKNESS]);

			translate([-width/2, -DEPTH/2 -WALL_THICKNESS*1.5, 0])
			cube([width, DEPTH, WALL_THICKNESS*4]);

			translate([-width/2, -DEPTH/2 +WALL_THICKNESS/1.5-WALL_THICKNESS*3, 0])
			cube([width, WALL_THICKNESS*6, WALL_THICKNESS*3]);

			translate([-width/2, -DEPTH/2 +WALL_THICKNESS/1.5, WALL_THICKNESS*3])
			rotate([0, 90, 0])
			cylinder(r=WALL_THICKNESS*3, h=width);
		}

		translate([-width/2-1, -DEPTH/2 +WALL_THICKNESS/1.5, WALL_THICKNESS*3])
		rotate([0, 90, 0])
		cylinder(r=WALL_THICKNESS*2, h=width+2);

	}
}

module unit() {
	difference() {
		box(HEIGHT);
		minkowski() {
			flap();
			cube([PLAY, PLAY, PLAY], true);
		}
	}
	flap();
}

//for (i=[0:2])
//    for (j=[0:2])
//        translate([i*(WIDTH+SPACING), j*(DEPTH+SPACING), 0])
      unit();
//flap();