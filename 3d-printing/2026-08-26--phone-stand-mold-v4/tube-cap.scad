PIPE_DIAMETER_INNER = 102;

$fn = 200;

difference() {
    union() {
        cylinder(d=PIPE_DIAMETER_INNER, h=5);
        translate([0, 0, 5])
        cylinder(d1=PIPE_DIAMETER_INNER, d2=PIPE_DIAMETER_INNER+1, h=2);
    }
    
    cylinder(d=PIPE_DIAMETER_INNER-10, h=50, center=true);
}

for (i=[0:2])
    rotate([0, 0, i*60])
    translate([0, 0, 2.5])
    cube([PIPE_DIAMETER_INNER-5, 10, 5], center=true);