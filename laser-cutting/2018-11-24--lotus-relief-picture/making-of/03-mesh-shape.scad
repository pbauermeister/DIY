ATOM = 0.01;
D = 90;
THICKNESS = 1;

/*
 * Generate a segment
 */
module seg(x1, y1, x2, y2) {
    hull() {
        translate([x1, y1, 0]) cylinder(d=THICKNESS);
        translate([x2, y2, 0]) cylinder(d=THICKNESS);
    }
}

/*
 * Generate distored mesh
 */
module mesh() {
    space = 20;
    step = 5;

    // X mesh lines
    for (y=[-D:space:D]) {
        for (x=[-D:step:D-step]) {
            x0 = x;
            y0 = y;
            x1 = x+step;
            y1 = y;
            seg(x0, y0, x1, y1);
        }
    }

    // Y mesh lines
    for (y=[-D:space:D]) {
        for (x=[-D:step:D-step]) {
            x0 = x;
            y0 = y;
            x1 = x+step;
            y1 = y;
            seg(y0, x0, y1, x1);
        }
    }
}

mesh();
