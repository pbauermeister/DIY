SIZE   = 60; // in mm
SPAN   = 180 * 0.5; // angular span
PERIOD = 90/5; // angular increment
THICKNESS = 0.5;

XTURN = 120;
XTURN = 45*1.5;

FACTOR = SIZE / 2 / SPAN;

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
      [x00*FACTOR, y00*FACTOR, z00],  //4
      [x01*FACTOR, y01*FACTOR, z01],  //5
      [x11*FACTOR, y11*FACTOR, z11],  //6
      [x10*FACTOR, y10*FACTOR, z10]]; //7
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

// cartesian -> polar
function r(x, y) = sqrt(x*x + y*y);
function a(x, y) = x >0         ? atan(y/x)        : (
                   x <0 && y>=0 ? atan(y/x) + 180  : (
                   x <0 && y <0 ? atan(y/x) - 180  : (
                   x==0 && y >0 ?             180  : (
                   x==0 && y==0 ?            -180  :
                                                0
                   ))));

// polar -> distorsion -> cartesian
function newA(x, y) = a(x, y) + (r(x, y)>90 ? 0 : cos(r(x, y)) * XTURN);
function newX(x, y) = r(x, y) * cos(newA(x, y));
function newY(x, y) = r(x, y) * sin(newA(x, y));

// compute one bar
module plotBar(x, y, radius, thickness) { 
    // base corners
    x0 = x-radius;
    x1 = x+radius;
    y0 = y-radius;
    y1 = y+radius;

    // add lateral distortion to base corners
    x00 = newX(x0, y0);    y00 = newY(x0, y0);
    x01 = newX(x0, y1);    y01 = newY(x0, y1);
    x11 = newX(x1, y1);    y11 = newY(x1, y1);
    x10 = newX(x1, y0);    y10 = newY(x1, y0);
    
    // create bar
    makeBar(x00, y00, thickness,
            x01, y01, thickness,
            x11, y11, thickness,
            x10, y10, thickness);
}



union() {
    for(y = [-SPAN:PERIOD/2:SPAN]) {
        for(x = [-SPAN:PERIOD/12:SPAN]) {
            plotBar(x, y, PERIOD/10, THICKNESS);
        }
    }

    for(x = [-SPAN:SPAN*2:SPAN]) {
        for(y = [-SPAN:PERIOD/12:SPAN]) {
            plotBar(x, y, PERIOD/10, THICKNESS);
        }
    }

}