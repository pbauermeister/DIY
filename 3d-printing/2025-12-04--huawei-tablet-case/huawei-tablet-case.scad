use <../hinge4.scad>
use <../chamferer.scad>

H = 8.2;
L = 243;
W = 162.5;
R = 6;
GAP = .4;

TH = 1              +.7;

$fn = $preview ? 20 : 100;
ATOM = 0.01 *10;

module tablet(w, h, l, r, xr=0, xx=0, xy=0) {
    hull()
    for (x=[r-xx+xr, w-r+xx-xr])
    for (y=[r-xy+xr, l-r+xy-xr])
    translate([x, h/2, y])
    rotate([90, 0, 0])
    rotate_extrude(convexity=10)
    translate([r - h/2 + xr, 0, 0])
    difference() {
        circle(r=h/2 + xr);
        translate([-h*2, -h]) square(h*2);
    }
}

module tablet_cavity(is_cover) {
    union() {
        tablet(W, H, L, R);

        translate([-W/2, -H, -L/2])
        translate([0, !is_cover ? H*2-TH-GAP: -TH, 0])
        cube([W*2, H*2, L*2]);
    }
}

module shell() {
    tablet(W, H, L, R, TH, TH, TH);
}

module case_back() {
    difference() {
        shell();
        tablet_cavity(false);
        
        // side clearances
        h = 40;
        translate([-W/2, H/4, R*2])
        chamferer(H*1.2)
        cube([W*2, H*3, h]); //L-R*4]);

        translate([W/2, H/4, R*2])
        chamferer(H*1.2)
        cube([W, H*3, L-R*4]);

        translate([-W/2, H/4, L-R*2-h])
        chamferer(H*1.2)
        cube([W*2, H*3, h]); //L-R*4]);

        translate([R*2, .75, -L/2])
        chamferer(H/2)
        cube([W-R*4, H*2, L*2]);

        // hinge gap
        translate([-H-.52, -H/2, 0])
        cube([H, H*2, L]);

    }
}

module case_lid() {
    difference() {
        shell();
        tablet_cavity(true);

        // hinge gap
        translate([-H-.52, -H/2, 0])
        cube([H, H*2, L]);

    }

    translate([0, 5.5, -R*.5 -.35])
    cube([W, 2, .4]);
}

HINGE_TH      = 4.5;
HINGE_X       = -HINGE_TH/2-1.25 +.2;
HINGE_SPACING = 3.45           -.4 -.3;
HINGE_DY      = -1             +.4 +.3;
HINGE_Y       = HINGE_TH + HINGE_SPACING + HINGE_DY;

HINGE_ANGLE   = 10;

module hinges() {
    n  = 30;
    l0  = L -R*2 ;
    lh = l0/n;
    l = l0 + lh;
    l1 = l0 - lh/n*2;

    // hinges
    difference() {
        union() {
            // body side
            translate([0, HINGE_TH/2 + HINGE_DY -HINGE_Y, R])
            hinge4(thickness=HINGE_TH, arm_length=HINGE_TH-2+.3,
                   total_height=l, nb_layers=n, angle=90);

            // lid side
            difference() {
                rotate([0, 0, HINGE_ANGLE])
                translate([0, 0, R])
                scale([1, -1, 1])
                hinge4(thickness=HINGE_TH, arm_length=HINGE_TH-2-.25+.6,
                       total_height=l, nb_layers=n, angle=90+HINGE_ANGLE);

                // shave branch
                rotate([0, 0, HINGE_ANGLE])
                translate([-HINGE_X-1.05, H*.51 -HINGE_Y, 0])
                cube([1, H*.37, L*2]);

                translate([-HINGE_X-1.05, -H*.34, 0])
                cube([1, H*.35, L*2]);
            }
        }
        
        // shave top
        translate([-HINGE_X, -HINGE_Y, R+l1])
        cylinder(r=H*2, h=L);
    }

    // body reinforcement
    translate([-HINGE_X, -HINGE_Y, 0])
    hull() {
        translate([-HINGE_TH/4+.6, HINGE_DY, R])
        cube([H/3, ATOM, l1]);

        translate([-HINGE_TH/4+.6, HINGE_DY, R])
        cube([ATOM, HINGE_TH/2, l1]);
    }

    // lid reinforcement
    rotate([0, 0, HINGE_ANGLE])
    translate([0, -HINGE_Y, 0])
    hull() {
        translate([-HINGE_X-HINGE_TH/4+.6, HINGE_DY+HINGE_TH*1.5+HINGE_SPACING-ATOM, R])
        cube([H/1.5, ATOM, l1]);

        translate([-HINGE_X-HINGE_TH/4+.6, HINGE_DY+HINGE_TH*1+HINGE_SPACING-ATOM+GAP, R])
        cube([ATOM+1, HINGE_TH/2-GAP, l1]);
    }
    
}

intersection() {
    union() {
        translate([-HINGE_X, -HINGE_Y, 0])
        case_back();

        rotate([0, 0, HINGE_ANGLE])
        translate([-HINGE_X, -HINGE_Y, 0])
        case_lid();

        hinges();
    }

//    if ($preview) cylinder(r=W*2, h=L/2);
}


// grain to make case levitate
translate([H, H, -R]) cube([1, .4, .3]);
