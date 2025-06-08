
INNER_GAP        =  13;
WIDTH            =  18.5    + .5   + .5;
LENGTH           = 109;
LENGTH_XTRA      =  51;

THICKNESS_TOP    =   0.5    + .5;
THICKNESS_SIDE   =   2;
THICKNESS_BOTTOM =   2;

SPACING          =   3;

BUMPER_H         = INNER_GAP+THICKNESS_TOP+THICKNESS_BOTTOM;
BUMPER_W         = 8;
R                = 2;

LIP_H            =   1.3;
LIP_W            =   2;

TOTAL_WIDTH      = INNER_GAP+THICKNESS_TOP+THICKNESS_BOTTOM;
TOTAL_HEIGHT     = WIDTH+THICKNESS_SIDE+ BUMPER_W;
ATOM = 0.01;

module rcube(r, l, w, h, shift=0, cyl=false) {
    hull()
    for (x=[-shift, l+shift]) {
        for (y=[-shift, w+shift]) {
            for (z=[-shift, h+shift]) {
                translate([x, y, z]) {
                if (cyl)
                    cylinder(r=r, h=r*2, center=true, $fn = $preview? 5 : 30);
                else
                    sphere(r=r, $fn = $preview? 5 : 30);
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
    cube([LIP_W, LIP_H, LENGTH-1]);
}

module body() {
    translate([-WIDTH-THICKNESS_SIDE, THICKNESS_TOP, 0])
    clip();

    // bumper
    hull() {
        cube([ATOM, TOTAL_WIDTH, LENGTH]);
        translate([0, 0, 0])
        rcube(R*1.7, BUMPER_W+R, BUMPER_H, LENGTH, -R*1.7, cyl=!true);
    }

    // foot
    translate([-WIDTH/2 - THICKNESS_SIDE, TOTAL_WIDTH, 0]) {
        intersection() {
            translate([0, WIDTH/16, 0])
            cube([WIDTH*2, WIDTH/8, LENGTH*10], center=true);

            hull() {
                for (h=[WIDTH/2+1, LENGTH - WIDTH/2-1 + LENGTH_XTRA]) {
                    translate([1, 0, h])
                    scale([1, .35, 1])
                    sphere(d=WIDTH+2, $fn = $preview? 16*4 : 100); 
                }
            }
        }

        for (h=[WIDTH/2+1, LENGTH - WIDTH/2-1 + LENGTH_XTRA]) {
            translate([1, 1, h])
            scale([1, .35, 1])
            sphere(d=WIDTH*.75, $fn = $preview? 16*4 : 100);
        }
    }


    w = WIDTH + 5;
    translate([-w, INNER_GAP + THICKNESS_TOP, 0])
    cube([w, THICKNESS_BOTTOM, LENGTH + LENGTH_XTRA]);

    //
    th = .5;
    translate([0, .2, 0])
    hull() {        
        translate([-THICKNESS_SIDE - th, INNER_GAP-2, 0])
        cube([th*3, INNER_GAP-10, 1]);

        translate([-THICKNESS_SIDE - th, INNER_GAP-2-1, LENGTH-1])
        cube([th*3, INNER_GAP-9, 1]);
    }
}

module spacer_left() {
    difference() {
        body();

        if (0)
        translate([-R, 0, -LENGTH/2])
        rcube(R, BUMPER_W+R*2, BUMPER_H, LENGTH*2, -R*1.75);

        if (0)
        translate([-R, 0, -LENGTH/2])
        rcube(R, BUMPER_W+R*2, BUMPER_H, LENGTH*2, -R*1.75);

        // shave ribs
        translate([0, -1.5, 0])
        hull() {
            translate([-THICKNESS_SIDE, INNER_GAP/2 + THICKNESS_TOP, 0])
            cylinder(d=INNER_GAP/2.5, h=LENGTH*3, center=true, $fn=30);
            translate([-THICKNESS_SIDE + 2, INNER_GAP/2 + THICKNESS_TOP, 0])
            cylinder(d=INNER_GAP/2.5, h=LENGTH*3, center=true, $fn=30);
        }

        // make ribs
        n = 5 +5*0;        
        for(i=[0:n-2]) {
            xtra = 10;
            h = (LENGTH + xtra*1.25)/n*(i+.5) -xtra/2;
            k = 1.75;
            // horizontal
            translate([-BUMPER_W*1.5, 1+2, h])
            rcube(R*1.5, BUMPER_W*4, BUMPER_H-2-4, LENGTH/n, -R*k);

            if (i==n-2)
            translate([-BUMPER_W*1.5, .75, h])
            rcube(R*1.5, BUMPER_W*4, BUMPER_H-2-4, LENGTH/n, -R*k);

            // vertical
            translate([0, -BUMPER_H-5, h])
            rcube(R*1.5, BUMPER_W*2, BUMPER_H*2, LENGTH/n, -R*k);
        }
    }
}


intersection() {
    spacer_left();
//    cylinder(r=1000, h=35);
}


%translate([-10, THICKNESS_TOP, 84])
cube([50, 5, 13]);