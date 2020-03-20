/*
 * Simulation of laser interference finges when
 * laser is split by a hair.
 *
 * P Bauermeister, 2018-11-04.
 */


PI = 3.1416;
R2D = 360 / 2 / PI;
R2D = 1;

// All sizes in mm

RESOLUTION = 0.25;

SCREEN_SIZE = 148 / 4;
HAIR_THICKNESS = 0.05;
HAIR_THICKNESS = 1/10;

SOURCE_DISTANCE = 300;
SOURCE_1 = [+HAIR_THICKNESS/2, SOURCE_DISTANCE, 0];
SOURCE_2 = [-HAIR_THICKNESS/2, SOURCE_DISTANCE, 0];

WAVELENGTH = 500e-9 * 1000; // mm

// draw source
translate(SOURCE_1) sphere(1);
translate(SOURCE_2) sphere(1);

function dist(p1, p2) = sqrt(pow(p2[0]-p1[0], 2) + pow(p2[1]-p1[1], 2) + pow(p2[2]-p1[2], 2));

for(x=[-SCREEN_SIZE/2 : RESOLUTION : SCREEN_SIZE/2]) {
    echo(x);
	for(z=[-SCREEN_SIZE/2 : RESOLUTION : SCREEN_SIZE/2]) {
		screen_voxel = [x, 0, z];

		distance_1 = dist(screen_voxel, SOURCE_1);
	    luma_1 = sin(distance_1 * R2D / WAVELENGTH) /2;

		distance_2 = dist(screen_voxel, SOURCE_2);
	    luma_2 = sin(distance_2 * R2D / WAVELENGTH) /2;

		luma = pow(luma_1 + luma_2, 2);

		if(luma > 0.5)
    			color("red")
			translate([0, -RESOLUTION, 0])
			translate(screen_voxel)
			cube(RESOLUTION, true);
	}
}

echo("Fringe disrance", WAVELENGTH * SOURCE_DISTANCE / HAIR_THICKNESS);
