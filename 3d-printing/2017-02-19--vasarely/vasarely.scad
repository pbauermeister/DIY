FACTOR = 0.1;

module bar(x0, y0, x1, y1, z00, z10, z11, z01) {
    CubePoints = [
      [ x0*FACTOR,  y0*FACTOR,  0 ],  //0
      [ x1*FACTOR,  y0*FACTOR,  0 ],  //1
      [ x1*FACTOR,  y1*FACTOR,  0 ],  //2
      [ x0*FACTOR,  y1*FACTOR,  0 ],  //3
      [ x0*FACTOR,  y0*FACTOR,  z00*FACTOR ],  //4
      [ x1*FACTOR,  y0*FACTOR,  z10*FACTOR ],  //5
      [ x1*FACTOR,  y1*FACTOR,  z11*FACTOR ],  //6
      [ x0*FACTOR,  y1*FACTOR,  z01*FACTOR ]]; //7
  
    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,5,4],    // top 1
      [7,6,5],    // top 2
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left
 
    polyhedron( CubePoints, CubeFaces ); 
}

function z(x, y) = (1.2 - cos(x) * cos(y)) * 20;

module plot(x, y, radius, amplitude) {
    valx = sin(x) * cos(y);
    valy = cos(x) * sin(y);
        
    dispx = (1-valx) * amplitude;
    dispy = (1-valy) * amplitude;

    h = 1 - cos(x) * cos(y);
    radius = radius * pow(h+1, 1.6);
        
    x0 = x-radius + dispx;
    x1 = x+radius + dispx;
    y0 = y-radius + dispy;
    y1 = y+radius + dispy;

    bar(x0, y0, x1, y1, 
        z(x0,  y0),
        z(x1,  y0),
        z(x1,  y1),
        z(x0,  y1));
}

SIZE = 360 * 1.5;
PERIOD = 45/2;
AMPL = 30;
PHASE = 0;

cube([(SIZE+PERIOD*2.5)*FACTOR, (SIZE+PERIOD*2.5)*FACTOR, 1.001]);

translate([0,0,1])
union() {
    for(y = [PHASE:PERIOD:SIZE-PERIOD]) {
        for(x = [0:PERIOD:SIZE]) {
            plot(x, y, PERIOD/10, AMPL);
        }
    }

    for(x = [PHASE:PERIOD:SIZE-PERIOD]) {
        for(y = [0:PERIOD:SIZE]) {
            plot(x, y, PERIOD/10, AMPL);
        }
    }
}