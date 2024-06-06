$fn       = 36;
ROUNDED   = 2;
TOLERANCE = .2;
                                            // Samsung S22 Ultra
WIDTH     = 170 + TOLERANCE*2 - 6    + 4       +5;
HEIGHT    =  83 + TOLERANCE*2;
THICKNESS =  18 + TOLERANCE*2                  +2;

SHORTEN   =  10;

WALL      =   2.25                   - .25;

module attachment_shape(thickness, full=true) {
    w = 46.5;
    h = 65;
    translate([-w/2, WALL, 0])
    linear_extrude(height=thickness)
    resize([w, h, 1])
    import(full ? "attachment-full.dxf" : "attachment.dxf");
}

module attachment() {
    minkowski() {
        translate([WIDTH/2, 0, -WALL])
        attachment_shape(WALL*2);
        sphere(r=WALL*2);
    }
}

module attachment_hole() {
    translate([0, 33.057+WALL+10, -50])
    cylinder(d=20, h=50, $fn=36);
}

module attachment_hole2() {
    translate([0, 33.057+WALL+10, -50])
    cylinder(d=6, h=50, $fn=36);

    // screw head chamfer
    translate([0, 33.057+WALL+10, -3.25])
    cylinder(d1=6, d2 = 12, h=3, $fn=36);

}

module attachment_hack() {
    intersection() {
        translate([0, 33.057+WALL+10, -50])
        cylinder(d=20+5, h=50, $fn=36);
        union() {
            for (z=[-THICKNESS:1:THICKNESS]) {
                translate([-WIDTH/2, 0, z]) cube([WIDTH, HEIGHT, .1]);
            }
        }
    }
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

            attachment();
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
        union() {
            d = THICKNESS *.7;
            z = d/2 + (THICKNESS-d)/2;
            hull() {
                translate([-10, d + SHORTEN, z])
                rotate([0, 90, 0])
                cylinder(d=d, h=50+WIDTH);
                translate([-10, HEIGHT-SHORTEN -d-SHORTEN, z])
                rotate([0, 90, 0])
                cylinder(d=d, h=50+WIDTH);
            }
            l = ((HEIGHT - SHORTEN)/2+WALL+TOLERANCE*2) -d;
            dz = 2;
            translate([-THICKNESS, d/2+SHORTEN + d/2, z+dz])
            cube([THICKNESS*2 + WIDTH, l, d/2]);
        }

        // cutoff power button
        union() {
            l2 = 22*2;
            w2 = 9;
            dx = 17 -11;
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
        attachment_shape(WALL*2, full=true);

        translate([WIDTH/2, 0, -WALL*4.5])
        attachment_shape(WALL*2, full=true);

        translate([WIDTH/2, 0, -WALL*2])
        attachment_hole();

        translate([WIDTH/2, 0, 0])
        attachment_hole2();

        // cutoff to force inner walls and so reduce hollowings by the slicer
        // around the attachment hole
        translate([WIDTH/2, 0, WALL*2])
        attachment_hack();

    }
    
    PAD_SIZE = 20;
    PAD_THICKNESS = 4;
    translate([WIDTH/2 - PAD_SIZE/2, WALL, -WALL*4])
    cube([PAD_SIZE, PAD_SIZE, PAD_THICKNESS + WALL]);

}

module strut(d, dh=0) {
    h = d - WALL*2 +.5 + dh;
    y = HEIGHT*.17;
    z = - WALL * sqrt(2) +.1;
    hull() {
        translate([-d      , y, h]) cube(.5);
        translate([-d * 1.5, y, z]) cube(.5);
        translate([-d*  .75, y, z]) cube(.5);
    }
}

// Here we go

rotate([0, 45, 0]) translate([-WIDTH, -HEIGHT/2, WALL])
case();

strut(WIDTH * .23, 1);
strut(WIDTH * .45);
