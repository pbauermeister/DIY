$fn       = 36;
ROUNDED   = 2;
TOLERANCE = .2;

WIDTH     = 170 + TOLERANCE*2 - 6    + 4;
HEIGHT    =  83 + TOLERANCE*2;
THICKNESS =  18 + TOLERANCE*2 + 1;

SHORTEN   =  10;

WALL      =   2.25                   - .25;

ATTACHMENT_SCREWS_DISTANCE_H_TOP = 30;
ATTACHMENT_SCREWS_DISTANCE_H_BOTTOM = 36;
ATTACHMENT_SCREWS_DISTANCE_V = 65;
ATTACHMENT_MARGIN = 8;
ATTACHMENT_THICKNESS = 5;

module attachment() {
    w = ATTACHMENT_SCREWS_DISTANCE_H_BOTTOM + WALL*4  + ATTACHMENT_MARGIN/2;
    h = ATTACHMENT_SCREWS_DISTANCE_V + WALL*2 + ATTACHMENT_MARGIN*2;

    translate([WIDTH/2, 0, -WALL]) {
        minkowski() {
            translate([-w/2, 0, -ATTACHMENT_THICKNESS+WALL/2])
            cube([w, h, ATTACHMENT_THICKNESS]);
            sphere(r=WALL/2);
        }


    // hole pads
    union() {
        pad_thickness = 1.4;
        pad_d = 9;
        z = -ATTACHMENT_THICKNESS - pad_thickness;
            for (x=[-ATTACHMENT_SCREWS_DISTANCE_H_BOTTOM/2,
                     ATTACHMENT_SCREWS_DISTANCE_H_BOTTOM/2]) {
                translate([x, WALL+ATTACHMENT_MARGIN, z])
                cylinder(d=pad_d, h=pad_thickness*2);
            }

            for (x=[-ATTACHMENT_SCREWS_DISTANCE_H_TOP/2,
                     ATTACHMENT_SCREWS_DISTANCE_H_TOP/2]) {
                translate([x, ATTACHMENT_SCREWS_DISTANCE_V+WALL+ATTACHMENT_MARGIN, z])
                cylinder(d=pad_d, h=pad_thickness*2);
            }
        }

    }
}

module attachment_holes() {
    w = ATTACHMENT_SCREWS_DISTANCE_H_BOTTOM + WALL*4;
    h = ATTACHMENT_SCREWS_DISTANCE_V + WALL*2;

    translate([WIDTH/2, 0, -WALL]) {            
        for (x=[-ATTACHMENT_SCREWS_DISTANCE_H_BOTTOM/2,
                 ATTACHMENT_SCREWS_DISTANCE_H_BOTTOM/2]) {
            translate([x, WALL+ATTACHMENT_MARGIN, -WALL*4])
            cylinder(d=2.2, h=WALL*6);
        }

        for (x=[-ATTACHMENT_SCREWS_DISTANCE_H_TOP/2,
                 ATTACHMENT_SCREWS_DISTANCE_H_TOP/2]) {
            translate([x, ATTACHMENT_SCREWS_DISTANCE_V+WALL+ATTACHMENT_MARGIN, -WALL*4])
            cylinder(d=2.2, h=WALL*6);
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
        attachment_holes();

        // cutoff top
        difference() {
            translate([-WIDTH/2, HEIGHT-SHORTEN, -THICKNESS/2])
            cube([WIDTH*2, HEIGHT, THICKNESS*2]);
            
            attachment();
        }
        
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
                cylinder(d=d, h=WIDTH*2);

                translate([-10, HEIGHT-SHORTEN -d-SHORTEN, z])
                rotate([0, 90, 0])
                cylinder(d=d, h=WIDTH*2);
            }
            l = ((HEIGHT - SHORTEN)/2+WALL+TOLERANCE*2) -d;
            dz = 2;
            translate([-THICKNESS, d/2+SHORTEN + d/2, z+dz])
            cube([WIDTH*2, l, d/2]);
        }
        
        // cutoff power button
        union() {
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
        {
            d = HEIGHT*.50;
            p = .18;
            ks = [p, .5, 1-p];
            
            for (k=ks) {
                translate([WIDTH*k, (HEIGHT-SHORTEN)/2, -WALL*4])
                //cylinder(d=d, h=WALL*6);
                cube(d, center=true);
            }
        }
    }
}

rotate([0, 45, 0]) translate([-WIDTH/2, 0, WALL])
//rotate([0, -90, 0])
case();
