use <lib.scad>

GAP               = 1;
BASE              = 1.25;
HEIGHT            = 8;
SHIFT             = HEIGHT / 4;
DIAMETER          = 160;
RADIUS_MAX        = DIAMETER / 2;
RADIUS_MIN        = 3.5;

//// for exporting (used in feet)

module make_fidget() { fidget(RADIUS_MIN, RADIUS_MAX, BASE, HEIGHT, SHIFT, GAP); }

function get_diameter() = DIAMETER;
function get_height() = HEIGHT;

//// fidget

make_fidget();
