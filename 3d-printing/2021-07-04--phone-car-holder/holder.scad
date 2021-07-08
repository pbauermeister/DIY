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
    difference() {
        union() {
            minkowski() {
                phone();
                sphere(r=WALL);
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
        d = THICKNESS *.7;
        hull() {
            translate([-10, d + SHORTEN, d/2 + (THICKNESS-d)/2])
            rotate([0, 90, 0])
            cylinder(d=d, h=50);
            translate([-10, HEIGHT-SHORTEN -d-SHORTEN, d/2 + (THICKNESS-d)/2])
            rotate([0, 90, 0])
            cylinder(d=d, h=50);
        }
        
        translate([WIDTH/2, 0, -1.5])
        attachment(WALL*2, full=true);

        translate([WIDTH/2, 0, -WALL*4.5])
        attachment(WALL*2, full=true);

        translate([WIDTH/2, 0, -WALL*2])
        attachment_hole();

        translate([WIDTH/2, 0, 0])
        attachment_hole2();

    }
}

rotate([0, 90, 0])
translate([-WIDTH/2, 0, WALL])
case();
