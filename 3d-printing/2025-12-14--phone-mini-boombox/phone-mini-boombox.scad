use <../chamferer.scad>

BATT_L      = 146           +1;
BATT_W      = 108           +0.2;
BATT_TH     =  39           -2;

PHONE_L     = 163           +.3;

WALL        =   5;
BEXTEND     =  30           *0;

SCREW_DIST  = 127.5;


L    = PHONE_L+WALL*2 + (BATT_W-77)            -28;
W    = BATT_W+WALL*2;
TH   = 9+BATT_TH  +14.2 + WALL*2 + BEXTEND      -5;

CH   = WALL*1.5;

ATOM = .02;
FN   = $preview? 8 : 60;

echo(TH);

module phone_cavity(back_extension=0, just_case=false) {
    l = PHONE_L;
    w = 77;
    th = 9;
    ch = 3.5;
    // case
    bor =  4;
    cy  =  1.2;
    cth = 21;
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
            translate([l/2, 1, w/2-pl/2])
            cube([l, th, pl]);

            translate([-bor, cy, -bor])
            cube([l + bor*2, cth+back_extension, w + bor*2]);

            translate([-bor, cy+xy, -bor-xz + 2 +.2])
            cube([l + bor*2, cth-xy+back_extension, xz+ATOM]);
        }
        else {
            translate([-bor, cy+cth, -bor])
            cube([l + bor*2, ATOM, w + bor*2]);
            translate([-bor, cy+cth, -bor-xz + 2 +.2])
            cube([l + bor*2, ATOM, xz+ATOM]);
        }
    }
}

module batt_cavity(front_extension=0,
                   back_extension=0) {
    l = BATT_L;
    w = BATT_W;
    th = BATT_TH;
    
    z = -(w - 77)/2;
    
    translate([-l/2, -front_extension, z])
    cube([l, th+front_extension, w]);

    if (0)
    %translate([-l/2, 0, z])
    cube([l, th, w]);

    dw = (w-(77+4*2 + 21));

    if (back_extension) {
        stair = 6 + 6;
        translate([-l/2, 0, z + stair])
        cube([l, th+back_extension, w-stair]);
    }
}

module cavity() {
    dx = (PHONE_L +4*2) - BATT_L;
    // phone
    //phone_cavity(back_extension=BATT_TH + WALL*10);
    phone_cavity();

    // batt (slide)
    translate([dx/2 - 6, 22.2, 0])
    batt_cavity(front_extension=5, back_extension=WALL*10);

    hull() {
        phone_cavity(just_case=true);

        translate([dx/2 - 6, 22.2, 0])
        batt_cavity(front_extension=5);
    }

    // back passage
    difference() {
        translate([-dx/2, 22.2, 0])
        batt_cavity(front_extension=5, back_extension=0);

        translate([-BATT_L/2 + (PHONE_L+4*2-BATT_L)/2, 22.2+BATT_TH, 0])
        rotate([0, 0, 9 +5 -1])
        translate([-200, 0, 77+4])
        cube([200, 20, BATT_W - (77+4)]);
    }

    // cable
    w = 77-WALL*2;
    translate([0, WALL, 3.5])
    cube([PHONE_L*2, TH-WALL*3.5 - BEXTEND, w]);
}

module block(l, th, w) {
    difference() {
        chamferer(CH, fn=FN)
        cube([l, th, w]);

        marg = CH * 1.5;
        d = 1;
        step0 = 4;
        n = round((w - marg*2) / step0);
        step = (w - marg*2) / n;

        // face/back
        for (y=[0, th])
        for (z=[marg:step:w-marg])
            translate([marg, y, z])
            translate([0, -d/2, -d/2])
            cube([l - marg*2, d, d]);

        // sides
        for (x=[0, l])
        for (z=[marg:step:w-marg])
            translate([x, marg, z])
            translate([-d/2, 0, -d/2])
            cube([d, th - marg*2, d]);

        // top/bottom4.6
        n2 = round((th - marg*2) / step0);
        step2 = (th - marg*2) / n2;
        for (z=[0, w])
        for (y=[marg:step2:th-marg])
            translate([marg, y, z])
            translate([0, -d/2, -d/2])
            cube([l - marg*2, d, d]);
    }
}

module case() {
    l = L;
    w = W;
    th = TH;
    z = (77 -w)/2;

    translate([0, -TH + 1, (BATT_W-77)/2+WALL])
    difference() {
        translate([-l/2, 0, z])
        difference() {
            block(l, th, w);

            // slanted back corner for rest
            grind = 24;
            if (BEXTEND>0)
            translate([0, TH, 0])
                rotate([45, 0, 0])
                cube([l*3, TH, grind*2], center=true);
            }

        translate([0, 1, 0])
        cavity();
            
        // screw
        translate([0, TH/2, W+z - 13.25]) {
            rotate([0, 90, 0])
            cylinder(d=2, h=L*2, center=true, $fn=100);
        }
    }
}

//rotate([$preview ? -45: 0, 0, 0]) // slant
//rotate([0, 0, $preview? 0 : -45]) // align 1st/last layer lines

//rotate([0, $preview ? 0: 90, 0]) // stand
{
 
    translate([0, 30-BEXTEND, 0])
    if (0) {
        // phone and battery ghosts
        translate([12.6 -6, -58.5, 59])
        %cube([146, 37, 108], center=true);

        translate([0, -87.0, 57.5])
        %cube([171, 20, 87], center=true);
    }


    intersection() {
        case();

    //    translate([0, 0, 74]) cylinder(d=1000, h=15); // @@@ cut
    //    rotate([0, 0, 0]) cylinder(r=999, h=50);
    }
}