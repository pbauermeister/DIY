use <lib.scad>

GAP        = 1.5; // 1.2; // .75; // .5; //.33;
BASE       = 1.25;

HEIGHT     = 5;
DIAMETER   = 160;

SHIFT      = HEIGHT/2; // GAP; // GAP/2; // 0; //.2;


RADIUS_MIN = 0;
_RADIUS_MAX = DIAMETER/2;
RADIUS_MAX = 30/2 +2;

fidget(RADIUS_MIN, RADIUS_MAX, BASE, HEIGHT, SHIFT, GAP);
