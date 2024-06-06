LENGTH    =  93 +2.3 -1.1;
WIDTH     =  22;
HEIGHT    =  95 +1   -1;
THICKNESS =   1.5;
THICKNESS_W = 0.5;

R         = 150;

ATOM = 0.001;

fn = $preview ? 50: 180;
$fn = fn;

module spine() {
    translate([0, -R, 0])
    intersection() {
        difference() {
            cylinder(r=R, h=HEIGHT);
            cylinder(r=R-ATOM, h=HEIGHT*3, center=true);
        }
        
        translate([0, R*.75, 0])
        cube([LENGTH-WIDTH, R, HEIGHT*3], center=true);
    }
}

module body() {
    difference() {
        minkowski() {
            spine();
            cylinder(d=WIDTH + THICKNESS_W*2, h=ATOM, $fn=fn/5);
        }

        translate([0, 0, THICKNESS])
        minkowski() {
            spine();
            cylinder(d=WIDTH, h=ATOM, $fn=fn/4);
        }

if(0)
        translate([0, 0, -THICKNESS])
        minkowski() {
            spine();
            cylinder(d=WIDTH - THICKNESS, h=ATOM, $fn=fn/4);
        }

    }
}

SLIT = 3;

module mesher() {
    dx = (LENGTH-WIDTH) / 2;
    nx = 6;
    h = HEIGHT*.965 / 2;
    for (i=[0:4]) {
        for (j=[-nx/3-.5:nx/3+.5]) {
            translate([dx/nx*j  -SLIT/2, -WIDTH, h/2*(i-abs(j+10)%2/2 -.1) -ATOM])
            cube([SLIT, WIDTH*2, h/2.750 + ATOM*2]);
        }
    }
}

difference() {
    body();

    translate([0, -WIDTH/2, HEIGHT/2+THICKNESS])
    cube([.03, WIDTH, HEIGHT], center=true);
}