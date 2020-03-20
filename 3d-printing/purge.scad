
//cube([15, 15, 0.5]);
thickness = 0.4;
height = 0.3;
ATOM = 0.001;

length = 40;
width = 30;

t1 = length < width ? thickness : thickness*2;
t2 = length > width ? thickness : thickness*2;

for(x=[0:length])
    for(y=[0:width])
        translate([x, y, 0])
        cube([t1, t2, height]);
        
translate([0, 0, height-ATOM])
cube([length+t1, width+t2, height]);