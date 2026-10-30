use <../chamferer.scad>

$fn = $preview ? 16 : 80;
//D = 250;
D = 220;

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
        import("gyroid2-sd250-sp6.28-sz100-th.2-gr.3.stl");        
        sphere(d=d);
    }
}

d1 = 75;
d2 = 56;
h1 = 85;
h2 = 15*0 + 8.5;
h3 = 45;
d3 = 73 +2 +6;

module bulb() {

    sphere(d=d1);
    cylinder(d=d2, h=h1-d1/2 + h2 + h3);

    translate([0, 0, h1-d1/2])
    cylinder(d=d1, h=h2);

    // top extent, narrow
    cylinder(d=d2, h=D);

    // top extent, wide
    translate([0, 0, h1-d1/2+h2])
    cylinder(d=d3, h=D);

    // bottom extent
    hull() {
        cylinder(d=d3, h=h1-d1/2+h2);

        h = D/2*.67;

        translate([0, 0, -h+d3/2])
        sphere(d=d3);
    }
}

if(0)
difference() {
    gyroid();
    bulb();
}

D_IN    = 68.5;
TAB_R   =  1.2;
TAB_W   =  7.5;
TAB_H   =  3;
TH      =  3.5 *3 * 1.8;
H       = 10 - 5;
D_OUT   = D_IN+2*TH;

module ring(d_diff=0) {
    translate([0, 0, -H])
    difference() {
        cylinder(d=D_OUT+d_diff, h=H);
        cylinder(d=D_IN, h=H*4, center=true);
    }
    
    for (a=[120:120:360])
        rotate([0, 0, a])
        translate([-D_IN/2, 0, 0])
        chamferer(TAB_R*.9)
        translate([-TAB_R, -TAB_W/2, -TAB_H])
        cube([TAB_R*2, TAB_W, TAB_H]);
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
            translate([0, 0, h1-d1/2+h2])
            ring();
        }

        //translate([0, 0, -D]) cube(D*2);
        //translate([0, 0, h1-d1/2+h2 -D - H]) cylinder(d=D*2, h=D);
    }
}

lamp();