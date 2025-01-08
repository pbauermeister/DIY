SCREW_DIAMETER =  6.5;
DIAMETER       = 40 + 10;
THICKNESS      = 12;
BASE_THICKNESS =  1.5;
INNER_DIAMETER = 19.5;
PIN_POS        =  5.5;
PIN_DIAMETER   =  1.5 + .2;
CHAMFER        =  3.5;

$fn = $preview ? 30 : 120;

module body() {
    minkowski() {
        difference() {
            union() {
                cylinder(d=DIAMETER, h=THICKNESS-CHAMFER);

                translate([0, 0, THICKNESS-CHAMFER])
                cylinder(d1=DIAMETER, d2=0, h=DIAMETER/20);
            }

            n = 4;
            for (i=[0:n-1]) {
                rotate([0, 0, 360/n*(i+.5)])
                translate([DIAMETER/1.3, 0, 0])
                cylinder(d=DIAMETER/1.125, h=THICKNESS*3, center=true);
            }
        }
        
        if (!$preview)
        intersection() {
            sphere(d=CHAMFER, $fn=15);
            cylinder(d=CHAMFER*2, h=CHAMFER*2);
        }
    }
}

difference() {
    body();
    
    // screw hole
    cylinder(d=SCREW_DIAMETER, h=THICKNESS*3, center=true);

    // central pit
    translate([0, 0, BASE_THICKNESS])
    cylinder(d=INNER_DIAMETER, h=THICKNESS);

    // hole for pin
    translate([0, DIAMETER/20, PIN_DIAMETER/2 + BASE_THICKNESS + PIN_POS])
    rotate([90, 0, 0])
    cylinder(d=PIN_DIAMETER, h=DIAMETER, center=true);
}

%translate([0, 0, BASE_THICKNESS])
cylinder(d=INNER_DIAMETER, h=PIN_POS);
