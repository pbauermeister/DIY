
PLAY = .2;

LENGTH    =  86.5 + PLAY + 1.4;
WIDTH     =  30.0 + PLAY;
DIAMETER  =  54.0;
HEIGHT    = 137.5 + PLAY + 1;
THICKNESS =   3.0;
HOLE_DIAETER = 15;
POCKET_WIDTH = 9.0 + 2.5;

THICKNESS2 =   .5;

CAP_HOLE_WIDTH = 15;

TOLERANCE = .13;

ATOM = 0.001;

$fn = $preview ? 24 : 60;

module bank() {
    intersection() {
        hull() {
            d=(LENGTH-DIAMETER)/2;
            fn = $preview ? 24 : 180;
            translate([-d, 0, 0]) cylinder(d=DIAMETER, h=HEIGHT, $fn=fn);
            translate([+d, 0, 0]) cylinder(d=DIAMETER, h=HEIGHT, $fn=fn);           
        }
        cube([LENGTH*2, WIDTH, HEIGHT*2], center=true);
    }
}

module shell() {
    difference() {
        minkowski() {
            bank();
            sphere(r=THICKNESS);
        }
        scale([1, 1, 2])
        bank();
    }
}

module pocket() {
    difference() {
        translate([POCKET_WIDTH+THICKNESS, 0, 0])
        shell();

        scale([1, 1, 2])
        bank();
    }
}

module body0() {
    shell();
    pocket();    
}

module body() {
    difference() {
        body0();

        translate([(POCKET_WIDTH+THICKNESS)/2, 0, 0])
        cylinder(d=HOLE_DIAETER, h=THICKNESS*4, center=true);
        
        translate([0, 0, HEIGHT])
        cap0();


        translate([0, -WIDTH/2 - THICKNESS2, 0])
        carves();
        translate([0, WIDTH/2 + THICKNESS + THICKNESS2, 0])
        carves();

        hull() {
            translate([LENGTH/2+POCKET_WIDTH-THICKNESS, 0, HEIGHT/2 - WIDTH/6])
            rotate([0, 90, 0])
            cylinder(d=WIDTH, h=WIDTH);
            translate([LENGTH/2+POCKET_WIDTH-THICKNESS, 0, HEIGHT/2 + WIDTH/6])
            rotate([0, 90, 0])
            cylinder(d=WIDTH, h=WIDTH);
        }
    }
}

module cap0(extra=TOLERANCE*2) {
    minkowski() {
        intersection() {
            hull() {
                d=(LENGTH-DIAMETER)/2;
                dx = POCKET_WIDTH+THICKNESS;
                fn = $preview ? 24 : 180;
                translate([-THICKNESS-d, 0, 0]) cylinder(d=DIAMETER, h=ATOM, $fn=fn);
                translate([dx+d, 0, 0]) cylinder(d=DIAMETER, h=ATOM, $fn=fn);           
            }
            cube([LENGTH*2, WIDTH, HEIGHT*2], center=true);
        }
        cylinder(d1=THICKNESS/2+extra, d2 = extra, h=THICKNESS);
    }
    cube(THICKNESS);
}

module cap() {
    difference() {
        intersection() {
            cap0(extra=0);
            translate([0, 0, -HEIGHT]) hull() body0();
        }
        margin = THICKNESS;
        
        hull() {
            translate([-LENGTH/2+CAP_HOLE_WIDTH/2+margin, 0, 0])
            cylinder(d=CAP_HOLE_WIDTH, h=THICKNESS*3, center=true);

            translate([LENGTH/2-CAP_HOLE_WIDTH/2-margin, 0, 0])
            cylinder(d=CAP_HOLE_WIDTH, h=THICKNESS*3, center=true);
        }
    }
}

module carves() {
    d = 20;

    ymin = 0;
    ymax = HEIGHT;
    ynb = floor((HEIGHT-d) / d *1.5);
    ystep = (ymax-ymin) / ynb;

    xmin = -LENGTH/2 + d/2;
    xmax = LENGTH/2+THICKNESS + POCKET_WIDTH -d/2;
    xnb = floor((xmax-xmin) / d *1.5);
    xstep = (xmax-xmin) / xnb;

    echo(xnb, xstep);
    rotate([90, 0, 0])
    for (y = [ymin+ystep/2:ystep:ymax-ystep/2]) {
        for (x = [xmin+xstep/2:xstep:xmax-xstep/2]) {
            translate([x, y, 0])
            cylinder(d=d/2, h=THICKNESS);
        }
    }
}

if(1)
    translate([0, 0, THICKNESS])
    body();
else {
    intersection() {
        translate([0, 0, -HEIGHT+15])
        body();
        cylinder(r=LENGTH, h=50);
    }
}

%translate([0, WIDTH*2, 0]) cap();

//%bank();