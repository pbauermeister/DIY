use <lib.scad>

GAP        = 1; // 1.2; // .75; // .5; //.33;
BASE       = 1.25;

SHIFT      = GAP; // GAP/2; // 0; //.2;

HEIGHT     = 4;
DIAMETER   = 160;

RADIUS_MAX = DIAMETER/2;
RADIUS_MIN = 1;

fidget(RADIUS_MIN, RADIUS_MAX, BASE, HEIGHT, SHIFT, GAP);
