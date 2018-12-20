D = 90;
THICKNESS = 1;

/*
 * Generate a segment
 */
module segment(x1, y1, x2, y2) {
    hull() {
        translate([x1, y1, 0]) cylinder(d=THICKNESS);
        translate([x2, y2, 0]) cylinder(d=THICKNESS);
    }
}

/*
 * Generate mesh
 */
module mesh() {
    space = 20;
    step = 5;

    // X mesh lines
    for (y=[-D:space:D]) {
        for (x=[-D:step:D-step]) {
            segment(x, y, x+step, y);
        }
    }

    // Y mesh lines
    for (y=[-D:space:D]) {
        for (x=[-D:step:D-step]) {
            segment(y, x, y, x+step);
        }
    }
}

mesh();
