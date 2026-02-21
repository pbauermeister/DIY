use <../chamferer.scad>

WIDTH     = 20;
HEIGHT    = 50;
THICKNESS =  5;

RAIL_OPENING    =  6.5 -.2;
RAIL_THICKNESS  =  2.2;
STEP            = HEIGHT/5;
BOLT            = 10.2;
DIAMETER        =  4.8;

R               =  0.5;

MARGIN          =  0.33;
ATOM            =  0.01;
$fn             = 30;

module block() {
    // backplate
    translate([-WIDTH/2, -THICKNESS, 0])
    cube([WIDTH, THICKNESS, HEIGHT]);

    // body
    rotate([0, 0, 180])
    hull() {
        translate([BOWDEN_DX, BOWDEN_DY, 0])
        cylinder(d=BOWDEN_OUTER_W, h=HEIGHT);

        dx = WIDTH/2-TH*2;
        
        translate([-WIDTH/2, THICKNESS, 0])
        cube([WIDTH, ATOM, HEIGHT]);
    }
}

module attachment() {
    difference() {
        chamferer(2)
        union() {
            // backplate
            block();

            // rail
            hull() {
                translate([-RAIL_OPENING/2, 0, 0])
                cube([RAIL_OPENING, RAIL_THICKNESS*2, HEIGHT]);

                translate([-RAIL_OPENING/2-MARGIN, RAIL_THICKNESS*1.5, 0])
                cube([RAIL_OPENING + MARGIN*2, ATOM, HEIGHT]);
            }
        }

        // rail vertical slit
        hull() {
            translate([0, R/2, -ATOM/2])
            cylinder(r=R, h=HEIGHT+ATOM);

            translate([0, RAIL_THICKNESS*2.5, -ATOM/2])
            cylinder(r=R*2, h=HEIGHT+ATOM, $fn=30);
        }

        // grooves
        translate([RAIL_OPENING/2+R/4, R/4, -ATOM/2])
        cylinder(r=R, h=HEIGHT+ATOM);

        translate([-RAIL_OPENING/2-R/4, R/4, -ATOM/2])
        cylinder(r=R, h=HEIGHT+ATOM);
        
        // rail slits
        th = .5;
        dz = HEIGHT/4 - BOLT/4;
        translate([-WIDTH/2, 0, dz-th/2]) cube([WIDTH, RAIL_THICKNESS*3, th]);
        translate([-WIDTH/2, 0, HEIGHT-dz-th/2]) cube([WIDTH, RAIL_THICKNESS*3, th]);
        
    }
}
module screw_substraction() {
        // bolt space
        translate([-WIDTH/2-ATOM, -ATOM, HEIGHT/2 - BOLT/2])
        cube([WIDTH+ATOM*2, RAIL_THICKNESS*3+ATOM, BOLT]);

        // screw hole
        translate([0, THICKNESS, HEIGHT/2])
        rotate([90, 0, 0])
        cylinder(d=DIAMETER, h=THICKNESS*3);
}

TH              =  3;
BOWDEN_INNER_D  =  4.5  - .2;
BOWDEN_DY       = 21.5;
BOWDEN_DX       = -5;
BOWDEN_OUTER_W  = BOWDEN_INNER_D + TH*2;

module piece() {
    difference() {
        union() {
            rotate([0, 0, 180])
            attachment();
        }
        rotate([0, 0, 180])
        screw_substraction();

        hole_d = max(DIAMETER*1.25, BOWDEN_INNER_D);

        // bowden hole
        translate([BOWDEN_DX, BOWDEN_DY, 0])
        cylinder(d=BOWDEN_INNER_D, h=HEIGHT*3, center=true);

        // conic hole
        translate([BOWDEN_DX, BOWDEN_DY, HEIGHT*.85+ATOM])
        cylinder(d1=BOWDEN_INNER_D, d2=BOWDEN_INNER_D*1.4, h=HEIGHT*.15);


        // cable clearances
        hull() {
            translate([BOWDEN_DX, BOWDEN_DY + BOWDEN_INNER_D*.5*0, -ATOM])
            cylinder(d=BOWDEN_INNER_D *.7, h=HEIGHT+ATOM*2);

            translate([BOWDEN_DX, BOWDEN_DY+TH*2, -ATOM])
            cylinder(d=BOWDEN_INNER_D*1.3, h=HEIGHT+ATOM*2);
        }
        translate([BOWDEN_DX, BOWDEN_DY+TH*2.5-1.5, -ATOM])
        scale([1, .35, 1])
        cylinder(d=BOWDEN_INNER_D*4, h=HEIGHT+ATOM*2, $fn=4);

        // screw hole
        ds = DIAMETER*2;
        hs = BOWDEN_DY*2;
        translate([0, THICKNESS, HEIGHT/2])
        rotate([-90, 0, 0])
        cylinder(d=ds, h=hs);

        // ramp
        d = BOWDEN_DY*2;
        ch = 6;
        if (0)
            translate([0, sqrt(2)*d/2 + BOWDEN_DY - BOWDEN_INNER_D/2*2.5, HEIGHT/2])
            rotate([45, 0, 0])
            cube([WIDTH*2, d, d], center=true);
        else
            translate([-WIDTH, ch*0+THICKNESS*0+BOWDEN_DY-TH/2, HEIGHT*.5])
            chamferer(ch, "cylinder-x", fn=24, shrink=false)
            union() {
                rotate([35, 0, 0])
                cube([WIDTH*2, d, ATOM]);
                cube([WIDTH*2, d, ATOM]);
            }

    }
}


intersection() {
//%    piece();
    piece();
//    cylinder(d=1000, h=2);
}