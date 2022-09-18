/* Wheels for Vidga rail carriage */
AXIS_DIAMETER    = 2;
DIAMETER         = 8.4;
THICKNESS        = 2.5;
CHAMFER_HEIGHT   = 1;
CHAMFER_DIAMETER = 4;
CHAMFER_SHIFT    = .125*2;

ATOM             = 0.001;
$fn = 60;

module wheel(chamfer=false) {
    difference() {
        cylinder(d=DIAMETER, h=THICKNESS);
        
        if (chamfer)
            translate([0, 0, THICKNESS-1+ATOM - CHAMFER_SHIFT]) 
            cylinder(d2=CHAMFER_DIAMETER*2, d1=0, h=CHAMFER_HEIGHT*2);
        
        cube([AXIS_DIAMETER, AXIS_DIAMETER, THICKNESS*4], center=true);
    }
}

d = DIAMETER *.7;
for (x=[-d, d])
    for (y=[-d, d])
        translate([x, y, 0])
        wheel(y<0);
