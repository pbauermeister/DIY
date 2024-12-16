/* Lib generating hexagonal print-in-place fidgets. */

NB_SIDES     = 6;
ATOM         = .01;
DO_CROSS_CUT = $preview;

// Lower slanted part of a wall
module side_bottom(base, height, shift) {
    hull() {
        cube([ base, ATOM, ATOM ]);
        translate([ shift, 0, height / 2 ])
        cube([ base, ATOM, ATOM ]);
    }
}

// Upper slanted part of a wall
module side_top(base, height, shift) {
    hull() {
        translate([ 0, 0, height ])
        cube([ base, ATOM, ATOM ]);
        translate([ shift, 0, height / 2 ])
        cube([ base, ATOM, ATOM ]);
    }
}

// Complete wall
module piece(radius, base, height, shift, allow_cut = true) {
    n = DO_CROSS_CUT && allow_cut ? NB_SIDES / 2 - 1 : NB_SIDES - 1;
    for (i = [0:n]) {
        hull() {
            rotate([ 0, 0, 360 / NB_SIDES * i ])
            translate([ radius, 0, 0 ])
            side_bottom(base, height, shift);

            rotate([ 0, 0, 360 / NB_SIDES * (i + 1) ])
            translate([ radius, 0, 0 ])
            side_bottom(base, height, shift);
        }

        hull() {
            rotate([ 0, 0, 360 / NB_SIDES * i ])
            translate([ radius, 0, 0 ])
            side_top(base, height, shift);

            rotate([ 0, 0, 360 / NB_SIDES * (i + 1) ])
            translate([ radius, 0, 0 ])
            side_top(base, height, shift);
        }
    }
}

// Complete fidget with concentric walls
module fidget(radius_min, // exact minimum radius
              radius_max, // maximum radius (may not be exactly met)
              base,       // thickness of wall touching floor
              height,     // height of wall
              shift,      // lateral wall shift, to obtain a slant
              gap,        // lateral space between walls
              filled_center = false,    // fill the center piece or not
              only_outer_frame = false, // generate only the outmost wall
) {
    step = base + gap;
    n_pieces = floor((radius_max - radius_min) / step); // how many walls
    outer_r = radius_min + step * n_pieces; // outer radius (not counting 2x shift)

    rotate([ 0, 0, 30 ]) {
        if (only_outer_frame) {
            piece(outer_r, base, height, shift, false);
        } else {
            for (r = [radius_min:step:radius_max]) {
                if (r == radius_min && filled_center) {
                    hull() piece(r, base, height, shift);
                } else {
                    piece(r, base, height, shift);
                }
            }
        }
    }
}

// Example

GAP        = 1;
BASE       = 1.25;
SHIFT      = GAP;
HEIGHT     = 4;
DIAMETER   = 140;
RADIUS_MAX = DIAMETER / 2;
RADIUS_MIN = 1;

fidget(RADIUS_MIN, RADIUS_MAX, BASE, HEIGHT, SHIFT, GAP, true);

% fidget(RADIUS_MIN, RADIUS_MAX, BASE, HEIGHT, SHIFT, GAP, true, true);
