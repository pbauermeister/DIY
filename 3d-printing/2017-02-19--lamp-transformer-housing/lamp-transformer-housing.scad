/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 *
 *
 * Unfinished attempt at designing a housing for a hanging lamp
 * transformer.
 *
 *	L = 480
 *	W = 60
 *	H = 40
 */


LENGTH = 200/4;
WIDTH = 40;
STEPS = 100/4;
AMPLITUDE = 3;

function x(i) = LENGTH/STEPS*i;

function z(x, y) = 0.00001+ (1 + sin(x * 5) * cos(x+ y * 5)) / 2;

module slice(j, offset, sink) {
    for(i = [0:STEPS]) {        
        x0 = x(i);
        x1 = x(i+1);
        y0 = j;
        y1 = j+1;

        z00 = z(x0, y0);
        z10 = z(x1, y0);
        z01 = z(x0, y1);
        z11 = z(x1, y1);
        
        h00 = offset + z00 * AMPLITUDE;
        h10 = offset + z10 * AMPLITUDE;
        h01 = offset + z01 * AMPLITUDE;
        h11 = offset + z11 * AMPLITUDE;
        
        CubePoints = [
          [ x0,  y0,  -sink ],  //0
          [ x1,  y0,  -sink ],  //1
          [ x1,  y1,  -sink ],  //2
          [ x0,  y1,  -sink ],  //3
          [ x0,  y0,  h00 -sink],  //4
          [ x1,  y0,  h10 -sink],  //5
          [ x1,  y1,  h11 -sink],  //6
          [ x0,  y1,  h01 -sink]]; //7
      
        CubeFaces = [
          [0,1,2,3],  // bottom face
          [4,5,1,0],  // front face
          [7,5,4],    // top triangle 1
          [7,6,5],    // top triangle 2
          [5,6,2,1],  // right face
          [6,7,3,2],  // back face
          [7,4,0,3]]; // left face

        polyhedron( CubePoints, CubeFaces );
    }
}

difference() {
    union() {
        // even slices are raised
        for(u = [0:2:WIDTH]) slice(u, 1, 0);

        // odd slices are sunken
        for(u = [1:2:WIDTH-1]) slice(u, 0, 1.25);
    }

    // clip
    translate([-1, -1, -5]) cube([LENGTH+20, WIDTH+2, 5]);
}
