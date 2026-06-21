use <../chamferer.scad>

chamferer(50, fn=9, ay=90, ax2=180)
cube(100, center=true);

translate([200, 0, -100])
//rotate([45, 35.2643, 0])
rotate([180, 0, 0])
rotate([0, 90, 0])
sphere(100, $fn=9);
//rotate([0, -90, 0])
//sphere(100, $fn=5);