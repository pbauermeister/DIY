TOLERANCE       = 2;
CHAMFER         = 2;

BAR_DIAMETER    = 19;
BAR_POS_X       = 30;

BOTTLE_DIAMETER = 60 + TOLERANCE + CHAMFER*2;
BOTTLE_HEIGHT   = 146                          - 70;
BOTTLE_POS_Z    = 220;

THICKNESS       = 6                            -  2;
THICKNESS_2     = 4;


HOLLOWING_WALL  = 4;

SLANT_ANGLE     = 45-5;


LAYER           = .15;
ATOM            = 0.01;

WIDTH           = BOTTLE_DIAMETER*1.5;
SHELF_DIAMETER  = BOTTLE_DIAMETER + THICKNESS *2 + BAR_POS_X*2 - THICKNESS;
BAR_THICKNESS   = BAR_DIAMETER + THICKNESS*2;

$fn = $preview ? 30 : 120;

module scars() {
    // Scars create cracks inside the hook under the surface, to reinforce by replacing infill by inner walls 
    thickness = .2;
    margin = THICKNESS/2 - thickness*.75;
    difference() {
        // scars
        d = BAR_DIAMETER + THICKNESS*2 - margin*2;
        for (y=[3:THICKNESS/2+thickness*3:WIDTH-2])
                hull() {
                translate([BAR_THICKNESS/2, y, BOTTLE_POS_Z + BAR_DIAMETER/2])
                rotate([-90, 0, 0])
                cylinder(d=d, h=thickness);

                translate([BAR_THICKNESS/2, y, BOTTLE_POS_Z - BAR_DIAMETER/2])
                rotate([-90, 0, 0])
                cylinder(d=d, h=thickness);
            }

        // limit scars to not cross the skin
        hull() {
            d2 = BAR_DIAMETER + margin*2;
            translate([BAR_THICKNESS/2, -ATOM, BOTTLE_POS_Z + BAR_DIAMETER/2])
            rotate([-90, 0, 0])
            cylinder(d=d2, h=WIDTH+ATOM*2);

            translate([BAR_THICKNESS/2, -ATOM, BOTTLE_POS_Z - BAR_DIAMETER/2])
            rotate([-90, 0, 0])
            cylinder(d=d2, h=WIDTH+ATOM*2);
 
            translate([BAR_THICKNESS/2 -BAR_DIAMETER, -ATOM, BOTTLE_POS_Z - BAR_DIAMETER/2 -BAR_DIAMETER])
            rotate([-90, 0, 0])
            cylinder(d=d2, h=WIDTH+ATOM*2);
        }
    }
}

module bar(partial=false) {
    translate([0, -WIDTH/2, 0])
    difference() {
        // pillar
        hull() {
            translate([BAR_THICKNESS/2, 0, BOTTLE_POS_Z + BAR_DIAMETER/2])
            rotate([-90, 0, 0])
            cylinder(d=BAR_THICKNESS, h=WIDTH);

            cube([BAR_DIAMETER + THICKNESS*2, WIDTH, ATOM]);
        }
        
        // top hole
        hull() {
            translate([BAR_THICKNESS/2, -ATOM, BOTTLE_POS_Z + BAR_DIAMETER/2])
            rotate([-90, 0, 0])
            cylinder(d=BAR_DIAMETER, h=WIDTH+ATOM*2);

            translate([BAR_THICKNESS/2, -ATOM, BOTTLE_POS_Z - BAR_DIAMETER/2])
            rotate([-90, 0, 0])
            cylinder(d=BAR_DIAMETER, h=WIDTH+ATOM*2);
        }

        // top back opening
        hull() {
            translate([BAR_THICKNESS/2, -ATOM, BOTTLE_POS_Z - BAR_DIAMETER/2])
            rotate([-90, 0, 0])
            cylinder(d=BAR_DIAMETER, h=WIDTH+ATOM*2);

            translate([BAR_THICKNESS/2 - BAR_DIAMETER*2, -ATOM, BOTTLE_POS_Z - BAR_DIAMETER/2 - BAR_DIAMETER*2])
            rotate([-90, 0, 0])
            cylinder(d=BAR_DIAMETER, h=WIDTH+ATOM*2);

            translate([BAR_THICKNESS/2 - BAR_DIAMETER, -ATOM, BOTTLE_POS_Z - BAR_DIAMETER/2])
            rotate([-90, 0, 0])
            cylinder(d=BAR_DIAMETER, h=WIDTH+ATOM*2);
        }

        // front removal
        translate([THICKNESS, -ATOM, -THICKNESS/sqrt(2)/1])
        hull() {
            translate([BAR_THICKNESS, 0, BOTTLE_POS_Z - BAR_DIAMETER*2 + BAR_THICKNESS])
            cube([ATOM, WIDTH+ATOM*2, ATOM]);

            translate([0, 0, BOTTLE_POS_Z - BAR_DIAMETER*2])
            cube([BAR_THICKNESS, WIDTH+ATOM*2, ATOM]);

            cube([BAR_THICKNESS, WIDTH+ATOM*2, ATOM]);
        }
        
        // scars
        if (!partial)
            scars();
    }
}

function get_hook_z() = BOTTLE_POS_Z - BAR_DIAMETER*2;
function get_hook_w() = WIDTH;
function get_hook_th() = BAR_THICKNESS;
function get_th() = THICKNESS;

DY = BOTTLE_DIAMETER+1.5 + THICKNESS/2;

DY2 = BOTTLE_DIAMETER*.75 + THICKNESS;

module side_shape(outer=false) {
    extra = outer ? THICKNESS*2 : 0;
    dh = outer ? 0 : ATOM;
    chamfer = $preview ? 0: CHAMFER;
    hull() {
        translate([-BOTTLE_DIAMETER/4, 0, -dh])
        cylinder(d=BOTTLE_DIAMETER/2 + extra + chamfer, h=BOTTLE_HEIGHT+dh*2);
        translate([BOTTLE_DIAMETER/4, 0, -dh])
        cylinder(d=BOTTLE_DIAMETER/2 + extra + chamfer, h=BOTTLE_HEIGHT+dh*2);
    }
}

module bottle_holder_outer() {
    hull()
    for (y=[-DY2, DY2])
        translate([BOTTLE_DIAMETER/2 + THICKNESS_2, y, 0])
        side_shape(true);
}

module bottle_holder_main_0() {
    spacer();
    difference() {
        // body
        bottle_holder_outer();

        // cavity
        chamfer = $preview ? 0: CHAMFER;
        translate([BOTTLE_DIAMETER/2+THICKNESS, 0, -ATOM])
        cylinder(d=BOTTLE_DIAMETER+chamfer*2, h=BOTTLE_HEIGHT*2);

        for (y=[-DY2, DY2])
            translate([BOTTLE_DIAMETER/2+THICKNESS, y, 0])
            side_shape(false);

        // slanted top
        translate([0, -BOTTLE_DIAMETER*2, BOTTLE_HEIGHT])
        rotate([0, SLANT_ANGLE, 0])
        cube([BOTTLE_DIAMETER*3, BOTTLE_DIAMETER*4, BOTTLE_HEIGHT]);            
    }
}

module bottle_holder_main() {
    minkowski() {
        bottle_holder_main_0();
        if (!$preview)
        sphere(r=CHAMFER, $fn=20);
    }
}

module bottle_holder() {
    translate([0, 0, CHAMFER])
    bottle_holder_main();

    // floor
    intersection() {
        bottle_holder_outer();
        n = 4;
        d = BOTTLE_DIAMETER/(n+1);
        r = THICKNESS * .35;
        for (i=[1: n]) {
            x = -BOTTLE_DIAMETER/2*0  + THICKNESS + d*i;

            hull() {
                translate([x, 0, THICKNESS/2])
                rotate([90, 0, 0])
                cylinder(r=r, h=BOTTLE_DIAMETER*3, center=true);

                translate([x, 0, 0])
                rotate([90, 0, 0])
                cylinder(r=r, h=BOTTLE_DIAMETER*3, center=true);
            }
        }
    }
}

module spacer() {
    w = WIDTH/4;
    w2 = WIDTH/8;
    hull() {
        translate([0, -w/2, BAR_POS_X*2+THICKNESS])
        cube([ATOM, w, 1]);

        translate([-BAR_POS_X, -w2/2, BAR_POS_X+THICKNESS])
        cube([BAR_POS_X, w2, 1]);

        translate([-BAR_POS_X, -w2/2, BAR_POS_X])
        cube([BAR_POS_X, w2, 1]);

        translate([0, -w/2, 0])
        cube([ATOM, w, 1]);
    }
}

module support() {
    // v pillar
    h = BAR_DIAMETER*2;
    translate([0, -WIDTH/2, BOTTLE_POS_Z - h -LAYER*2])
    cube([.3, WIDTH, h]);

    // slanted pillar
    h2 = BAR_DIAMETER*2;
    translate([THICKNESS + BAR_DIAMETER/2, 0, THICKNESS + BAR_DIAMETER/2  + THICKNESS/2])
    translate([0, -WIDTH/2, BOTTLE_POS_Z - h2 -LAYER*3])
    rotate([0, -23.5, 0])
    cube([.3, WIDTH, h2 *.647]);

    // bridge
    th = .3;
    for (y=[0:2:WIDTH]) {
        translate([0, y - WIDTH/2, BOTTLE_POS_Z -LAYER*1 -th])
        cube([THICKNESS, 1, th]);
    }

}

module all() {
    translate([BAR_POS_X, 0, 0]) {
        translate([-2 - CHAMFER/2, 0, 0]) {
            bar();
            //support();
        }

        bottle_holder();
    }
}

module cut(doit) {
    intersection() {
        children();
        if (doit) {
            translate([BAR_POS_X + THICKNESS + BAR_DIAMETER/2, 0, 0])
            //rotate([0, 0, 45])
            translate([0, -WIDTH/2+3+.65, 0])
            cube([1000, 1, 1000], center=true);
            % children();
        }
    }
}

cut(!true) all();


if (0)
%
translate([BAR_POS_X, 0, 0])
translate([BOTTLE_DIAMETER/2+THICKNESS, 0, 0])
cylinder(d=BOTTLE_DIAMETER, h=BOTTLE_HEIGHT);

//%cylinder(r=200, h=60+10);

//%translate([BAR_POS_X+BOTTLE_DIAMETER/2+THICKNESS, 0, 0]) cylinder(d=BOTTLE_DIAMETER-1, 100);