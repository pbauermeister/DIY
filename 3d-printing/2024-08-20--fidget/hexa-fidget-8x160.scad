use <lib.scad>

GAP        = 1; // 1.5;
BASE       = 1.25;

HEIGHT     = 8;
SHIFT      = HEIGHT / 4; // 2

_DIAMETER   = 30;
DIAMETER  = 160;

RADIUS_MAX = DIAMETER/2;
RADIUS_MIN = 3.5; //3;

fidget(RADIUS_MIN, RADIUS_MAX, BASE, HEIGHT, SHIFT, GAP);
