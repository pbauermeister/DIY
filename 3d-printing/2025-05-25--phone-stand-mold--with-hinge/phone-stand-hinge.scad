use <hinge3.scad>

WIDTH     =  85;
LENGTH    = 107 + 13;
THICKNESS =   4;
HEIGHT    =  20;
D         =   3.5;
SLIT_W    =  13;
TAIL_L    =  20;
TAIL_W    =  12.5;
R         =   1.5;

module rcube(r, dim) {
    l = dim[0];
    w = dim[1];
    h = dim[2];
    hull()
    for (x=[r, l-r]) {
        for (y=[r, w-r]) {
            for (z=[r, h-r]) {
                translate([x, y, z])
                sphere(r=r, $fn=30);
            }
        }
    }
}

module hinge() {
    intersection() {
        translate([5.5, 49, D/2])
        rotate([90, 0, 0]) {
            support_hinge(D);
            support_hinge(D, true);
        }

        translate([0, -WIDTH/2, 0])
        cube([LENGTH, WIDTH, HEIGHT+THICKNESS]);
    }
}

module body(envelope=false) {
//    % translate([0, -WIDTH/2, 0]) cube([LENGTH, WIDTH, HEIGHT+THICKNESS]);
    % translate([7.5, -WIDTH/2, THICKNESS]) cube([LENGTH, WIDTH, 20]);

    difference() {
        union() {
            // hinges
            if (!envelope) hinge();

            // floor
            dx = 7.5;
            if (envelope) translate([0, -WIDTH/2, 0]) rcube(R, [LENGTH, WIDTH, THICKNESS]);
            else translate([dx, -WIDTH/2, 0]) cube([LENGTH-dx, WIDTH, THICKNESS]);

            // wall
            x = D/2 + 2.5;
            dz = 1;            
            th = 3;
            lip = THICKNESS;
            if (envelope)
                translate([x, -WIDTH/2, THICKNESS/4])
                rcube(th/2, [th, WIDTH, HEIGHT+THICKNESS - THICKNESS/4 + lip/2]);
            else
                translate([x, -WIDTH/2, THICKNESS + dz])
                cube([th, WIDTH, HEIGHT - dz + lip/2]);

            dr = th/10;
            translate([x, -WIDTH/2 -dr/2, HEIGHT+THICKNESS - lip/4])
            rcube(lip/2, [lip, WIDTH + dr, lip]);


            // gap filler
            if (!envelope) {
                translate([7.15-.5, -WIDTH/2, THICKNESS-.5])
                cube([1, WIDTH, .5]);

                translate([0, -WIDTH/2, 0])
                cube([3.20, WIDTH, THICKNESS]);
            }
        }
                
        // cable slit
        translate([0, -SLIT_W/2, THICKNESS + 5])
        rcube(R, [50, SLIT_W, HEIGHT*2]);

        // lever
        translate([LENGTH - THICKNESS - .5, -SLIT_W/2, - 5])
        rcube(R, [50, SLIT_W, HEIGHT*2]);
        
        // axis
        translate([LENGTH - THICKNESS/2, 5, THICKNESS/2])
        rotate([90, 0, 0])
        cylinder(d=1, h=WIDTH, center=true, $fn=10);
        
        // bottom stripes
        for (i=[-6:6])
            translate([0, THICKNESS*i*1.5, -THICKNESS/4])
            rotate([45, 0, 0])
            translate([THICKNESS*2.5, -THICKNESS/2, -THICKNESS/2])
            cube([LENGTH - THICKNESS*4, THICKNESS, THICKNESS]);
    }
}

intersection() {
    body();
    body(true);
}

// tail
hull() {
    translate([-TAIL_L, -TAIL_W/2, 0])
    cube([TAIL_L, TAIL_W, 2]);

    translate([0, -TAIL_W/2, 0])
    cube([2, TAIL_W, THICKNESS]);
}