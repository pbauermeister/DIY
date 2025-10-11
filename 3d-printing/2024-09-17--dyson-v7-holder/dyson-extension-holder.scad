use <../chamferer.scad>

INNER_DIAMETER = 36;
OUTER_DIAMETER = 52;
DH             = 17;
H              = 30; //80;
CH             =  .8;
SPACING        =  5;
PLANK_TH       = 17.5;
GRIP           = 20;

$fn = 200;

module attachment() {
    difference() {
        w = PLANK_TH*1.75;
        l = GRIP + SPACING + (OUTER_DIAMETER-INNER_DIAMETER)/2;
        h = H; //-DH;
        translate([INNER_DIAMETER/2, -w/2, 0])
        cube([l, w, h]);

        // plank hollowing
        translate([OUTER_DIAMETER/2+SPACING, -PLANK_TH/2, -H/2])
        cube([l, PLANK_TH, H*2]);
        tol = .8;
        translate([OUTER_DIAMETER/2+SPACING, -PLANK_TH/2-tol/2, -H/2])
        cube([GRIP*.75, PLANK_TH+tol, H*2]);
    }
}

difference() {
    chamferer($preview?0:CH, "cone", fn=8)
    union() {
        // holder
        difference() {
            union() {
                cylinder(d=OUTER_DIAMETER, h=H);
                attachment();
            }

            // tube hollowing
            hull()
            for (x=[0, -INNER_DIAMETER])
                translate([x, 0, 0])
            cylinder(d=INNER_DIAMETER, h=H*3, center=true);

            // cone
            translate([0, 0, H-DH+5])
            cylinder(d1=INNER_DIAMETER, d2=OUTER_DIAMETER, h=DH);
        }
    }

    // screws
    d  =  3.5;
    dh = 10;
    m  =  2.5;
    h  = H;
    translate([OUTER_DIAMETER/2+SPACING + GRIP/2, 0, h/2])
    rotate([90, 0, 0]) {
        cylinder(d=d, h=PLANK_TH*3, center=true);

        translate([0, 0, PLANK_TH/2 + m])
        cylinder(d=dh, h=PLANK_TH);

        translate([0, 0, -PLANK_TH*1.5 - m])
        cylinder(d=dh, h=PLANK_TH);
    }
}