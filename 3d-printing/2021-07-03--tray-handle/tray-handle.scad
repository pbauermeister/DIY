$fn = 30;

D = 10/2;

WIDTH0     = 15;
THICKNESS0 = 12;

WIDTH      = WIDTH0 - D;
THICKNESS  = THICKNESS0 - D;

DISTANCE  = 65;
HEIGHT    = 25;
EXTRA     = WIDTH0;

M         = 3.5;

module handle() {
    difference() {
        minkowski() {
            union() {
                union() {
                    translate([-EXTRA, -WIDTH/2, 0])
                    cube([EXTRA, WIDTH, THICKNESS0/3]);
                    translate([DISTANCE, -WIDTH/2, 0])
                    cube([EXTRA, WIDTH, THICKNESS0/3]);
                }
                hull() {
                    translate([0, -WIDTH/2, 0])
                    cube([THICKNESS, WIDTH, THICKNESS]);
                    
                    translate([0, -WIDTH/2, HEIGHT])
                    cube([THICKNESS, WIDTH, THICKNESS]);
                }

                hull() {
                    translate([0, -WIDTH/2, HEIGHT])
                    cube([THICKNESS, WIDTH, THICKNESS]);
                    translate([DISTANCE-THICKNESS, -WIDTH/2, HEIGHT])
                    cube([THICKNESS, WIDTH, THICKNESS]);
                }

                hull() {
                    translate([DISTANCE-THICKNESS, -WIDTH/2, HEIGHT])
                    cube([THICKNESS, WIDTH, THICKNESS]);
                    translate([DISTANCE-THICKNESS, -WIDTH/2, 0])
                    cube([THICKNESS, WIDTH, THICKNESS]);
                }
            }
            difference() {
                sphere(d=D);
                if(0)translate([0, 0, -D/2])
                cube(D, center=true);
            }
        }
        translate([-DISTANCE, -WIDTH-D, -D])
        cube([DISTANCE*3, WIDTH*2 + D*2, D]);
        
        translate([-EXTRA*.6, 0, 0])
        cylinder(d=M, h=THICKNESS+D);
        
        translate([DISTANCE + EXTRA*.6, 0, 0])
        cylinder(d=M, h=THICKNESS+D);
    }

    translate([0, -WIDTH0/2, 0])
    cube([DISTANCE, WIDTH0, 2]);
}


rotate([90, 0, 0])
handle();