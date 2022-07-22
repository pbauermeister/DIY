
FRAME_SIDE      = 208;
FRAME_THICKNESS =   8/2; // to 9
FRAME_HEIGHT    =  15;

TOLERANCE = 0.15 * 10;
CHAMFER_ANGLE = 45;

ATOM = 0.01;

module base_frame() {
    difference() {
        cube([FRAME_SIDE, FRAME_SIDE, FRAME_HEIGHT], center=true);
        cube([FRAME_SIDE-FRAME_THICKNESS*2, FRAME_SIDE-FRAME_THICKNESS*2, FRAME_HEIGHT+ATOM*2], center=true);
    }
}

module piece(i) {
    intersection() {
        base_frame();

        if (i%2==0) {
            a = -CHAMFER_ANGLE;
            union() {
                translate([TOLERANCE, FRAME_SIDE/2, 0])
                rotate([0, -a/2, -a])
                translate([0, -FRAME_SIDE/2, -FRAME_SIDE/2])
                cube([FRAME_SIDE/2, FRAME_SIDE, FRAME_SIDE]);

                translate([FRAME_SIDE/2, TOLERANCE, 0])
                rotate([-a/2, 0, a])
                translate([-FRAME_SIDE/2, 0, -FRAME_SIDE/2])
                cube([FRAME_SIDE, FRAME_SIDE, FRAME_SIDE]);
            }
        }
        else {
            a = -CHAMFER_ANGLE;
            union() {
                translate([TOLERANCE, FRAME_SIDE/2, 0])
                rotate([0, -a/2, a])
                translate([0, -FRAME_SIDE/2, -FRAME_SIDE/2])
                cube([FRAME_SIDE/2, FRAME_SIDE, FRAME_SIDE]);

                translate([FRAME_SIDE/2, TOLERANCE, 0])
                rotate([-a/2, 0, -a])
                translate([-FRAME_SIDE/2, 0, -FRAME_SIDE/2])
                cube([FRAME_SIDE, FRAME_SIDE/2, FRAME_SIDE]);
            }
        }
    }
}

module make(which) {
    if (which == 1) {
        // one
        piece(1);
    }
    else if (which == 2.1) {
        d = FRAME_THICKNESS + 5;
        piece(0);
        translate([d, d, 0]) piece(0);
    }
    else if (which == 2.2) {
        d = FRAME_THICKNESS + 5;
        rotate([0, 0, 90]) piece(1);
        translate([-d, d, 0])  rotate([0, 0, 90]) piece(1);
    }
    else if (which == 4) {
        // four, cannot print
        for (i=[0:3]) {
            d = (FRAME_THICKNESS) * i;
            rotate([0, 0, 90*i])
            piece(i);
        }
    }
}