use <../chamferer.scad>
use <../hinge4.scad>

/*
v Batt more play
- Batt rear opening
- Phone
    - hinge more space
    - wedge at ends
    - left finger pusher hole
- right side lock: rotating half knob
- Buttons clearance, not holes

*/


BATT_L              = 147;
BATT_W              = 108.2;
BATT_TH             =  37;

PHONE_L             = 163.3;
PHONE_W             =  77;
WALL                =   3.5;

L                   = PHONE_L + WALL*2 + BATT_W - 105;
W                   = BATT_W  + WALL*2;
TH                  = BATT_TH + WALL*2 + 18.2;
CH                  = WALL * 1.25;

CASE_BORDER         =   4;
CASE_L              = PHONE_L + CASE_BORDER*2;
CASE_W              = PHONE_W + CASE_BORDER*2;
CASE_TH             =  21;
CASE_Y              =   1.2;
CASE_ADJ_Y          =  -2;

BANK_PLAY           =   0.4                                     +1;
BANK_LENGTH         =  87.9 + BANK_PLAY;
BANK_WIDTH          =  30.0 + BANK_PLAY;
BANK_D              =  54.0;
BANK_HEIGHT         = 139.5 + BANK_PLAY;

BANK_LENGTH_ADJ     =  -0.5;
BANK_POS_Z_ADJ      =   3;
BANK_POS_Y_ADJ      =   4.3;

BOOMBOX_DY          =   1;
BOOMBOX_XZ2         =   4;
BOOMBOX_XZ          = WALL*2.7 + BOOMBOX_XZ2;
BOOMBOX_XX          =   8;

BOOMBOX_H           = BANK_LENGTH + BOOMBOX_XZ;
BOOMBOX_W           = CASE_Y+CASE_TH + BANK_WIDTH + BOOMBOX_DY + WALL + 0.9;
BOOMBOX_L           = CASE_L + WALL*2 + BOOMBOX_XX;

HINGE_D             =   4;
HINGE_Z             =  77.6;
HINGE_Y             = BOOMBOX_W - BOOMBOX_DY - HINGE_D/2;
HINGE_L             = BOOMBOX_L;
HINGE_PLAY          =   0.25;
HINGE_NB_LAYERS     =  24;
HINGE2_L            = BOOMBOX_L;

HANDLE_AXIS_D1      =   3.8;
HANDLE_AXIS_D2      =   2.5;

PAD_POS_X           = (WALL*2 + BOOMBOX_XX/2) *.5;
PAD_D               =   3;

FOOT_W              =  15;
FOOT_ANGLE          =  90;

SNAPPER_D           =   3.7;

CLIP_L              = 22;


ATOM                =   0.02;
FN                  = $preview? 8 : 60;
PLAY                =   0.1;

$fn = FN;

////////////////////////////////////////////////////////////////////////////////
// Helpers

module pad(scale_z=.5) {
    hull() for (kx=[-1, 1])
        translate([kx * PAD_D, 0, 0])
        scale([1, 1, scale_z])
        sphere(d=PAD_D);
}

/*
module marks(l=BOOMBOX_L, w=BOOMBOX_W, h=BOOMBOX_H) {
    n  = 6;
    m  = 3;
    ch = .75;

    for (i=[0:n-1]) {
        for (j=[0:m-1]) {
            translate([i*l/n + (i==0 ? -ch*10 : 0), 0, 0])
            chamferer(ch, fn=16)
            intersection() {
                chamferer(CH, tool="cylinder-x", fn=FN)
                cube([l/n + (i==n-1 || i==0 ? ch*10 : 0), w, h]);
                
                translate([0, 0, h/m*j])
                cube([l/n + (i==n-1 || i==0 ? ch*10 : 0), w, h/m]);
            }
        }
    }
    
    chamferer(ch*2, fn=8, grow=false)
    cube([l, w, h]);
}
*/

module box(l=BOOMBOX_L, w=BOOMBOX_W, h=BOOMBOX_H) {
    intersection() {
        // box
        chamferer(CH, tool="cylinder-x", fn=FN)
        cube([l, w, h]);

        // marks
//        marks(l, w, h);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Cavities

module screen_cavity(l, th, w) {
    fn   = $preview ? 8 : 120;
    ch   = 3.5;
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

module phone_cavity(back_extension=0, side_extension=0) {
    l  = PHONE_L;
    w  = PHONE_W;
    th = 9;
    ch = 3.5;
    // case
    bor = CASE_BORDER;
    cy  = 1.2;
    cth = CASE_TH;
    xz  = 5.5;
    xy  = 2;

    translate([-l/2, 0, 0]) {
        // screen
        translate([0, 0, -1])
        screen_cavity(l, th, w);

        // buttons clearance
        x  = 26;
        dx = 44;
        for (x=[8, 19-1, 37])
            translate([26+x, -1 + 6.5, 0])
            cylinder(d=5, h=CASE_W*3);

        // chamber
        reserve = .33;
        difference() {
            translate([-bor - reserve, cy, -bor])
            cube([l + bor*2 + reserve*2+side_extension, cth+back_extension, w + bor*2]);
        }

        // phone case hinge cavity
        translate([-bor - reserve, cy+xy, -bor-xz + 2 +.2 + CASE_ADJ_Y])
        cube([l + bor*2 + reserve*2 + side_extension, cth-xy+back_extension, xz+ATOM]);
    }
}

module power_bank(w=BANK_WIDTH, l=BANK_LENGTH, d=BANK_D, h=BANK_HEIGHT,
                  side_extension=0) {
    // battery
    translate([-1, 0, 0])
    intersection() {
        hull() {
            dd=(l - d)/2 + BANK_LENGTH_ADJ -BANK_PLAY/2;
            fn = $preview ? 24 : 180;
            translate([-dd, 0, 0]) cylinder(d=d+BANK_PLAY, h=h+side_extension, $fn=fn);
            translate([+dd, 0, 0]) cylinder(d=d+BANK_PLAY, h=h+side_extension, $fn=fn);
        }
        cube([l*2, w, h*4], center=true);
    }
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

            translate([0, BANK_POS_Y_ADJ, BANK_POS_Z_ADJ])
            {
                // power bank
                translate([-BANK_HEIGHT/2 + dx, w, l])
                rotate([0, 90, 0])
                power_bank(side_extension=(BOOMBOX_XX+WALL)*2);

                if (0)
                %translate([-BANK_HEIGHT/2 + dx, w, l])
                rotate([0, 90, 0])
                power_bank();


                // cable stash
                translate([-BANK_HEIGHT/2 + dx -h, w, l])
                rotate([0, 90, 0])
                power_bank(h=h*2);
            }

            // phone
            translate([0, ATOM, 1.5 + phone_tune_z])
            phone_cavity(back_extension=BANK_WIDTH/5.45*0, side_extension=(BOOMBOX_XX+WALL)*2);
        }

        // separator
        translate([-BANK_HEIGHT*1.5 + dx, BANK_WIDTH/4 + dy + pb_dy - 3.2, dz-BANK_LENGTH/2])
                cube([BANK_HEIGHT,
                      WALL, BANK_LENGTH*2]);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Boombox drafts

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
                translate([-l/2, -dy, z])
                box(l, w, h);

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
    }
}

module boombox_1(inv_hinge) {
    boombox_0();

    // wedge
    dl  = 15;
    l   = CASE_L +1 -dl;
    l2  = CASE_L;
    th  =  1;
    th2 =  5;
    y   = 15.2;
    z   =  2.4;
    hull() {
        // tip
        translate([0, - HINGE_Y + y, -z + CASE_ADJ_Y])
        translate([-l/2 - dl/2, -th/2, 0])
        cube([l, th, 6+z]);

        // base
        translate([0, - HINGE_Y + y, -1.9])
        translate([-l2/2, -th2/2, 2])
        cube([l2, th2, 2.2]);
    }
}

////////////////////////////////////////////////////////////////////////////////
// Foot

module foot() {
    a = -120 + FOOT_ANGLE;
    rotate([0, 90, 0])
    scale([1, 1, -1]) translate([0, 0, -HINGE2_L])
    rotate([0, 0, 180+60 -30])
    hinge4(thickness=HINGE_D, arm_length=HINGE_D + HINGE_PLAY*2,
           total_height=HINGE2_L,
           nb_layers=HINGE_NB_LAYERS * ($preview ? 2 : 1),
           angle=180 +a +30,
           with_plate=false);

    // rotating foot
    l = 19.65;
    h = l*sin(30);
    intersection() {
        difference() {
            hull() {
                rotate([a - 210, 0, 0])
                translate([0, -l, -HINGE_D/2])
                cube([HINGE2_L, l-HINGE_D, HINGE_D]);

                rotate([a + 120, 0, 0])
                translate([0, -HINGE_D/2 - HINGE_PLAY*1.5, -l*sin(30) - HINGE_D/2 +.27])
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
            translate([-HINGE2_L/2, +d/2, +d/2 -.5])
            cube([HINGE2_L*2, d*2, d]);
        }

        rotate([a - 210, 0, 0])
        translate([0, -FOOT_W, -FOOT_W])
        cube([HINGE2_L, FOOT_W*2, FOOT_W*2]);
    }
    
    // foot pad
    rotate([a + 120, 0, 0]) {
        for (x=[PAD_POS_X, HINGE2_L-PAD_POS_X])
            translate([x, -l*.3, -h-HINGE_D/2+.2])
            pad();
    }
}

module foot_cut() {
    // rotating chamber
    w = FOOT_W*2 + .9;
    xh = 1;
    rotate([30, 0, 0])
    translate([-HINGE_PLAY, -w/2, -HINGE_D/2 - HINGE_PLAY - xh])
    cube([HINGE2_L+HINGE_PLAY*2, w, HINGE_D + HINGE_PLAY*3.2 + xh]);
}

////////////////////////////////////////////////////////////////////////////////
// Final boombox

module boombox(inv_hinge=false) {

    // body w/o foot
    difference() {
        translate([0, 0, HINGE_Z])
        boombox_1(inv_hinge);
        
        translate([-HINGE2_L + BOOMBOX_L/2, 0, -BOOMBOX_XZ2/2])
        foot_cut();
    }

    // foot
    scale([inv_hinge ? 1 : -1, 1, 1])
    translate([-HINGE2_L + BOOMBOX_L/2, 0, -BOOMBOX_XZ2/2])
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

                y2 = -BOOMBOX_DY + BOOMBOX_W * .735 + 0.815;
                translate([side*k, y2, z + 1.72])
                rotate([30, 0, 0])
                pad(scale_z=.95);
            }
        }
    }
}

module final_rotate(force=false) {
    if (!force && $preview && !CROSSCUT)
        children();
    else
        translate([0, 0, BOOMBOX_L/2])
        rotate([0, -90, 0])
        rotate([0, CROSSCUT || force ? 180 : 0, 0])
        children();
}

module final_cut(layer) {
    translate([0, 0, -layer * BOOMBOX_L/3])
    intersection() {
       
        children();
        translate([0, 0, layer * BOOMBOX_L/3])
        cylinder(r=BOOMBOX_H*2, h=BOOMBOX_L/3);
    }
}

module segment(layer, inv_hinge=false) {
    final_cut(layer)
    final_rotate(true)
    boombox(inv_hinge);
}

CROSSCUT            = !true;

//translate([0, -BOOMBOX_W+4, 0]) %cube([BOOMBOX_L*3, 20, 20]);

difference() {
    final_rotate()
    boombox();

    // cross-cut
    if (CROSSCUT)
        //translate([0, 0, 21.5 +2])
        translate([0, 0, -1])
        cylinder(d=1000, h=BOOMBOX_L+1 - 24);
    
    //translate([-50, -15+3.32, -50]) cube(500);
}