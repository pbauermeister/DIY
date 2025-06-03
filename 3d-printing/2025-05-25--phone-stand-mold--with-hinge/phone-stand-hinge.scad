use <hinge4.scad>
use <lever.scad>

WIDTH     =  85;
LENGTH    = 107 + 13/2;
THICKNESS =   4;
HEIGHT    =  20;
D         =   3.5;
SLIT_W    =  13;
TAIL_L    =  20;
TAIL_W    =  12.5 +.1;
R         =   1.5;
AXIS_D    =   1;
WALL_THICKNESS = 3;

WALL_X_POS = D/2 + 2.5;

ATOM = 0.01;

module rcube(r, dim) {
    l = dim[0];
    w = dim[1];
    h = dim[2];
    hull()
    for (x=[r, l-r]) {
        for (y=[r, w-r]) {
            for (z=[r, h-r]) {
                translate([x, y, z])
                sphere(r=r, $fn=50);
            }
        }
    }
}

module hinge(for_clearance=false, alt=false) {
    translate([WALL_X_POS+3/2, WIDTH/2, 3/2]) 
    rotate([90, -90, 0]) {
        hinge4(thickness=3, arm_length=5, nb_layers=11, total_height=WIDTH, angle=90, extra_angle=55);

        rotate([0, 0, -90])
        hinge4(thickness=3, arm_length=5, nb_layers=11, total_height=WIDTH, angle=90, extra_angle=55, only_alt=0);
    }
}


module body(envelope=false) {
//    % translate([0, -WIDTH/2, 0]) cube([LENGTH, WIDTH, HEIGHT+THICKNESS]);
//    % translate([7.5, -WIDTH/2, THICKNESS]) cube([LENGTH, WIDTH, 20]);

    WALL_X_POS = D/2 + 2.5;

    difference() {
        union() {
            // hinges
            if (!envelope) hinge();

            // floor
            dx = 7.5;
            if (envelope) translate([0, -WIDTH/2, 0]) rcube(R, [LENGTH, WIDTH, THICKNESS]);
            else translate([dx, -WIDTH/2, 0]) cube([LENGTH-dx, WIDTH, THICKNESS]);

            // wall
            dz = 2.5;            
            lip = THICKNESS;
            if (envelope)
                translate([WALL_X_POS, -WIDTH/2, THICKNESS/4])
                rcube(WALL_THICKNESS/2, [WALL_THICKNESS, WIDTH, HEIGHT+THICKNESS - THICKNESS/4 + lip/2]);
            else
                translate([WALL_X_POS, -WIDTH/2, THICKNESS + dz])
                cube([WALL_THICKNESS, WIDTH, HEIGHT - dz + lip/2]);

            // lip
            dr = WALL_THICKNESS/10;
            translate([WALL_X_POS, -WIDTH/2 -dr/2, HEIGHT+THICKNESS - lip/4])
            rcube(lip/2, [lip, WIDTH + dr, lip]);

            // gap filler
            if (!envelope) {
                translate([7.15-.5, -WIDTH/2, THICKNESS-.5])
                cube([1, WIDTH, .5]);

                hull() {
                    translate([5.7, -WIDTH/2, THICKNESS+.5])
                    cube([.4, WIDTH, .5]);

                    translate([5.74, -WIDTH/2, 4.13])
                    rotate([0, 45, 0])
                    cube([3, WIDTH, .9]);
                }

                translate([6.25, -WIDTH/2, THICKNESS-.1])
                cube([1, WIDTH, 5]);

                hull() {
                    translate([0, -WIDTH/2, 0])
                    cube([1.15, WIDTH, THICKNESS]);

                    translate([0, -WIDTH/2, 0])
                    cube([WALL_X_POS-3/2+.9, WIDTH, 3/2]);
                }

            }
        }

        // shave
        translate([WALL_X_POS - 1 -.25, -WIDTH/2, THICKNESS])
        cube([1, WIDTH, THICKNESS]);

        // cable slit
        translate([0, -SLIT_W/2, THICKNESS + 5])
        rcube(R, [50, SLIT_W, HEIGHT*2]);

        // lever
        translate([LENGTH - THICKNESS - .5, -SLIT_W/2, - 5])
        rcube(R, [50, SLIT_W, HEIGHT*2]);
        
        // axis
        translate([LENGTH - THICKNESS/2, 0, THICKNESS/2])
        rotate([90, 0, 0])
        cylinder(d=AXIS_D, h=TAIL_W*3, center=true, $fn=10);

        d = AXIS_D*.6;
        translate([LENGTH - THICKNESS/2 - d/2, -TAIL_W*3/2, -THICKNESS/2])
        cube([d, TAIL_W*3, THICKNESS]);

        w = AXIS_D*2;
        l = TAIL_W*.33;
        for (k=[1, -1])
            translate([LENGTH - THICKNESS/2 - w/2*1.3, (TAIL_W)*k -l/2, -THICKNESS/2])
            cube([w, l, THICKNESS]);

        
        // bottom stripes
        for (i=[-6:6])
            translate([0, THICKNESS*i*1.5, -THICKNESS/4])
            rotate([45, 0, 0])
            translate([THICKNESS*2.5, -THICKNESS/2, -THICKNESS/2])
            cube([LENGTH - THICKNESS*4, THICKNESS, THICKNESS]);
    }
}

module all() {
    intersection() {
        body();
        if (!$preview) body(true);
    }

    // tail
    hull() {
        translate([-TAIL_L, -TAIL_W/2, 0])
        cube([TAIL_L, TAIL_W, 2]);

        translate([.2, -TAIL_W/2, 0])
        cube([1, TAIL_W, THICKNESS]);
    }
}


intersection() {
    all();
//    translate([-10, -17, -10]) cube([25, 34, 25]);
}

translate([-30, 31, 0])
//rotate([0, 0, 90])
lever();