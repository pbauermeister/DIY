
INNER_HEIGHT      = 260;
INNER_THICKNESS   =  10;
INNER_WIDTH       =  32;
WALL              =   2 - .3;

SCRIBER_DIAMETER  =   4;
PLAY              =   0.17;
HLAYER            =   0.75;

CLIP_WIDTH        = SCRIBER_DIAMETER*.75;
CLIP_H            = INNER_THICKNESS*3;

HOLE_DIAMETER     =  10;
PAD_RADIUS        =   6;
SUPPORT_THICKNESS =   0.4;


ATOM      = 0.03;
$fn       = $preview ? $fn : 200;
CROSS_CUT = false;

module box() {
    difference() {
        translate([-WALL, 0, -WALL])
        cube([INNER_WIDTH + WALL*2, INNER_THICKNESS + WALL, INNER_HEIGHT + WALL*2]);

        translate([0, -ATOM, 0])
        cube([INNER_WIDTH, INNER_THICKNESS, INNER_HEIGHT]);
        
        // suspension holes
        dist = INNER_WIDTH*.67 + 15/2;
        for (z=[dist, INNER_HEIGHT - dist])
        translate([INNER_WIDTH/2, 0, z])
        rotate([-90, 0, 0])
        cylinder(d=HOLE_DIAMETER, h=INNER_WIDTH);
    }

    // pads
    k = 1.25;
    r = PAD_RADIUS * k;
    for (x=[r, INNER_WIDTH - r])
    for (z=[r, INNER_HEIGHT - r])
    translate([x, INNER_THICKNESS, z]) {
        intersection() {
            translate([0, r, 0]) cube(r*2, center=true);
            scale([1, 1/k*k, 1])
            sphere(r=r);
        }
    }
}

module scriber(extra=0) {
    translate([INNER_THICKNESS/2, INNER_THICKNESS/2, 0])
    cylinder(d=SCRIBER_DIAMETER+extra, h=INNER_HEIGHT, $fn=20);
}

module clip0(h, dt=0) {
    dx = 1.5;
    w = SCRIBER_DIAMETER + dx*2;
    recess = 1.5;
    
    translate([INNER_THICKNESS/2, 0, 0]) {

        // scriber
        translate([-INNER_THICKNESS/2, 0, -ATOM]) intersection() {
            hull() {
                translate([0, -SCRIBER_DIAMETER*.1, 0])
                scriber(extra=PLAY*0 + dt*2);
                translate([0, SCRIBER_DIAMETER*.1, 0])
                scriber(extra=PLAY*0 + dt*2);
            }
            cylinder(r=INNER_THICKNESS, h=h);  // clip vertically
        }
        
        // middle
        w = CLIP_WIDTH + dt*2;
        translate([-w/2, recess, 0])
        cube([w, INNER_THICKNESS-recess, h]);

        // funnel
        w2 = INNER_THICKNESS + dt * 3.33;
        difference() {
            translate([0, -SCRIBER_DIAMETER*.3, 0])
            scale([.5, 1, 1])
            rotate([0, 0, 45])
            translate([-w2/2, -w2/2, 0])
            cube([w2, w2, h]);

            translate([-w2/2, -w2 + recess, -ATOM])
            cube([w2, w2, h+ATOM*2]);
       }
    }
}

module clip() {
    h = CLIP_H;
    difference() {
        union() {
            difference() {
                // clip
                clip0(h, HLAYER);

                // hollowing
                for (z=[1, -1])
                for (y=[1, -1])
                    translate([0, ATOM*2*y, ATOM*2*z]) clip0(h, 0);
            }
            // reinforcement
            for (x=[-1, 1])
            translate([INNER_THICKNESS/2 + x*(CLIP_WIDTH/2+HLAYER/2), INNER_THICKNESS, 0])
            cylinder(r=HLAYER*1.25, h=h, $fn=50);
        }

        // slanted bottom
        translate([0, INNER_THICKNESS, 0])
        rotate([-45 -10, 0, 0])
        translate([0, -INNER_THICKNESS*2, -INNER_THICKNESS*2])
        cube([INNER_THICKNESS,INNER_THICKNESS*2, INNER_THICKNESS*2]);
    }    
}

module rests() {
    d = INNER_WIDTH*sqrt(2);
    h = INNER_HEIGHT*.6;

    difference() {
        translate([INNER_WIDTH/2, INNER_WIDTH/2+INNER_THICKNESS, -WALL])
        cylinder(d=d, h=h);

        translate([INNER_WIDTH/2, INNER_WIDTH/2+INNER_THICKNESS, 0])
        cylinder(d=d-SUPPORT_THICKNESS*2, h=h*3, center=true);

        translate([-INNER_WIDTH/2, WALL, 0])
        cube([INNER_WIDTH*2, INNER_THICKNESS, INNER_HEIGHT]);

        n = 10;
        dh = h/n -1;
        for(z=[0:n-1])
            translate([-INNER_WIDTH/2, WALL+2, z*(dh+1) -2])
            cube([INNER_WIDTH*2, INNER_THICKNESS, dh]);        
    }
}

module support() {
    th = SUPPORT_THICKNESS;
    d = INNER_WIDTH / 10;
    for (x=[d:d:INNER_WIDTH-d])
    hull() {
        translate([x, INNER_THICKNESS-.3-.05, INNER_HEIGHT-INNER_THICKNESS])
        cube([th, .3, 3]);

        translate([x, 0, INNER_HEIGHT- .1])
        cube([th, INNER_THICKNESS-1, ATOM]);
    }
}

/*
module rests() {}

module support() {
    l = 10;
    w = 50;
    
    n = 3;
    h = INNER_HEIGHT*.75;
    
    for (z=[1:n]) {
        translate([0, 0, h/n*z]) {
            translate([INNER_WIDTH + WALL, -w/2, 0])
            cube([l, w, .1]);

            translate([-l-WALL, -w/2, 0])
            cube([l, w, .1]);
        }
    }
}
*/

//////////

//%scriber();

intersection() {
    union() {
        box();

        // clips
        vspacing = INNER_THICKNESS * 2.25;
        translate([0, 0, vspacing]) clip();
        translate([0, 0, INNER_HEIGHT - CLIP_H - vspacing]) clip();
    }

    if (CROSS_CUT)
        translate([0, 0, 45])
        cylinder(d=300, h=10, center=true);
}

rests();
support();
