$fn = 4;

SIZE = 140;
HEIGHT = 100;
//THICKNESS = 0.8;
//STEPS = 40;
//PLANES = 20;

SPAN = 360/2;
AMPLITUDE = 12;

WALL_THICKNESS = 0.4;

FAKE = 0;


$fn = 20;
STEPS = 25;
PLANES = 10;
THICKNESS = 2;
AMPLITUDE = 6;
OFFSET = 1/2;

PLANES = 14;
STEPS = 35;
THICKNESS = 1.5;
AMPLITUDE = 8;
OFFSET = 3/4;

function f1(t, u, v) = (sin(u*SPAN*2 + u*v*SPAN*2))* AMPLITUDE + (t+u) * SIZE ;
function f2(t, u, v) = (cos(u*SPAN*2 + u*v*SPAN*2))* AMPLITUDE*0 + (t-u/2-v/2) * SIZE ;

function d(u, v) = sqrt((u-0.5)*(u-0.5) + (v-0.5)*(v-0.5)*0 + v*v) * 360*6;
function sinc(u, v) = d(u,v) == 0 ? 1 : sin(d(u,v)) / d(u,v);
function f(t, u, v) = sinc(u,v) * AMPLITUDE*200*t + t*SIZE + SIZE/PLANES*OFFSET;

//function f(t, u, v) = sinc(u,0) * AMPLITUDE*200*t + t*SIZE;



/**
 * Given 4 points, generate a plate consisting of 2 tiangles, and of thickness TICKNESS.
 */
module mesh(x1, y1, z1,
            x2, y2, z2,
            x3, y3, z3,
            x4, y4, z4) {
    // triangle 1
    hull() {
        translate([x1, y1, z1]) sphere(r=THICKNESS, true);
        translate([x2, y2, z2]) sphere(r=THICKNESS, true);
        translate([x3, y3, z3]) sphere(r=THICKNESS, true);
    }

    // triangle 1
    hull() {
        translate([x4, y4, z4]) sphere(r=THICKNESS, true);
        translate([x2, y2, z2]) sphere(r=THICKNESS, true);
        translate([x3, y3, z3]) sphere(r=THICKNESS, true);
    }
}

module mesh(x1, y1, z1,
            x2, y2, z2,
            x3, y3, z3,
            x4, y4, z4) {
    translate([x1, y1, z1])
        scale([THICKNESS, THICKNESS, THICKNESS]) 
        sphere(r=1, true);
}

/**
 * Generate several planes.
 * which_fn = 1..2 (calling resp f1 and f2)
 */
module make_planes() {
    for (t = [-1:1/PLANES:2-1/PLANES]) {
        for (i = [-1/STEPS:1/STEPS:1+1/STEPS]) {
            for (j = [-1/STEPS:1/STEPS: 1+1/STEPS]) {
//            for (j = [-1/STEPS:1/STEPS: /*1*/ 0]) {
                x1 = i * SIZE;
                y1 = j * SIZE;
                x2 = (i+1/STEPS) * SIZE;
                y2 = (j+1/STEPS) * SIZE;
//                y2 = SIZE;

                u1 = i;
                v1 = j;
                u2 = (i+1/STEPS);
                v2 = (j+1/STEPS);

                mesh(x1, y1, f(t, u1, v1),
                     x2, y1, f(t, u2, v1),
                     x1, y2, f(t, u1, v2),
                     x2, y2, f(t, u2, v2)
                );
            }
        }
    }
}

module make_walls() {
    for (t = [0:1/PLANES:1]) {
        x = t * SIZE;
        translate([x, 0, 0])
        cube([WALL_THICKNESS, SIZE, SIZE]);
    }
}

module make_cylinders() {
    translate([SIZE/2, 0, 0])
    {
        for (t = [1/PLANES:1/PLANES:1.5]) {
            r = t * SIZE;
            difference() {
                cylinder($fn=90, r=r, h=SIZE);
                cylinder($fn=90, r=r-WALL_THICKNESS, h=SIZE);
            }
        }

        cylinder($fn=4, r=WALL_THICKNESS, h=SIZE);
    }
}

module object() {
    if (FAKE)  cube([SIZE, SIZE, HEIGHT]);

    else intersection() {
        union() {
            difference() {
                cube([SIZE, SIZE, HEIGHT]);
                make_planes();
            }
//            make_planes();
            make_cylinders();
        }
        cube([SIZE, SIZE, HEIGHT]);
    }
}

module object() {
    intersection() {
        difference() {
            cube([SIZE, SIZE, HEIGHT]);
            make_planes();
        }
        cube([SIZE, SIZE, HEIGHT]);
    }
}

//CUPS_WALL = 10;
CUPS_HEIGHT = 40;
CUPS_CAVITY_RADIUS = 65/2;
CUPS_MARGIN = 5;
CUPS_ELEVATION = 15;
CUPS_CAVITY_CYLINDER_DISP = 5;

module cylinder_o() {
    disp = CUPS_CAVITY_CYLINDER_DISP;
    hull() {
        translate([disp, 0, 0])
        cylinder($fn=36, r=CUPS_CAVITY_RADIUS, h=SIZE);

        translate([-disp, 0, 0])
        cylinder($fn=36, r=CUPS_CAVITY_RADIUS, h=SIZE);
    }
}

module cups_milling() {
//    // space under
//    translate([0, CUPS_WALL, 0])
//    cube([SIZE, SIZE - 2*CUPS_WALL, CUPS_HEIGHT]);

    d1 = SIZE / 4;
    d2 = SIZE * 3/4;
    d3 = SIZE / 2;

    translate([0, 0, CUPS_ELEVATION])
    {
        translate([d3, d3, 0]) cylinder($fn=36, r=CUPS_CAVITY_RADIUS, h=SIZE);
        translate([d1, d1+CUPS_MARGIN, 0]) cylinder_o();
        translate([d2, d1+CUPS_MARGIN, 0]) cylinder_o();
        translate([d1, d2-CUPS_MARGIN, 0]) cylinder_o();
        translate([d2, d2-CUPS_MARGIN, 0]) cylinder_o();
    }


}

translate([-SIZE/2, -SIZE/2, -SIZE/2])
difference() {
    object();
    cups_milling();
}

