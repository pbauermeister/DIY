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
            // phone
            chamferer(ch)
            cube([l, th, w]);

            // screen clearance
            translate([0, -th+ATOM, 0])
            chamferer(ch)
            cube([l, th, w]);

            // buttons clearance
            x = 26;
            dx = 44;
            hull() {
                for (z=[0, th/2])
                for (y=[th/2, -th/2]) {
                    translate([x, y, w+z])
                    rotate([0, 90, 0])
                    cylinder(d=th, h=dx);
                }
            }
            
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

module power_bank(w=BANK_WIDTH, l=BANK_LENGTH, d=BANK_DIAMETER, h=BANK_HEIGHT) {
    side_extension = WALL*3;
    intersection() {
        hull() {
            dd=(l - d)/2;
            fn = $preview ? 24 : 180;
            translate([-dd, 0, 0]) cylinder(d=d, h=h+side_extension, $fn=fn);
            translate([+dd, 0, 0]) cylinder(d=d, h=h+side_extension, $fn=fn);           
        }
        cube([l*2, w, h*4], center=true);
    }
}

module cavity() {
    dx = (PHONE_CASE_L - BANK_HEIGHT)/2;
    dy = PHONE_CASE_TH + PHONE_CASE_Y;
    dz = (PHONE_W - BANK_LENGTH)/2;
    pb_dy = -2;
    h=(PHONE_CASE_L - BANK_HEIGHT);

    difference() {
        union() {
            // power bank
            translate([-BANK_HEIGHT/2 + dx+1, BANK_WIDTH/2 + dy + pb_dy, BANK_LENGTH/2 + dz])
            rotate([0, 90, 0])
            power_bank();

            // cable stash
            translate([-BANK_HEIGHT/2 + dx -h, BANK_WIDTH/2 + dy + pb_dy, BANK_LENGTH/2 + dz]) 
            rotate([0, 90, 0])
            power_bank(h=h+ATOM);

            // phone
            translate([0, ATOM, 1.5])
            phone_cavity(back_extension=BANK_WIDTH/2);
        }

        // separatior
        translate([-BANK_HEIGHT*1.5 + dx+1, BANK_WIDTH/4 + dy + pb_dy, dz-WALL/2]) 
                cube([BANK_HEIGHT,
                      WALL*2, BANK_LENGTH+WALL], center=!true);
    }
}

!cavity();

module boombox() {
    difference() {
        dz = (PHONE_W - BANK_LENGTH)/2;
        h = BANK_LENGTH;
        xz = WALL*2.7;
        dy = 1;
        l = PHONE_CASE_L + WALL*2;

        chamferer(CH, fn=FN)
        translate([-l/2, -dy, dz - xz/2 -1.25])
        cube([l, PHONE_CASE_Y+PHONE_CASE_TH + BANK_WIDTH+dy+WALL, h+xz]);
        
        cavity();
    }
}

rotate([0, $preview ? 0 : -90, 0])
boombox();