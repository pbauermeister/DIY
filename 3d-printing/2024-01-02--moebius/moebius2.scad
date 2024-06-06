DIAMETER      = 100;

SIZE          = 25;
THICKNESS     = 8;
NB            = 20 + 4;

OUTER_SIDE    = (DIAMETER/2 + SIZE/2) * 2 * PI / NB;

PIN_DIAMETER  = 2;
BALL_DIAMETER = 3.5;
BALL_WALL     = 1.25;

PLAY          = 0.17 -.04;
$fn           = 90;

USE_CACHE     = !true;

module piece() {
    k1 = 2;
    k2 = 1.25;
    w = THICKNESS * (1- 1/3*k2*2) + BALL_WALL * 1.5;

    difference() {
        cube([SIZE, OUTER_SIDE, THICKNESS], center=true);

        dr = SIZE/2 -1;
        dh = THICKNESS*.5;
        dd = OUTER_SIDE*.6;


        translate([0, -dd, 0])
        cube([SIZE*2, OUTER_SIDE, THICKNESS/3 * k1], center=true);

        translate([0, dd, THICKNESS - THICKNESS/3 * k2])
        cube([SIZE*2, OUTER_SIDE, THICKNESS], center=true);

        translate([0, dd, - THICKNESS + THICKNESS/3 * k2])
        cube([SIZE*2, OUTER_SIDE, THICKNESS], center=true);

        translate([0, -PIN_DIAMETER/2 + OUTER_SIDE/2, 0])
        sphere(d=BALL_DIAMETER+BALL_WALL*2);
    }
    
    //d = SIZE/2 *.8;
    //cylinder(d=d, h=THICKNESS, center=true);

    // pin
    translate([0, PIN_DIAMETER/2 - OUTER_SIDE/2, 0])
    pin();

    // ball as support
    translate([0, -PIN_DIAMETER/2 + OUTER_SIDE/2, 0])
    ball();

    // ball joint
    intersection() {
        translate([0, -PIN_DIAMETER/2 + OUTER_SIDE/2, 0]) {
            difference() {
                sphere(d=BALL_DIAMETER+BALL_WALL*2);

                pin(extra_sphere=PLAY*1);
                pin(extra_axis=PIN_DIAMETER*.25, extrude=5*0);
                pin(extra_axis=PIN_DIAMETER*.25, extrude=5);
             }
         
        }
        translate([0, BALL_WALL/3, 0])
        cube([SIZE, OUTER_SIDE, w], center=true);
     }
 }

module pin(extra_axis=0, extra_sphere=0, extrude=0) {
    hull() {
        cylinder(d=PIN_DIAMETER+extra_axis*2, h=THICKNESS, center=true);
        translate([0, extrude, 0])
        cylinder(d=PIN_DIAMETER+extra_axis*2, h=THICKNESS, center=true);
    }

    hull() {
        sphere(d=BALL_DIAMETER+extra_sphere*2);
     if(0)   translate([0, extrude, 0])
        sphere(d=BALL_DIAMETER+extra_sphere*2);
    }
    
    ball();

    // support
    d = BALL_DIAMETER/2 + PLAY*2;
    th = 1.25;
    w = 4;
    if (!extra_axis && !extra_sphere && !extrude) {
        translate([d, th/2 -w, -th/2])
        cube([SIZE/2 -d, w, th]);
    }
}


module ball(extra_axis=0, extra_sphere=0) {
    sphere(d=BALL_DIAMETER);

    // ball support
    if (!extra_sphere && !extra_axis)
        translate([PLAY*2, 0, 0])
        rotate([0, 90, 0])
        cylinder(d=1, h=BALL_DIAMETER, center=true);
}

module band() {
    for (i=[0:NB-1]) {
        a = i * 360 / NB;
        //if(i % (NB/4) < 2)
        rotate([0, 0, a])
        translate([DIAMETER/2, 0, 0])
        rotate([0, 180/NB*i, 0])
        piece();
    }
}


module piece_cached() {
    if (USE_CACHE)
        import("piece.stl", convexity=3);
    else
        piece();
}

module array(nmax=0) {
    rows = floor(sqrt(NB)) +2;
    cols = NB/rows;
    echo(cols, rows, cols*rows, NB);

    for (i=[0:cols-1]) {
        for (j=[0:rows-1]) {
            n = i*rows+j;
            if (nmax==0 || n<nmax)
            translate([i*THICKNESS*1.5, j*(OUTER_SIDE-PIN_DIAMETER), 0])
            rotate([0, 90, 0])
            piece_cached();
        }
    }       
}

//// Here we go

//band();

scale(1.6)
intersection() {
    array(NB/2);
//    cube([SIZE, SIZE*2, SIZE*3], center=true);
//    cylinder(r=SIZE*5, h=BALL_DIAMETER+3, center=true);
}