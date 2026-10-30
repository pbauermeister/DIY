use <../chamferer.scad>

// Ball
//D = 250;
D = 220 *4/5;

// bulb
BULB_D1 = 75;
BULB_D2 = 56;
BULB_H1 = 85;
BULB_H2 = 15*0 + 8.5;
BULB_H3 = 45;
BULB_D3 = 73 +2 +6;

// Ring
RING_D_IN  = 68.5;
RING_TAB_R =  1.2;
RING_TAB_W =  7.5;
RING_TAB_H =  3;
RING_TH    =  3.5 *3 * 1.8;
RING_H     = 10 - 5;
RING_D_OUT = RING_D_IN+2*RING_TH;

$fn = $preview ? 16 : 80;

module gyroid() {
    d = 35 + 15;
    k = D/d;
    scale([k, k, k])
    intersection() {
        if (!$preview)
        translate([-d/2, -d/2, -d/2])
        scale(d/40)
        scale(0.5)
        //import("gyroid.stl");
        //import("gyroid-sd150-sp6.28-sz50-th.15-gr.3.stl");
        //import("gyroid2-sd200-sp6.28-sz100-th.2-gr.4.stl");
        //import("gyroid2-sd250-sp6.28-sz100-th.2-gr.3.stl");
        //import("gyroid2-sd250-sp9.42-sz80-th.35-gr.3.stl");
        import("gyroid2-sd250-sp9.42-sz80-th.5-gr.3.stl");
        sphere(d=d);
    }
}

module bulb() {

    sphere(d=BULB_D1);
    cylinder(d=BULB_D2, h=BULB_H1-BULB_D1/2 + BULB_H2 + BULB_H3);

    translate([0, 0, BULB_H1-BULB_D1/2])
    cylinder(d=BULB_D1, h=BULB_H2);

    // top extent, narrow
    cylinder(d=BULB_D2, h=D);

    // top extent, wide
    translate([0, 0, BULB_H1-BULB_D1/2+BULB_H2])
    cylinder(d=BULB_D3, h=D);

    // bottom extent
    hull() {
        cylinder(d=BULB_D3, h=BULB_H1-BULB_D1/2+BULB_H2);

        h = D/2*.67;

        translate([0, 0, -h+BULB_D3/2])
        sphere(d=BULB_D3);
    }
}

module ring(d_diff=0) {
    translate([0, 0, -RING_H])
    difference() {
        cylinder(d=RING_D_OUT+d_diff, h=RING_H);
        cylinder(d=RING_D_IN, h=RING_H*4, center=true);
    }
    
    for (a=[120:120:360])
        rotate([0, 0, a])
        translate([-RING_D_IN/2, 0, 0])
        chamferer(RING_TAB_R*.9)
        translate([-RING_TAB_R, -RING_TAB_W/2, -RING_TAB_H])
        cube([RING_TAB_R*2, RING_TAB_W, RING_TAB_H]);
}

module lamp(preview=$preview) {
    difference() {
        union() {
            difference() {
                if (preview)
                    sphere(d=D);
                else
                    gyroid();
                bulb();
            }
            translate([0, 0, BULB_H1-BULB_D1/2+BULB_H2])
            ring();
        }

        //translate([0, 0, -D]) cube(D*2);
        //translate([0, 0, BULB_H1-BULB_D1/2+BULB_H2 -D - RING_H]) cylinder(d=D*2, h=D);
    }
}

lamp();