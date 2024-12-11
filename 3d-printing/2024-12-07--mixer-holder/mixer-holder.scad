SCREWS_DISTANCE = 255;
SCREW_DIAMETER  =   4.67;
LENGTH          = 285;
THICKNESS       =  30;
MIXER_DIAMETER  =  84;
WALL            =   8;
WIDTH           =  85;
MIXER_MARGIN    = (WIDTH-MIXER_DIAMETER) / 2;
R               =   4;
TOOL_DIAMETER   =   6;
FOAMER_DIAMETER = 41;
FOAMER_LENGTH   = 120;

TENON_D         = 2.4 + .7;
TENON_L         = 30;

MIXER_X = LENGTH - MIXER_DIAMETER/2 -WALL - R;
MIXER_Y = WIDTH - MIXER_DIAMETER/2 - WALL - R;
MIXER_CLEARANCE = 29;

PARTITIONER_SHIFT = THICKNESS*2;
PARTITIONER_X1 = -THICKNESS*.1 -WALL*1.5 + MIXER_X - MIXER_DIAMETER/2;;
PARTITIONER_X2 = PARTITIONER_X1 - PARTITIONER_SHIFT;

SHELL           = 1.2;
PLAY            = 0.17;
ATOM            = 0.02;
INFINITY        = 100000; 
FN              = $preview ? 100 : 100;

function get_length() = LENGTH;

module rcube(size) {
    if ($preview) {
        cube(size);
    }
    else {
        x = size[0];
        y = size[1];
        z = size[2];
        r = R;
        hull()
        for(x=[r, x-r])
        for(y=[r, y-r])
        for(z=[r, z-r])
            translate([x, y, z])
            sphere(r=r, $fn=$preview?10:30);
    }
}

module body() {
    difference() {
        union() {
            rcube([LENGTH, WIDTH, THICKNESS]);

            translate([0, WIDTH-THICKNESS, -THICKNESS])
            rcube([LENGTH, THICKNESS, THICKNESS*2]);

            translate([MIXER_X, MIXER_Y, THICKNESS/2])
            cylinder(d=MIXER_DIAMETER+WALL*2, h=THICKNESS*1.5, $fn=FN);            
        }

        translate([MIXER_X, MIXER_Y, WALL])
        cylinder(d=MIXER_DIAMETER, h=THICKNESS*10, $fn=FN);
        
        translate([0, -WIDTH, -1])
        cube([LENGTH, WIDTH, THICKNESS*3]);
    }
}

module holes() {
    // tools
    m = WALL * 3;
    dx = -WIDTH*.6;
    dy = WIDTH*.32;
    for (x=[0, dx, dx *2]) {
        for (y=[WIDTH/2 - dy, WIDTH/2 + dy]) {
            translate([LENGTH - MIXER_DIAMETER - WALL*5+x, y, WALL])
            cylinder(d=TOOL_DIAMETER, h=THICKNESS*2, $fn=FN);
        }
    }

    // screws
    m2 = (LENGTH-SCREWS_DISTANCE) / 2;
    z = -THICKNESS;
    depth = 7;
    for (x = [m2, m2+SCREWS_DISTANCE]) {
        translate([x, WIDTH+ATOM, THICKNESS/2]) hull() {
            rotate([90, 0, 0])
            cylinder(d=SCREW_DIAMETER, h=depth, $fn=FN);

            translate([0, 0, z])
            rotate([90, 0, 0])
            cylinder(d=SCREW_DIAMETER, h=depth, $fn=FN);
        }

        translate([0, -depth/2, 0])
        translate([x, WIDTH+ATOM, THICKNESS/2]) hull() {
            rotate([90, 0, 0])
            cylinder(d=SCREW_DIAMETER*3, h=depth/2, $fn=FN);

            translate([0, 0, z])
            rotate([90, 0, 0])
            cylinder(d=SCREW_DIAMETER*3, h=depth/2, $fn=FN);
        }

        // reinforcement cracks
        for (y=[-depth-1.5:.5:-.3])
        translate([0, y, 0])
        translate([x, WIDTH+ATOM, THICKNESS/2]) hull() {
            rotate([90, 0, 0])
            cylinder(d=SCREW_DIAMETER*5, h=.08, $fn=FN);

            translate([0, 0, z])
            rotate([90, 0, 0])
            cylinder(d=SCREW_DIAMETER*4.5, h=0.08, $fn=FN);
        }
        
        // through hole
        translate([x, WIDTH+ATOM, THICKNESS/2+z])
        rotate([90, 0, 0])
        cylinder(d=SCREW_DIAMETER*3, h=depth/2, $fn=FN);
    }
    
    // tenons
    tenons_holes();
}

module cavities() {
    // mixer cable clearance
    translate([MIXER_X - MIXER_CLEARANCE/2, -WIDTH/2 + MIXER_Y, WALL])
    rcube([MIXER_CLEARANCE, WIDTH, THICKNESS*10]);

    // foamer
    hull() {
        h = 2;
        x = MIXER_X - MIXER_DIAMETER/2 - FOAMER_LENGTH;
        translate([x, WIDTH/2, THICKNESS + h])
        sphere(d=FOAMER_DIAMETER, $fn=FN);

        translate([x+FOAMER_LENGTH-FOAMER_DIAMETER, WIDTH/2, THICKNESS + h])
        sphere(d=FOAMER_DIAMETER, $fn=FN);
    }
}

module tenons_holes() {
    dist = TENON_D/2 + .67*0 +1 +.3;
    for (xyz=[
        [PARTITIONER_X2, WIDTH-THICKNESS/2, -THICKNESS+dist],
        [PARTITIONER_X2, THICKNESS/4, dist],

        [PARTITIONER_X1, WIDTH-THICKNESS/4, THICKNESS-dist],
        [PARTITIONER_X1, THICKNESS/4, THICKNESS-dist],
    ])
        translate([xyz[0], xyz[1], xyz[2]])
        rotate([0, 90, 0])
        cylinder(d=TENON_D, h=TENON_L, $fn=FN, center=true);   
}

module shape() {
    difference() {
        body();
        cavities();
    }
}

module shrink(d) {
    difference() {
        cube(INFINITY-d*3, center=true);
        minkowski() {
            difference() {
                cube(INFINITY, center=true);
                children();
            }
            cube(d*2, center=true);
        }
    }
}

module holder() {
    difference() {
        shape();
        holes();
    }
}

module hollower() {
    if (!$preview)
    difference() {
        shrink(SHELL) shape();

        if (0)
        for (x=[-WIDTH:20:LENGTH+WIDTH])
            translate([x, 0, 0])
            rotate([0, 0, 45])
            cube([SHELL/2,WIDTH*10, WIDTH*10], center=true);
        
        minkowski() {
            holes();
            sphere(r=SHELL, $fn=7);
        }
    }
}

module hollowed() {
    difference() {
        children();
//        hollower();
    }
}


module part1() {
    rotate([0, -90, 0])
    hollowed() intersection() {
        holder();

        translate([-PLAY, PLAY, PLAY])
        partitioner();

        translate([-PLAY, -PLAY, PLAY])
        partitioner();

    }
}

module part2() {
    rotate([0, 90, 0])
    hollowed() difference() {
        holder();
        partitioner();
    }
}

module partitioner() {
    translate([PARTITIONER_X1-LENGTH, -WIDTH/2, THICKNESS/2])
    cube([LENGTH, WIDTH*2, THICKNESS*2]);

    translate([PARTITIONER_X1-LENGTH, WIDTH/4, THICKNESS/4])
    cube([LENGTH, WIDTH/2, THICKNESS]);

    translate([PARTITIONER_X2-LENGTH, -WIDTH/2, -THICKNESS*1.5 + ATOM])
    cube([LENGTH, WIDTH*2, THICKNESS*2]);
}

holder();