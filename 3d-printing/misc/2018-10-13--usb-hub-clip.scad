// P. Bauermeister, 2017-03-04

inner_width = 72;
inner_length = 60;
vert_thickness = 1;
horiz_thickness = 2;
height = 3;
nook = 1;
ATOM = 0.001;

difference() {
	// positive plate
	translate([0, 0, height/2])
	cube([inner_width + horiz_thickness*2, inner_length + horiz_thickness, height], true);

	// plate cavity
	translate([0, horiz_thickness/2 + ATOM, nook/2 + vert_thickness])
	cube([inner_width, inner_length, nook], true);

	// pyramid cavity
	a = inner_width/2;
	b = inner_length/2;
	translate([0, horiz_thickness/2 + ATOM, vert_thickness + nook - ATOM])
	// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids#polyhedron
    polyhedron(
		points = [  // the four points at base
					[a, b*2, 0],
					[a, -b ,0],
					[-a, -b, 0],
					[-a ,b*2 ,0],
					// the apex point 
					[0, 0, (a+b)*.7]
				 ],
		faces =  [  // each triangle side
					[0, 1, 4],
					[1, 2, 4],
					[2, 3, 4],
					[3, 0, 4],
					// two triangles for square base
					[1, 0, 3],
					[2, 1, 3]
				 ]
    );
}