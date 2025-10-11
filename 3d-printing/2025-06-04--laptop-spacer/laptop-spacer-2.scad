use <../chamferer.scad>

INNER_GAP        =  13;
WIDTH            =  19.5  + .2;
LENGTH           = 109 *0 + 80;

THICKNESS_TOP    =   1;
THICKNESS_SIDE   =   2;
THICKNESS_BOTTOM =   2    - .5;

SPACING          =   3;

BUMPER_H         = INNER_GAP+THICKNESS_TOP+THICKNESS_BOTTOM;
BUMPER_W         = 8;
R                = 1.5;

LIP_H            =   1.3;
LIP_W            =   2;

TOTAL_WIDTH      = INNER_GAP+THICKNESS_TOP+THICKNESS_BOTTOM;
TOTAL_HEIGHT     = WIDTH+THICKNESS_SIDE+ BUMPER_W;
ATOM = 0.01;

$fn = 6;

module rcube(r, l, w, h, shift=0, cyl=false, fn=undef) {
    hull()
    for (x=[-shift, l+shift]) {
        for (y=[-shift, w+shift]) {
            for (z=[-shift, h+shift]) {
                translate([x, y, z]) {
                if (cyl)
                    cylinder(r=r, h=r*2, center=true);
                else
                    sphere(r=r, $fn=fn);
                }
            }
        }
    }
}

module clip() {
    difference() {
        translate([0, -THICKNESS_TOP, 0])
        cube([WIDTH+THICKNESS_SIDE, TOTAL_WIDTH, LENGTH]);

        translate([-1, 0, -1])
        cube([WIDTH+1, INNER_GAP, LENGTH + 2]);
    }

    translate([0, 0, 0])
    cube([LIP_W, LIP_H, LENGTH-1.5]);
}

module body() {
    translate([-WIDTH-THICKNESS_SIDE, THICKNESS_TOP, 0])
    clip();

    // bumper
    hull() {
        r = R * 1.7;
        cube([ATOM, TOTAL_WIDTH, LENGTH]);
        rcube(r, BUMPER_W+R, BUMPER_H, LENGTH, -r*.865, cyl=!true, fn=6);
    }

    // lower plate
    w = WIDTH*2;
    translate([-5-w, INNER_GAP + THICKNESS_TOP, 0])
    cube([w, THICKNESS_BOTTOM, LENGTH]);

    // rests
    th = .5;
    translate([-1, .2 +.5, 0])
    hull() {        
        translate([-THICKNESS_SIDE - th, INNER_GAP-2, 0])
        cube([th*3, INNER_GAP-10, 1]);

        translate([-THICKNESS_SIDE - th, INNER_GAP-2-1*80/109, LENGTH-1])
        cube([th*3, INNER_GAP-9, 1]);
    }

}

module chamfer() {
    if ($preview) {
        children();
    }
    else {
        chamferer(.55, tool="sphere", fn=6, shrink=true, grow=true)
        children();
    }

}

module spacer_left() {
    n = 5;
    difference() {
        chamfer()
        difference() {
            body();

            // cut top
            translate([-WIDTH*1.5, -1, -LENGTH/2])
            cube([WIDTH, 10, LENGTH*2]);

            // shave ribs
            translate([0, -1.5, 0])
            hull() {
                d = INNER_GAP*.75;
                translate([-THICKNESS_SIDE - 1, INNER_GAP/2 + THICKNESS_TOP, 0])
                cylinder(d=d, h=LENGTH*3, center=true, $fn=4);
            }

            // make ribs
            xtra = 2;
            in = 1.75 +.25;    //4.5; //2*k*1.5;
            r  = ATOM; //2.625; //R*1.75;
            //in = 4.5; //2*k*1.5;
            //r  = 2.625; //R*1.75;
            for(i=[0:n-1]) {
                h = (LENGTH-xtra*2)/n*i+ xtra*.75;
                // horizontal
                translate([-BUMPER_W*1.5, -.5, h])
                rcube(r, BUMPER_W*4, BUMPER_H -4+1.5, LENGTH/n, -in, fn=8);

                // vertical
                translate([-2.5, -BUMPER_H-5, h])
                rcube(r, BUMPER_W*4, BUMPER_H*2, LENGTH/n, -in, fn=8);
            }
        }

        // tape cavity
        margin = 2;
        rr = .5;
        translate([-5-WIDTH*2 + margin, INNER_GAP - THICKNESS_TOP/2 + .7, margin])
        rcube(rr, WIDTH*2-margin*5.5, THICKNESS_BOTTOM, LENGTH-margin*2, -rr);
/*
        // non-stick surface for supports
        w = 7;
        th = 1;
        dz = (LENGTH-th-margin*2)/30;
        for (z=[margin:dz:LENGTH-margin])
            translate([-w-THICKNESS_SIDE-3.5, INNER_GAP+THICKNESS_TOP-1 +.1, z])
        cube([w, 1, th]);
*/
    }
}

dy = INNER_GAP+THICKNESS_TOP+THICKNESS_BOTTOM;

//rotate([$preview ? 0: -90, 0, 0])
rotate([0, $preview ? 0: 90, 0])
translate([0, -dy, 0])
intersection() {
    spacer_left();
//    cylinder(r=1000, h=35);
}

