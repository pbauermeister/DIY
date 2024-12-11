use <mixer-holder.scad>

part1();

// supports / blockers

THICKNESS       =  30;
WIDTH           =  85;

translate([-8.5 -6.5, 84.5, 16.8])
rotate([-45, 0, 0])
cube([24, 8, .5]);

translate([-8.5 -6.5, 84.5-3.2, 16.8])
rotate([-45, 0, 0])
cube([24, 8, .5]);

translate([-THICKNESS*1.20, 0, 0])
cube([5, WIDTH, .3]);


