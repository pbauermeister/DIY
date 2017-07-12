/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 *
 * Vasarely-inspired elevation map.
 */

$fn = 180;

SIZE   = 65; // in mm
SPAN   = 360; // angular span
PERIOD = 45/2; // angular increment
AMPL   = 30; // distortion
HEIGHT = 15;
FLAT   = 4*0; // if 0: not flat; else, defines thicknes of raised layer
BASE_THICKNESS = 1;

SIZE = 80;
BASE_THICKNESS = 0.5;

BASE_SPAN = SPAN + PERIOD*3.2;
FACTOR = SIZE / BASE_SPAN;
PHASE  = 30;

// create one bar
module makeBar(x00, y00, z00,
               x01, y01, z01,
               x11, y11, z11,
               x10, y10, z10) {
    points = [
      [x00*FACTOR, y00*FACTOR, 0],  //0
      [x01*FACTOR, y01*FACTOR, 0],  //1
      [x11*FACTOR, y11*FACTOR, 0],  //2
      [x10*FACTOR, y10*FACTOR, 0],  //3
      [x00*FACTOR, y00*FACTOR, z00*FACTOR],  //4
      [x01*FACTOR, y01*FACTOR, z01*FACTOR],  //5
      [x11*FACTOR, y11*FACTOR, z11*FACTOR],  //6
      [x10*FACTOR, y10*FACTOR, z10*FACTOR]]; //7
    faces = [
      [0, 1, 2, 3],  // bottom face
      [4, 5, 1, 0],  // front face
      [7, 5, 4],     // top triangle
      [7, 6, 5],     // top triange
      [5, 6, 2, 1],  // right face
      [6, 7, 3, 2],  // back face
      [7, 4, 0, 3]]; // left face
    polyhedron(points, faces); 
}

// altitude
function z(x, y) = FLAT ? FLAT : (1.2 - cos(x-PHASE+y/3) * cos(y-PHASE)) * HEIGHT + 2;

// lateral distortion
function dx(x, y, a) = (1 - sin(x+y/3) * cos(y)*.75) * a;
function dy(x, y, a) = (1 - cos(x+y/3) * sin(y)*.75) * a;

// compute one bar
module plotBar(x, y, radius, amplitude) { 
    // base thickness; the less distortion, the thicker
    radius = radius * pow(2 - cos(x) * cos(y), 0.29)*2.7;

    // base corners
    x0 = x-radius;
    x1 = x+radius;
    y0 = y-radius;
    y1 = y+radius;

    // add lateral distortion to base corners
    x00 = x0 + dx(x0, y0, amplitude);    y00 = y0 + dy(x0, y0, amplitude);
    x01 = x0 + dx(x0, y1, amplitude);    y01 = y1 + dy(x0, y1, amplitude);
    x10 = x1 + dx(x1, y0, amplitude);    y10 = y0 + dy(x1, y0, amplitude);
    x11 = x1 + dx(x1, y1, amplitude);    y11 = y1 + dy(x1, y1, amplitude);

    // create bar
    makeBar(x00, y00, z(x00, y00),
            x01, y01, z(x01, y01),
            x11, y11, z(x11, y11),
            x10, y10, z(x10, y10));
}

module base(thickness) {
    difference() {
        cube([SIZE, SIZE, thickness]);
        translate([73, 73, 0]) cylinder( 20, 2.4, 2.4,true);
    }
}

scale([6.5/8, 6.5/8, 1])
{
    base(BASE_THICKNESS + 0.001);

    // raise matrix by 1 mm to sit on base
    translate([0, 0, BASE_THICKNESS])
    // sweep matrix
    for(y = [0:PERIOD:SPAN]) {
        for(x = [0:PERIOD:SPAN]) {
            plotBar(x, y, PERIOD/10, AMPL);
        }
    }
}
