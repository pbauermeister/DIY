// Density: 40%
// Quality: Draft

include <definitions.scad>
use <parts.scad>

module all() {
    diagonal_end(flat=true);

    resize([0, 0, REST_HEIGHT])
    intersection() {
        resize([0, 0, PIPE_DIAMETER_OUTER*100000])
        translate([0, 0, -REST_HEIGHT])
        diagonal_end_rest_border();
        cube([PIPE_DIAMETER_OUTER*2, PIPE_DIAMETER_OUTER, .001], true);
    }
}

intersection() {
    all();

%    translate([0, 0, REST_HEIGHT-3])
    cube([200, 200, 1.5], true);
}