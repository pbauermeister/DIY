use <../chamferer.scad>
use <../hinge4.scad>

CROSSCUT            = true;

BATT_L              = 146           +1;
BATT_W              = 108           +0.2;
BATT_TH             =  39           -2;

PHONE_L             = 163           +.3;
PHONE_W             =  77;
WALL                =   3.5;

L                   = PHONE_L+WALL*2 + (BATT_W-77)              -28;
W                   = BATT_W+WALL*2;
TH                  = 9 + BATT_TH + 14.2 + WALL*2               - 5;
CH                  = WALL*1.25;

CASE_BORDER         =   4;
CASE_L              = PHONE_L + CASE_BORDER*2;
CASE_W              = PHONE_W + CASE_BORDER*2;
CASE_TH             =  21;
CASE_Y              =   1.2;

BANK_PLAY           =   0.2 + .2;
BANK_LENGTH         =  86.5 + BANK_PLAY + 1.4;
BANK_WIDTH          =  30.0 + BANK_PLAY;
BANK_D              =  54.0;
BANK_HEIGHT         = 137.5 + BANK_PLAY + 1  +1;

BANK_LENGTH_ADJ     =  -0.5;
BANK_POS_Z_ADJ      =   1;
BANK_POS_Y_ADJ      =  -0.7;

BOOMBOX_DY          = 1;
BOOMBOX_XZ          = WALL*2.7;
BOOMBOX_XX          = 24;

BOOMBOX_H           = BANK_LENGTH + BOOMBOX_XZ;
BOOMBOX_W           = CASE_Y+CASE_TH + BANK_WIDTH + BOOMBOX_DY + WALL -2 +1  +3.9 +1;
BOOMBOX_L           = CASE_L + WALL*2 + BOOMBOX_XX;

HINGE_D             = 4;
HINGE_Z             = 73    + 4.6;
HINGE_Y             = BOOMBOX_W - BOOMBOX_DY - HINGE_D/2;
HINGE_L             = BOOMBOX_L;
HINGE_PLAY          = .25;

HINGE_NB_LAYERS     = CROSSCUT ? 16*3 : 10*3;

HINGE2_L            = BOOMBOX_L;

HANDLE_AXIS_D1      = 3.2;
HANDLE_AXIS_D2      = 2.2                               +.3;

PAD_POS_X           = (WALL*2 + BOOMBOX_XX/2) *.5;
PAD_D               =   3;

FOOT_W              =  15;
FOOT_ANGLE          =  90;

SNAPPER_D           =   4                  -.2  -.1  -.1;

ATOM                = .02;
FN                  = $preview? 8 : 60;
PLAY                = .1;
$fn = FN;

module screen_cavity(l, th, w) {
    fn = $preview ? 8 : 120;
    ch = 3.5;
    hbor = 1;
    vbor = 2;

    // phone
    chamferer(ch, fn=fn)
    translate([-hbor, 0, -vbor])
    cube([l + hbor*2, th, w + vbor*2]);

    // screen clearance external chamfer
    translate([0, -th*2+ATOM -.4, 0])
    chamferer(ch, fn=fn)
    chamferer(.5, tool="cube", shrink=false)
    translate([-hbor, 0, -vbor])
    cube([l + hbor*2, th*2, w + vbor*2]);

    // screen hole
    translate([0, -th/2, 0])
    chamferer(ch/2+.3 -.7, fn=fn)
    chamferer(ch/2+.3, tool="cube", grow=false)
    translate([-hbor, 0, -vbor])
    cube([l + hbor*2, th, w + vbor*2]);
}

module phone_cavity(back_extension=0) {
    l = PHONE_L;
    w = PHONE_W;
    th = 9;
    ch = 3.5;
    // case
    bor =  CASE_BORDER;
    cy  =  1.2;
    cth = CASE_TH;
    xz  =  5.5;
    xy =   2;

    translate([-l/2, 0, 0]) {
        // screen
        translate([0, 0, -1])
        screen_cavity(l, th, w);

        // buttons clearance
        x = 26;
        dx = 44;
        for (x=[8, 19, 37])
            translate([26+x, -1 + 6.5, 0])
            cylinder(d=5, h=CASE_W*3);

        // USB clearance
        pl = 18;
        translate([l/2, 1 + 1.5, w/2-pl/2])
        cube([l, th, pl]);

        // chamber
        reserve = .33;
        difference() {
            translate([-bor - reserve, cy, -bor])
            cube([l + bor*2 + reserve*2, cth+back_extension, w + bor*2]);

            // alignment pads
            r = 3;
            z = 20;
            for (x=[l + bor + r, -r - bor]) {
                difference() {
                    hull() {
                        translate([x, 0, z-3])
                        rotate([90, 0, 0])
                        cylinder(r=r, h=cth, $fn=60, center=true);

                        translate([x, 0, z+3])
                        rotate([90, 0, 0])
                        cylinder(r=r, h=cth, $fn=60, center=true);

                        translate([x, 0, z])
                        rotate([90, 0, 0])
                        cylinder(r=r-reserve, h=cth*2, $fn=60, center=true);

                        translate([x, -r/2, z])
                        rotate([90, 0, 0])
                        cylinder(r=r, h=cth*2, $fn=60, center=true);
                    }

                    for (dz=[-3-r : .4 : 3+r])
                    translate([x, 0, z+dz])
                     cube([30, cth*2, .1], center=true);
                }
            }
        }

        translate([-bor - reserve, cy+xy, -bor-xz + 2 +.2])
        cube([l + bor*2 + reserve*2, cth-xy+back_extension, xz+ATOM]);
    }
}

module power_bank(w=BANK_WIDTH, l=BANK_LENGTH, d=BANK_D, h=BANK_HEIGHT,
                  with_extension=false) {
    // battery
    translate([-BANK_POS_Z_ADJ, 0, 0])
    intersection() {
        hull() {
            dd=(l - d)/2 + BANK_LENGTH_ADJ;
            fn = $preview ? 24 : 180;
            translate([-dd, 0, 0]) cylinder(d=d, h=h, $fn=fn);
            translate([+dd, 0, 0]) cylinder(d=d, h=h, $fn=fn);
        }
        cube([l*2, w, h*4], center=true);
    }

    // cables clearance
    if (with_extension) difference() {
        translate([0, 0, h])
        cube([l - 6,12, h], center=true);

        // shave power button clearance, lower side
        gap = 6;
        translate([-l/2 + 28-2, 0, h*1.5+ATOM + gap])
        cube([10, 12*2, h], center=true);

        // shave power button clearance, upper side
        translate([-l/2 +1+3-ATOM, 0, h*1.5+ATOM])
        cube([2, 12*2, h], center=true);
    }

    // reinforcement cracks
    dy = WALL + BOOMBOX_XX/2 -2  -4;
    th = 0.1;
    for (x=[-5+.25: .3 + th : 5])
        translate([-l/2 + 28-2 +x, -6 -3*4, h+2 +4])
        cube([th, 12 + 6*4, dy-2]);
}

module cavity() {
    dx = (CASE_L - BANK_HEIGHT)/2;
    dy = CASE_TH + CASE_Y;
    dz = (PHONE_W - BANK_LENGTH)/2;
    pb_dy = -2;
    h=(CASE_L - BANK_HEIGHT);

    phone_tune_z = -5.5/2;

    difference() {
        union() {
            w = BANK_WIDTH/2 + dy + pb_dy;
            l =  BANK_LENGTH/2 + dz;

            translate([0, BANK_POS_Y_ADJ, 0])
            {
                // power bank
                translate([-BANK_HEIGHT/2 + dx, w, l])
                rotate([0, 90, 0])
                power_bank(with_extension=true);

                // cable stash
                translate([-BANK_HEIGHT/2 + dx -h, w, l])
                rotate([0, 90, 0])
                power_bank(h=h*2);
            }

            // phone
            translate([0, ATOM, 1.5 + phone_tune_z])
            phone_cavity(back_extension=BANK_WIDTH/5.45);
        }

        // separator
        translate([-BANK_HEIGHT*1.5 + dx, BANK_WIDTH/4 + dy + pb_dy, dz-BANK_LENGTH/2])
                cube([BANK_HEIGHT,
                      WALL, BANK_LENGTH*2]);
        if(0)
        translate([-BANK_HEIGHT*.5 + dx - WALL, BANK_WIDTH/4 + dy + pb_dy, dz-BANK_LENGTH/2])
                cube([WALL, BANK_WIDTH, BANK_LENGTH*2]);
    }
}

module pad(scale_z=.5) {
    hull() for (kx=[-1, 1])
        translate([kx * 3, 0, 0])
        scale([1, 1, scale_z])
        sphere(d=PAD_D);
}

module handle_axis_holes() {
    dx = (WALL*2 + BOOMBOX_XX)/4;
    for (z_d_c=[[-22+1, HANDLE_AXIS_D1, false], [4+.3, HANDLE_AXIS_D2, true]])
    for (k=[-1, 1]) {
        z = z_d_c[0];
        d = z_d_c[1];
        c = z_d_c[2];
        translate([(CASE_L/2 + dx)*k, -HINGE_Y + BOOMBOX_W/2, z]) {
            rotate([0, 90, 0])  {
                // through hole
                translate([0, 0, k*2])
                cylinder(d=d, h=dx*2, center=true);

                // reinforcement cracks rings
                if (c)
                if (!$preview)
                for (d2=[d : .3+.2 +1: d*2.2]) {
                    difference() {
                        cylinder(d=d2+.2, h=dx*2, center=true);
                        cylinder(d=d2, h=dx*2.5, center=true);
                    }
                }
            }
        }
    }
}

module boombox_0(upper=false) {
    difference() {
        dz = (PHONE_W - BANK_LENGTH)/2;
        xz = BOOMBOX_XZ;
        h  = BOOMBOX_H;
        xx = BOOMBOX_XX;
        dy = BOOMBOX_DY;
        z  = dz - xz/2 -1.25;
        l = BOOMBOX_L;
        w = BOOMBOX_W;
        translate([0, -HINGE_Y, -HINGE_Z]) {

            difference() {
                // box
                union() {
                    chamferer(CH, tool="cylinder-x", fn=FN)
                    translate([-l/2, -dy, z])
                    cube([l, w, h]);

                    // back foot
                    r = 10;
                    h2 = r*3;
                    if(0)
                    translate([0, w, r*.85-CH])
                    hull() {
                        rotate([0, 90, 0])
                        cylinder(r=r, h=h2, $fn=100, center=true);
                        translate([0, -r/2, -r])
                        rotate([0, 90, 0])
                        cylinder(r=ATOM, h=h2+r*5, $fn=100, center=true);
                    }
                }

                // slanted bottom-back corner 70°
                py = 20-2;
                translate([0, -dy+w-py, z])
                rotate([30, 0, 0])
                translate([-l, -5, -w*2])
                cube([l*2, w*2, w*2]);

                // cavity
                cavity();
            }
        }

        // hinge clearance
        translate([0, -.25, 0])
        rotate([-45, 0, 0])
        translate([-BOOMBOX_L, 0, 0])
        cube([BOOMBOX_L*2, HINGE_D*sqrt(2), HINGE_D*sqrt(2)]);

        translate([0, HINGE_D/2, 0])
        cube([HINGE_L+HINGE_PLAY*2, HINGE_D, HINGE_D  + HINGE_PLAY*2], center=true);

        // handle axis
        handle_axis_holes();

        // finger grooves
        d = 6;
        if (!upper)
        for (kx=[1, -1]) hull() for (dy=[-4.5, 4.5])
            translate([BOOMBOX_L/2 * kx, -BOOMBOX_W * .69 + dy, 0])
            rotate([0, -50, 0])
            scale([1.5*2, 1, 4])
            sphere(d=d, $fn=4);
    }
}

module partitioner(upper=false) {
    h = BOOMBOX_H*2;
    shift = (upper ? PLAY : -PLAY);
    translate([0, 0, -h + shift])
    cylinder(d=1000, h=h);

    // slanted front
    a = 30;
    translate([0, -BOOMBOX_W + CH + 2 + shift + sin(a)*WALL*1.5, -PLAY])
    rotate([a, 0, 0])
    translate([-BOOMBOX_L, -BOOMBOX_W, 0])
    cube([BOOMBOX_L*2, BOOMBOX_W, BOOMBOX_H]);

    // snappers
    d = SNAPPER_D;
    for (k=[-1, 1]) {
        translate([(CASE_L/2 + (WALL + BOOMBOX_XX/2)/2)*k,
                   -BOOMBOX_W + CH + 2 + shift,
                   d]) {
            hull() for (i=[-1,1]) {
                translate([i*1, 0, 0])
                sphere(d=d + (upper?PLAY*2:0));
            }
        }
    }
}

module boombox_1() {
    difference() {
        union() {
            // lower
            intersection() {
                boombox_0();
                partitioner();
            }

            // upper
            rotate([-90, 0, 0])
            union() {
                difference() {
                    boombox_0(true);
                    partitioner(true);
                }
                
                // wedge
                l = CASE_L+1  -15;
                l2 = CASE_L+1  -1;
                th = 3      +2          -4;
                th2 = 6     +2;
                y = 17.5                -2.5;
                z = -.1     +3;
                hull() {
                    translate([0, - HINGE_Y + y, -z])
                    translate([-l/2, -th/2, 0])
                    cube([l, th, 6+z]);

                    translate([0, - HINGE_Y + y, -1.9])
                    translate([-l2/2, -th2/2, 2])
                    cube([l2, th2, 2.2]);
                    }
            }
        }

        // hinge cavity
        rotate([0, 90, 0])
        cylinder(d=HINGE_D+HINGE_PLAY*2, h=HINGE_L+HINGE_PLAY*2, center=true);
    }

    // hinge
    rotate([0, 90, 0])
    scale([1, 1, CROSSCUT ? -1 : 1]) translate([0, 0, -HINGE_L/2])
    hinge4(thickness=HINGE_D, arm_length=HINGE_D/2 + HINGE_PLAY*2,
           total_height=HINGE_L,
           nb_layers=HINGE_NB_LAYERS, angle=90, extra_angle=0);
}

module foot() {
    a = -120 + FOOT_ANGLE;

    rotate([0, 90, 0])
    scale([1, 1, -1]) translate([0, 0, -HINGE2_L])
    rotate([0, 0, 180+60])
    hinge4(thickness=HINGE_D, arm_length=HINGE_D + HINGE_PLAY*2,
           total_height=HINGE2_L,
           nb_layers=HINGE_NB_LAYERS, angle=180 +a,
           with_plate=false);

    // rotating foot
    l = 15 + 4.65;
    h = l*sin(30);
    intersection() {
        difference() {
            hull() {
                rotate([a - 210, 0, 0])
                translate([0, -l, -HINGE_D/2])
                cube([HINGE2_L, l-HINGE_D, HINGE_D]);

                rotate([a + 120, 0, 0])
                translate([0, -HINGE_D/2 - HINGE_PLAY/2, -l*sin(30) - HINGE_D/2 +.27])
                cube([HINGE2_L, ATOM, h-HINGE_D*.4]);
            }

            // gripping groove
            d = 3;
            r = l - HINGE_D/2;
            rotate([a + 120, 0, 0])
            rotate([30, 0, 0])
            translate([0, -r, 0])
            translate([0, d/2, -HINGE_D*.6])
            rotate([45, 0, 0])
            translate([-HINGE2_L/2, -d/2, -d/2])
            cube([HINGE2_L*2, d, d]);

            // chamfer corner
            rotate([a + 120, 0, 0])
            rotate([30, 0, 0])
            translate([0, -r, 0])
            translate([0, d/2, -HINGE_D*.6])
            rotate([45, 0, 0])
            translate([-HINGE2_L/2, -d/2*-1.5, -d/2*-1])
            cube([HINGE2_L*2, d, d]);

        }

        rotate([a - 210, 0, 0])
        translate([0, -FOOT_W, -FOOT_W])
        cube([HINGE2_L, FOOT_W*2, FOOT_W*2]);

    }
    
    // pad
    rotate([a + 120, 0, 0]) {
        for (x=[PAD_POS_X, HINGE2_L-PAD_POS_X])
            translate([x, -l*.3, -h-HINGE_D/2+.2])
            pad();
    }
}

module foot_cut() {
    // rotating chamber
    w = FOOT_W*2 + .9;
    rotate([30, 0, 0])
    translate([-HINGE_PLAY, -w/2, -HINGE_D/2 - HINGE_PLAY])
    cube([HINGE2_L+HINGE_PLAY*2, w, HINGE_D + HINGE_PLAY*3.2]);
}

module boombox() {
    // body w/o foot
    difference() {
        translate([0, 0, HINGE_Z])
        boombox_1();
        
        translate([-HINGE2_L + BOOMBOX_L/2, 0, 0])
        foot_cut();
    }

    // foot
    scale([CROSSCUT ? 1 : -1, 1, 1])
    translate([-HINGE2_L + BOOMBOX_L/2, 0, 0])
    foot();

    // pads
    translate([0, -HINGE_Y, 0]) {
        dx = PAD_POS_X;
        z  = (PHONE_W - BANK_LENGTH)/2 - BOOMBOX_XZ/2 -1.25;
        for (k=[1, -1]) {
            color("red") {
                side = -BOOMBOX_L/2 + dx;
                y = -BOOMBOX_DY + CH*1.25;
                translate([side*k, y, z]) pad();

                y2 = -BOOMBOX_DY + BOOMBOX_W * .735     +.85 +.15       -.085  -.1;
                translate([side*k, y2, z + .9 +         .75 +.07])
                rotate([30, 0, 0])
                pad(scale_z=.95);
            }
        }
    }
}

if ($preview) {
    boombox();
}
else {
    difference() {
        translate([0, 0, BOOMBOX_L/2])
        rotate([0, -90, 0])
        rotate([0, CROSSCUT ? 180 : 0, 0])
        boombox();

        // cross-cut
        if (CROSSCUT)
            translate([0, 0, 21.5 +2]) cylinder(d=1000, h=BOOMBOX_L);
    }
}
