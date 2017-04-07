
SPAN   = 360 * 1.5; // angular span
PERIOD = 45/1.5; // angular increment
AMPL   = 30; // distortion
HEIGHT = 12;
BASE_THICKNESS = 1;

SIZE = 80;
BASE_THICKNESS = 0.5;

BASE_SPAN = SPAN + PERIOD*2.5;
FACTOR = SIZE / BASE_SPAN;
PHASE  = 30;

// create one bar
module makeBar(x00, y00, z00,
               x01, y01, z01,
               x11, y11, z11,
               x10, y10, z10) {
    points = [
      [x00, y00, 0],  //0
      [x01, y01, 0],  //1
      [x11, y11, 0],  //2
      [x10, y10, 0],  //3
      [x00, y00, z00],  //4
      [x01, y01, z01],  //5
      [x11, y11, z11],  //6
      [x10, y10, z10]]; //7
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
function z(x, y) = FLAT ? FLAT : (1.2 - cos(x-PHASE) * cos(y-PHASE)) * HEIGHT + 1;

// lateral distortion
function dx(x, y, a) = (1 - sin(x) * cos(y)) * a;
function dy(x, y, a) = (1 - cos(x) * sin(y)) * a;

// compute one bar
module plotBar(x, y, radius, amplitude) { 
    // base thickness; the less distortion, the thicker
    radius = radius * (2.5 + pow(2 - cos(x) * cos(y), 1.43)/2.45);

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
    makeBar(x00*FACTOR, y00*FACTOR, z(x00, y00)*FACTOR,
            x01*FACTOR, y01*FACTOR, z(x01, y01)*FACTOR,
            x11*FACTOR, y11*FACTOR, z(x11, y11)*FACTOR,
            x10*FACTOR, y10*FACTOR, z(x10, y10)*FACTOR);
}

// create a base
cube([SIZE, SIZE, BASE_THICKNESS + 0.001]);

// raise matrix by 1 mm to sit on base
translate([0, 0, BASE_THICKNESS])

// sweep matrix
for(y = [0:PERIOD:SPAN]) {
    for(x = [0:PERIOD:SPAN]) {
        plotBar(x, y, PERIOD/10, AMPL);
    }
}
