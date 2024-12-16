use <lib.scad>

GAP               = 1;
BASE              = 1.25;
SHIFT             = GAP;
HEIGHT            = 4;
DIAMETER          = 140;
RADIUS_MAX        = DIAMETER / 2;
RADIUS_MIN        = 1;
FILLED_CENTER     = true;

fidget(RADIUS_MIN, RADIUS_MAX, BASE, HEIGHT, SHIFT, GAP, FILLED_CENTER);
