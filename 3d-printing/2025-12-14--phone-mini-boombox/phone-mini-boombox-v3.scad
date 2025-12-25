use <../chamferer.scad>

BATT_L      = 146           +1;
BATT_W      = 108           +0.2;
BATT_TH     =  39           -2;

PHONE_L     = 163           +.3;
PHONE_W     =  77;
WALL        =   3.5;
BEXTEND     =  30           *0;

SCREW_DIST  = 127.5;


L    = PHONE_L+WALL*2 + (BATT_W-77)            -28;
W    = BATT_W+WALL*2;
TH   = 9+BATT_TH  +14.2 + WALL*2 + BEXTEND      -5;

CH   = WALL*1.25;

ATOM = .02;
FN   = $preview? 8 : 60;

echo(TH);

PHONE_CASE_L  = PHONE_L + 4*2;
PHONE_CASE_TH = 21;
PHONE_CASE_W  = PHONE_W + 4*2;

module phone_cavity(back_extension=0, just_case=false) {
    l = PHONE_L;
    w = PHONE_W;
    th = 9;
    ch = 3.5;
    // case
    bor =  4;
    cy  =  1.2;
    cth = PHONE_CASE_TH;
    xz  =  5.5;
    xy =   2;

    translate([-l/2, 0, 0]) {
        if (!just_case) {
            fn = $preview ? 8 : 120;

            // phone
            chamferer(ch, fn=fn)
            cube([l, th, w]);

            // screen clearance external chamfer
            translate([0, -th*2+ATOM -.4, 0])
            chamferer(ch, fn=fn)
            chamferer(.5, tool="cube", shrink=false)
            cube([l, th*2, w]);

            // screen hole
            translate([0, -th/2, 0])
            chamferer(ch/2+.3 -.7, fn=fn)
            chamferer(ch/2+.3, tool="cube", grow=false)
            cube([l, th, w]);

            // buttons clearance
            x = 26;
            dx = 44;
            if (0)
            hull() {
                for (z=[0, th/2])
                for (y=[th/2, -th/2]) {
                    translate([x, y, w+z])
                    rotate([0, 90, 0])
                    cylinder(d=th, h=dx);
                }
            }
            for (x=[8, 19, 37])
                translate([26+x, -1 + 6.5, 0])
                cylinder(d=5, h=PHONE_CASE_W*3, $fn=50);
            
            // USB clearance
            pl = 18;
            translate([l/2, 1 + 1.5, w/2-pl/2])
            cube([l, th, pl]);

            translate([-bor, cy, -bor])
            cube([l + bor*2, cth+back_extension, w + bor*2]);

            translate([-bor, cy, -bor])
            cube([l + bor*2, cth+back_extension, w + bor*2]);

            translate([-bor, cy+xy, -bor-xz + 2 +.2])
            cube([l + bor*2, cth-xy+back_extension, xz+ATOM]);

            // side extension
            dy = 10;
            side_extension = WALL*3;
            if (0)
            translate([-bor, cy+dy,  -bor-xz + 2 +.2])
            cube([l + bor*2+side_extension, cth+back_extension-dy, w+bor+xz+2-.2]);
        }
        else {
            translate([-bor, cy+cth, -bor])
            cube([l + bor*2, ATOM, w + bor*2]);
            translate([-bor, cy+cth, -bor-xz + 2 +.2])
            cube([l + bor*2, ATOM, xz+ATOM]);
        }
    }
}

BANK_PLAY = .2  + .2;
BANK_LENGTH    =  86.5 + BANK_PLAY + 1.4;
BANK_WIDTH     =  30.0 + BANK_PLAY;
BANK_DIAMETER  =  54.0;
BANK_HEIGHT    = 137.5 + BANK_PLAY + 1;

PHONE_CASE_Y   = 1.2;

module power_bank(w=BANK_WIDTH, l=BANK_LENGTH, d=BANK_DIAMETER, h=BANK_HEIGHT, with_extension=false) {
    side_extension = WALL*3 * 0;
    intersection() {
        hull() {
            dd=(l - d)/2;
            fn = $preview ? 24 : 180;
            translate([-dd, 0, 0]) cylinder(d=d, h=h+side_extension, $fn=fn);
            translate([+dd, 0, 0]) cylinder(d=d, h=h+side_extension, $fn=fn);           
        }
        cube([l*2, w, h*4], center=true);
    }

    // cables clearance
    if (with_extension) difference() {
        translate([0, 0, h])
        cube([l - 3*2,12, h], center=true);

        translate([-l/2 + 28, 0, h+ATOM])
        cube([10, 12*2, h], center=true);
    }
}

module cavity() {
    dx = (PHONE_CASE_L - BANK_HEIGHT)/2;
    dy = PHONE_CASE_TH + PHONE_CASE_Y;
    dz = (PHONE_W - BANK_LENGTH)/2;
    pb_dy = -2;
    h=(PHONE_CASE_L - BANK_HEIGHT);

    phone_tune_z = -5.5/2;

    difference() {
        union() {
            // power bank
            translate([-BANK_HEIGHT/2 + dx, BANK_WIDTH/2 + dy + pb_dy, BANK_LENGTH/2 + dz])
            rotate([0, 90, 0])
            power_bank(with_extension=true);

            // cable stash
            translate([-BANK_HEIGHT/2 + dx -h, BANK_WIDTH/2 + dy + pb_dy, BANK_LENGTH/2 + dz]) 
            rotate([0, 90, 0])
            power_bank(h=h*2);

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

BOOMBOX_DY = 1;
BOOMBOX_XZ = WALL*2.7;
BOOMBOX_XX = 24;

BOOMBOX_H  = BANK_LENGTH + BOOMBOX_XZ;
BOOMBOX_W = PHONE_CASE_Y+PHONE_CASE_TH + BANK_WIDTH + BOOMBOX_DY + WALL -2 +1;
BOOMBOX_L = PHONE_CASE_L + WALL*2 + BOOMBOX_XX;


PLAY = .1;

HINGE_D = 4;
HINGE_Z = 74-1;
HINGE_Y = BOOMBOX_W - BOOMBOX_DY - HINGE_D/2;


module boombox() {
    difference() {
        translate([0, -HINGE_Y, -HINGE_Z])
        difference() {
            dz = (PHONE_W - BANK_LENGTH)/2;
            xz = BOOMBOX_XZ;
            h  = BOOMBOX_H;
            xx = BOOMBOX_XX;
            dy = BOOMBOX_DY;
            z  = dz - xz/2 -1.25;

            l = BOOMBOX_L;
            w = BOOMBOX_W;

            difference() {
                // box
                union() {
                    chamferer(CH, fn=FN)
                    translate([-l/2, -dy, z])
                    cube([l, w, h]);

                    // back foot
                    r = 10;
                    h2 = (l-WALL*4)  *0 + r*3;
                    translate([0, w, r*.85-CH])
                    rotate([0, 90, 0])
                    chamferer(CH, fn=FN)
                    cylinder(r=r, h=h2, center=true);
                }

                // slanted bottom-back corner 70°
                py = 20-2;
                translate([0, -dy+w-py, z])
                rotate([30, 0, 0])
                translate([-l, -5, -w*2])
                cube([l*2, w*2, w*2]);

                // slanted top-back corner 30°
                if (0) %
                translate([0, w - CH/4, h+z - CH/2])
                rotate([10, 0, 0])
                translate([-l, 0, -h*2])
                cube([l*2, w*2, h*2]);
            }
            
            cavity();
        }

        // hinge clearance
        translate([0, -.25, 0])
        rotate([-45, 0, 0])
        translate([-BOOMBOX_L, 0, 0])
        cube([BOOMBOX_L*2, HINGE_D*sqrt(2), HINGE_D*sqrt(2)]);
    }
}

module partitioner(upper=false) {
    h = BOOMBOX_H*2;
    translate([0, 0, -h + (upper ? PLAY : -PLAY)])
    cylinder(d=1000, h=h);
}

//rotate([-30, 0, 0])
rotate([0, $preview ? 0 : -90, 0]) {

    difference() {
        union() {
            // lower
            intersection() {
                boombox();
                partitioner();
            }

            // upper
            rotate([-90, 0, 0])
            difference() {
                boombox();
                partitioner(true);
            }
        }

        // cross-cut
        if ($preview)
            rotate([0, 90, 0])
            cylinder(d=1000, h=1000);
    }
}