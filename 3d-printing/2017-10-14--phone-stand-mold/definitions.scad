S2 = sqrt(2);
ATOM = 0.001;

PIPE_THICKNESS = 2.5;
PIPE_DIAMETER_INNER = 102;
PIPE_DIAMETER_OUTER = PIPE_DIAMETER_INNER + 2 * PIPE_THICKNESS;
PIPE_MARGIN = 10;
PIPE_HEIGHT = 131; // please manually adjust

WALL_THICKNESS = 3;
WALL_THIN_THICKNESS = 1.5;
REST_HEIGHT = 10;
REST_LENGTH = 25;
BASE_MIN_THICKNESS = 25;
PLUG_GROVE_WIDTH = 12;
CABLE_GROVE_WIDTH = 7;
CABLE_GROVE_HEIGHT = 5;

CAVITY_WIDTH = 20;
CAVITY_SHORTAGE = 35;
CAVITY_HEIGHT = 30;
MARK_THICKNESS = 0.5;
STOP_THICKNESS = 2;

SUPPORT_THICKNESS = 0.5;

$fn = 90;

module barrel(outer_radius, inner_radius, height) {
    scale([1, 1, height])
    difference() {
        cylinder(r=outer_radius);
        if (inner_radius)
            translate([0, 0, -0.5]) scale([1, 1, 2])
            cylinder(r=inner_radius);
    }
}

module trapezoid(size, center) {
//    cube(size, center);
    x = size[0];
    y = size[1];
    z = size[2];
    d = z / 20; // conicity
    
    points = [
    [ 0,  0,  0 ],  //0
    [ x,  0,  0 ],  //1
    [ x,  y,  0 ],  //2
    [ 0,  y,  0 ],  //3
    [ 0,  d,  z ],  //4
    [ x,  d,  z ],  //5
    [ x,  y-d,  z ],  //6
    [ 0,  y-d,  z ]]; //7

    faces = [
    [0,1,2,3],  // bottom
    [4,5,1,0],  // front
    [7,6,5,4],  // top
    [5,6,2,1],  // right
    [6,7,3,2],  // back
    [7,4,0,3]]; // left

    if(center)
        translate([-x/2, -y/2, -z/2])
        polyhedron(points, faces);
    else
        polyhedron(points, faces);
}