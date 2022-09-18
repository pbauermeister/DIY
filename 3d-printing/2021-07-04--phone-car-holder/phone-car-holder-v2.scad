$fn       = 36;
ROUNDED   = 2;
TOLERANCE = .2;

WIDTH     = 170 + TOLERANCE*2;
HEIGHT    =  83 + TOLERANCE*2;
THICKNESS =  18 + TOLERANCE*2;

SHORTEN   =  10;

WALL      =   3;

module attachment(thickness, full=true) {
    w = 46.5;
    h = 65;
    translate([-w/2, WALL, 0])
    linear_extrude(height=thickness)
    resize([w, h, 1])
    import(full ? "attachment-full.dxf" : "attachment.dxf");
}

module attachment_hole() {
    translate([0, 33.057+WALL+10, -50])
    cylinder(d=20, h=50, $fn=36);
}

module attachment_hole2() {
    translate([0, 33.057+WALL+10, -50])
    cylinder(d=6, h=50, $fn=36);
}

module phone() {
    cube([WIDTH, HEIGHT, THICKNESS]);
}

module case() {
    %phone();
    difference() {
        union() {
            minkowski() {
                phone();
                sphere(r=WALL*2);
            }

            minkowski() {
                translate([WIDTH/2, 0, -WALL])
                attachment(WALL*2);
                sphere(r=WALL*2);
            }
        }

        phone();

        // cutoff top
        translate([-WIDTH/2, HEIGHT-SHORTEN, -THICKNESS/2])
        cube([WIDTH*2, HEIGHT, THICKNESS*2]);
        
        // cutoff front
        translate([SHORTEN/2, SHORTEN/2, SHORTEN])
        scale([(WIDTH-SHORTEN)/WIDTH, 1, 1])
        phone();
        
        // cutoff left side
        {
            d = THICKNESS *.7;
            z = d/2 + (THICKNESS-d)/2;
            hull() {
                translate([-10, d + SHORTEN, z])
                rotate([0, 90, 0])
                cylinder(d=d, h=50);
                translate([-10, HEIGHT-SHORTEN -d-SHORTEN, z])
                rotate([0, 90, 0])
                cylinder(d=d, h=50);
            }
            l = ((HEIGHT - SHORTEN)/2+WALL+TOLERANCE*2) -d;
            dz = 2;
            translate([-THICKNESS, d/2+SHORTEN + d/2, z+dz])
            cube([THICKNESS*2, l, d/2]);
        }
        
        // cutoff power button
        {
            l2 = 22;
            w2 = 9;
            dx = 17;
            hull() {
                translate([WIDTH/2 + dx, WALL, THICKNESS-WALL-1.5])
                rotate([90, 0, 0])
                cylinder(d=w2, h=WALL*4);

                translate([WIDTH/2 + dx + l2, WALL, THICKNESS-WALL-1.5])
                rotate([90, 0, 0])
                cylinder(d=w2, h=WALL*4);
            }
            w3 = w2*.8;
            hull() {
                translate([WIDTH/2 + dx, -w3, THICKNESS-WALL-1.5])
                sphere(r=w3);
                translate([WIDTH/2 + dx + l2, -w3, THICKNESS-WALL-1.5])
                sphere(r=w3);
            }
        }
        
        // cutoff back
        translate([WIDTH*.2, (HEIGHT-SHORTEN)/2, -WALL*3])
        cylinder(d=HEIGHT*.55, h=WALL*4);
        translate([WIDTH*.8, (HEIGHT-SHORTEN)/2, -WALL*3])
        cylinder(d=HEIGHT*.55, h=WALL*4);
        
        translate([WIDTH/2, 0, -1.5])
        attachment(WALL*2, full=true);

        translate([WIDTH/2, 0, -WALL*4.5])
        attachment(WALL*2, full=true);

        translate([WIDTH/2, 0, -WALL*2])
        attachment_hole();

        translate([WIDTH/2, 0, 0])
        attachment_hole2();
    }
    
    PAD_SIZE = 20;
    PAD_THICKNESS = 4;
    translate([WIDTH/2 - PAD_SIZE/2, WALL, -WALL*4])
    cube([PAD_SIZE, PAD_SIZE, PAD_THICKNESS + WALL]);

}

rotate([0, 45, 0])
translate([-WIDTH/2, 0, WALL])
case();
