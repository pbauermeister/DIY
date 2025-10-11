use <../chamferer.scad>

WIDTH  = 170;
HEIGHT =  60;
WALL   =   8;

ATOM = 0.03;

rotate([0, 90, 0])
difference() {
    chamferer(5, "octahedron")
    cube([200, WIDTH, HEIGHT]);

    translate([-WALL, WALL, WALL])
    cube([200, WIDTH - WALL*2, HEIGHT-WALL + ATOM]);
}