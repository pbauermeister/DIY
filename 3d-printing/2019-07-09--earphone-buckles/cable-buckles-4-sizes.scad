/* OpenSCAD project.
 * Buckles to hold cables together. 4 different sizes.
 *
 * (C) 2019 by P. Bauermeister
 *
 * See https://github.com/pbauermeister/DIY/tree/master/3d-printing/2019-07-09--earphone-buckles
*/

// Object sizes
SMALL_HEIGHT          =  8.4;
SMALL_WALL_THICKNESS  =  1.7;
SMALL_LENGTH          = 28.0;
SMALL_WIDTH           = 16.0;
SMALL_PRONG_SIZE      =  6.0;

MEDIUM_HEIGHT         =  8.4;
MEDIUM_WALL_THICKNESS =  1.7;
MEDIUM_LENGTH         = 32.0;
MEDIUM_WIDTH          = 17.0;
MEDIUM_PRONG_SIZE     =  7.0;

BIG_HEIGHT            =  8.4;
BIG_WALL_THICKNESS    =  1.9;
BIG_LENGTH            = 40.0;
BIG_WIDTH             = 20.0;
BIG_PRONG_SIZE        =  8.0;

BIGGER_HEIGHT         =  8.4;
BIGGER_WALL_THICKNESS =  1.7;
BIGGER_LENGTH         = 56.0;
BIGGER_WIDTH          = 32.0;
BIGGER_PRONG_SIZE     =  9.0;

// Rendering
DRAFT = false; // false: final rendering, true: disable Minkowski
$fn = 90;

// Globals
PLAY  = 0.7;
SPACE = PLAY/2;
ATOM  = 0.001;

// Transform: Grow object, useful to carve another object with a play margin
module grow_object() {
	if (DRAFT) {
		// do not grow, much faster
		children();
	} else {
		// grow size in each dimension (by a cube)
		minkowski() {
			children();
			cube([PLAY, PLAY, PLAY], true);
		}
	}
}

// Transform: Shift object in Y direction
module move(by) {
	translate([0, by, 0])
	children();
}

// Helper object: A hollow full buckle, to create the base object, as well as as a cavity
module full_buckle(offset, height, length, width) {
    cube([length - width, width - offset*2, height + ATOM*2], true);

    translate([length/2 - width/2, 0, 0])
    cylinder(d=width - offset*2, h=height + ATOM*2, center=true);

    translate([-length/2 + width/2, 0, 0])
    cylinder(d=width - offset*2, h=height + ATOM*2, center=true);
}

// Helper object: A hollow raw buckle
module hollow_buckle(height, wall_thickness, length, width) {
    translate([0, 0, height/2])
    difference() {
        full_buckle(0, height, length, width);
        full_buckle(wall_thickness, height + ATOM*2, length, width);
    }
}

// Object: The prong
module prong(wall_thickness, height, length, width, prong_size) {
	prong_width = prong_size;
	prong_width2 = prong_size * .8;
	hinge_radius = height/2;

	difference() {
		union() {
			translate([-prong_width/2, -width/2 + wall_thickness/2, 0])
			cube([prong_width, width, wall_thickness]);

			translate([-prong_width2/2, -width/2 + wall_thickness/2, 0])
			cube([prong_width2, width -wall_thickness*1.5 - SPACE, height*.9]);

			translate([-prong_width/2, -width/2 + hinge_radius/4.5 - hinge_radius, 0])
			cube([prong_width, hinge_radius*2, hinge_radius]);

			translate([-prong_width/2, -width/2 + hinge_radius/4.5, hinge_radius])
			rotate([0, 90, 0])
			cylinder(r=hinge_radius, h=prong_width);
		}

		translate([-prong_width/2-1, -width/2 + hinge_radius/4.5, hinge_radius])
		rotate([0, 90, 0])
		cylinder(r=hinge_radius/1.75, h=prong_width + 2);
	}
}

// Object: Buckle, carved to make room for the prong
module buckle(height, wall_thickness, length, width, prong_size) {
	difference() {
		hollow_buckle(height, wall_thickness, length, width);
		grow_object() prong(wall_thickness, height, length, width, prong_size);
	}
}

// Object: One whole object (buckle and prong)
module unit(height, wall_thickness, length, width, prong_size) {
	buckle(height, wall_thickness, length, width, prong_size);
	prong(wall_thickness, height, length, width, prong_size);
}

// Here it goes:
move(SMALL_WIDTH/2)
unit(SMALL_HEIGHT, SMALL_WALL_THICKNESS, SMALL_LENGTH, SMALL_WIDTH, SMALL_PRONG_SIZE);

move(SMALL_WIDTH + MEDIUM_WIDTH/2 + 5)
unit(MEDIUM_HEIGHT, MEDIUM_WALL_THICKNESS, MEDIUM_LENGTH, MEDIUM_WIDTH, MEDIUM_PRONG_SIZE);

move(SMALL_WIDTH + MEDIUM_WIDTH + BIG_WIDTH/2 +10)
unit(BIG_HEIGHT, BIG_WALL_THICKNESS, BIG_LENGTH, BIG_WIDTH, BIG_PRONG_SIZE);

move(SMALL_WIDTH + MEDIUM_WIDTH + BIG_WIDTH + BIGGER_WIDTH/2 +15)
unit(BIGGER_HEIGHT, BIGGER_WALL_THICKNESS, BIGGER_LENGTH, BIGGER_WIDTH, BIGGER_PRONG_SIZE);
