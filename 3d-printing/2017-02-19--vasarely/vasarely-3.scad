
SIZE   = 65; // in mm
SPAN   = 360 * 1.5; // angular span
PERIOD = 45; // angular increment
AMPL   = 30; // distortion
HEIGHT = 20;
FLAT   = 4*0; // if 0: not flat; else, defines thicknes of raised layer
BASE_THICKNESS = 1;
OFFSET = 0;

SIZE = 40;
RATIO = 2;
SPAN   = 360 *.75;
BASE_THICKNESS = 5;
THICKNESS = 10;
HEIGHT = 2;
OFFSET = 2;

BASE_SPAN = SPAN + PERIOD*2.5;
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
function z(x, y, thickness) = thickness;

// lateral distortion
function dx(x, y, a) = (1 - sin(x) * cos(y)) * a;
function dy(x, y, a) = (1 - cos(x) * sin(y)) * a;

// compute one bar
module plotBar(x, y, radius, thickness) { 
    // base thickness; the less distortion, the thicker
    radius = radius>0 ? radius * pow(2 - cos(x) * cos(y), 1.4) : -radius;

    // base corners
    x0 = x-radius;
    x1 = x+radius;
    y0 = y-radius;
    y1 = y+radius;

    // add lateral distortion to base corners
    x00 = x0 + dx(x0, y0, AMPL);    y00 = y0 + dy(x0, y0, AMPL);
    x01 = x0 + dx(x0, y1, AMPL);    y01 = y1 + dy(x0, y1, AMPL);
    x10 = x1 + dx(x1, y0, AMPL);    y10 = y0 + dy(x1, y0, AMPL);
    x11 = x1 + dx(x1, y1, AMPL);    y11 = y1 + dy(x1, y1, AMPL);

    // create bar
    makeBar(x00, y00, z(x00, y00, thickness),
            x01, y01, z(x01, y01, thickness),
            x11, y11, z(x11, y11, thickness),
            x10, y10, z(x10, y10, thickness));
}

// create a base
//cube([SIZE, SIZE, BASE_THICKNESS + 0.001]);

// raise matrix by 1 mm to sit on base
//translate([0, 0, BASE_THICKNESS])

// sweep matrix
for(y = [0:PERIOD:SPAN]) {
    for(x = [0:PERIOD:SPAN*RATIO]) {
        plotBar(x, y, PERIOD/10, THICKNESS);
    }
}


for(y = [0:PERIOD:SPAN]) {
    for(x = [0:PERIOD/10:SPAN*RATIO]) {
        plotBar(x, y, -3, BASE_THICKNESS);
    }
}

for(x = [0:PERIOD:SPAN*RATIO]) {
    for(y = [0:PERIOD/10:SPAN]) {
        plotBar(x, y, -3, BASE_THICKNESS);
    }
}
