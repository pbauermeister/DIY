

$fn = 90;
WALL_THICKNESS = 1.7; //1.4;
HEIGHT = 8.4;
ATOM = 0.001;
SPACING = 5;
PLAY = 0.7;

DEPTH = 15 + 2;
WIDTH = 28 + 4;
FLAP_WIDTH = WIDTH/4.5;

HINGE_RADIUS = 4.2;
SPACE = PLAY/2; //WALL_THICKNESS/4;

DRAFT = false;

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
     width = FLAP_WIDTH;
     width2 = FLAP_WIDTH * .8;
	difference() {
		union() {
			translate([-width/2, -DEPTH/2 +WALL_THICKNESS/2, 0])
			cube([width, DEPTH, WALL_THICKNESS]);
			if (0) {
				translate([-width/2, -DEPTH/2 -WALL_THICKNESS, 0])
				cube([width, DEPTH - SPACE, HEIGHT]);

				translate([-width/2, -DEPTH/2 + HINGE_RADIUS/4.5-HINGE_RADIUS, 0])
				cube([width, HINGE_RADIUS*2, HEIGHT]);
			} else {
				translate([-width2/2, -DEPTH/2 + WALL_THICKNESS*.5, 0])
				cube([width2, DEPTH -WALL_THICKNESS*1.5 - SPACE, HEIGHT*.9]);

				translate([-width/2, -DEPTH/2 + HINGE_RADIUS/4.5-HINGE_RADIUS, 0])
				cube([width, HINGE_RADIUS*2, HINGE_RADIUS]);

				translate([-width/2, -DEPTH/2 +  HINGE_RADIUS/4.5, HINGE_RADIUS])
				rotate([0, 90, 0])
				cylinder(r=HINGE_RADIUS, h=width);
			}
		}

		translate([-width/2-1, -DEPTH/2 + HINGE_RADIUS/4.5, HINGE_RADIUS])
		rotate([0, 90, 0])
		cylinder(r=HINGE_RADIUS/1.75, h=width+2);

	}
}

module grow() {
	if (DRAFT) {
		children();
	} else {
		minkowski() {
			children();
			cube([PLAY, PLAY, PLAY], true);
		}
	}
}

module unit() {
	difference() {
		box(HEIGHT);
		grow()
		flap();
	}
	flap();
}

//for (i=[0:2])
//    for (j=[0:2])
//        translate([i*(WIDTH+SPACING), j*(DEPTH+SPACING), 0])
      unit();
//flap();