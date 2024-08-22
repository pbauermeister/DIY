include <defs.scad>

/* VSCode:
@ext:JulianGmp.openscad-formatter
{ BasedOnStyle: LLVM, UseTab: Never, ColumnLimit: 120,StatementMacros: [rotate,translate], IndentWidth: 4}
*/

SERVO_ARM_THICKNESS = 3 + 2 + 2;

HOLES_SPANS = [ 19, 27, 35 ];
HOLES_DIAMETER = 2;

HOLE_DIAMETER = 4 - .75;
HOLE_HEAD_HOLLOWING = 8 - 2 + 2;

RING_THICKNESS = 1 + .5 - 1;

FRAME_BAR_DIAMETER = 3.2 + .2;
FRAME_MARGIN = 3.5 + 3 - 3.5;

SHAVE = 2 + 1.5;

SHAFT_DIAMETER = 6 + .5;
AXIS_H_CONTACT = 3.5 + 1;
AXIS_H = 1.5;

SERVO_ARM_WIDTH = 10 + 3;
SERVO_ARM_SPAN = 42;

$fn = 30;

module envelope(extra_h = 0, shave) {
    union() {
        hull() {
           translate([ 0, extra_h ? .17 : -.45, 0 ])
            bar_fixture(extra_h = extra_h);

            translate([ 0, extra_h ? 1.19 : 0, 0 ])
            bar_fixture(extra_h = extra_h);
        }
        dh = extra_h ? FRAME_BAR_DIAMETER * .35 : FRAME_BAR_DIAMETER * .25;
        translate([ -SERVO_ARM_SPAN / 2, -SERVO_ARM_WIDTH, shave - dh ])
        cube([ SERVO_ARM_SPAN, SERVO_ARM_WIDTH * 2, SERVO_ARM_THICKNESS + extra_h ]);
    }
}

module arm0(extra_h = 0, shave, has_shaft = false, has_ring = true) {
    ring_thickness = has_ring ? RING_THICKNESS : 0;
    thickness = SERVO_ARM_THICKNESS + extra_h;
    difference() {
        // base body
        union() {
            hull() {
                d = SERVO_ARM_WIDTH / 2;
                for (i = [ -1, 1 ]) {
                    for (j = [ 0, 1 ]) {
                        translate([ i * (SERVO_ARM_SPAN / 2 - d / 2), -d / 2 + d * j, 0 ])
                        cylinder(d = d, h = thickness);
                    }
                }
                bar_fixture(extra_h = extra_h);
            }
            cylinder(d = SERVO_ARM_WIDTH, h = ring_thickness + thickness);
        }

        // arm holes
        spacing = (HOLES_SPANS[2] - HOLES_SPANS[1]) * .4;
        for (d = HOLES_SPANS) {
            for (i = [ -1, 1 ]) {
                for (j = [ -1, 0 ]) {
                    translate([ d / 2 * i, j * spacing, 0 ])
                    cylinder(d = HOLES_DIAMETER, h = thickness * 3, center = true);
                }
            }
        }

        // servo shaft
        if (has_shaft) {
            l = SHAFT_DIAMETER / sqrt(2);
            h = SERVO_ARM_THICKNESS + ring_thickness + extra_h - AXIS_H_CONTACT + ATOM;
            translate([ 0, 0, h ])
            for (a = [0:90 / 6:90]) {
                rotate([ 0, 0, a ])
                translate([ -l / 2, -l / 2, 0 ])
                cube([ l, l, AXIS_H_CONTACT ]);
            }
        }

        // central hole
        cylinder(d = HOLE_DIAMETER, h = (thickness + ring_thickness) * 3, center = true);

        // screw chamfer
        dh = 1;
        h = SERVO_ARM_THICKNESS + ring_thickness + extra_h - AXIS_H_CONTACT - (has_shaft ? AXIS_H : -AXIS_H * 2);
        cylinder(d = HOLE_HEAD_HOLLOWING, h = h * 2, center = true);

        // shave
        d = 3;
        difference() {
            hull() for (y = [ spacing * .25, -SERVO_ARM_WIDTH ]) {
                for (z = [ shave - d / 2, -d ]) {
                    translate([ 0, y, z ])
                    rotate([ 0, 90, 0 ])
                    cylinder(d = d, h = SERVO_ARM_SPAN * 2, center = true);
                }
            }
            translate([ 0, 0, shave ])
            cylinder(d = HOLE_HEAD_HOLLOWING - ATOM, h = HOLE_HEAD_HOLLOWING * 2, center = true);
        }
    }
}

module bar_case(extra_h = 0, hollowing = true) {
    l = SERVO_ARM_SPAN * (hollowing ? 2 : 1);
    margin = .5;

    translate([ 0, FRAME_MARGIN * 2.25, 0 ])
    hull() {
        translate([ 0, 0, SERVO_ARM_THICKNESS + extra_h ])
        rotate([ 0, 90, 0 ])
        cylinder(d = FRAME_BAR_DIAMETER - .5, h = l, center = true);

        translate([ 0, 0, SERVO_ARM_THICKNESS + extra_h - FRAME_BAR_DIAMETER / 2 - margin ])
        rotate([ 0, 90, 0 ])
        cylinder(d = FRAME_BAR_DIAMETER, h = l, center = true);

        xh = extra_h ? FRAME_BAR_DIAMETER : -.5;
        translate([ 0, 0, SERVO_ARM_THICKNESS + extra_h - FRAME_BAR_DIAMETER / 2 - margin - xh ])
        rotate([ 0, 90, 0 ])
        cylinder(d = FRAME_BAR_DIAMETER, h = l, center = true);
    }
}

module bar_fixture(w = FRAME_BAR_DIAMETER + FRAME_MARGIN, extra_h = 0) {
    difference() {
        minkowski() {
            bar_case(extra_h, hollowing = false);

            rotate([ 0, 90, 0 ])
            cylinder(r = FRAME_MARGIN, h = ATOM);
        }

        translate([ 0, 0, SERVO_ARM_THICKNESS + extra_h ])
        cylinder(r = 1000, h = FRAME_MARGIN + FRAME_BAR_DIAMETER);
    }
}

module arm(extra_h = 0, shave, has_shaft = false, has_ring = true) {
    intersection() {
        arm0(extra_h, shave, has_shaft, has_ring);
        envelope(extra_h, shave);
    }
}

module passive_arm() {
    difference() {
        arm(shave = SHAVE, has_shaft = false, has_ring = true);
        bar_case();
    }
    //%cube([1000, 7, 1]);
}

module servo_arm() {
    difference() {
        arm(shave = SHAVE + 2, extra_h = FRAME_BAR_DIAMETER, has_shaft = true, has_ring = false);
        bar_case(extra_h = FRAME_BAR_DIAMETER);
    }
}

module cut() {
    intersection() {
        children();
        cube(1000);
    }
}

rotate([ 0, -90, 0 ])
// cut()
passive_arm();

translate([ 0, -35, 0 ])
rotate([ 0, 0, 180 ])
// cut()
rotate([ 0, 90, 0 ])
servo_arm();
