
CABLE_D =  4.5;
CLIP_L  = 80;

DEPTH   =  5             -.3;
TH      =  0.7;

ATOM = 0.01;
$fn = 60;

module tube(d_ext) {
    difference() {
        cylinder(d=d_ext, h=CLIP_L);

        translate([0, 0, -ATOM])
        cylinder(d=d_ext-TH*2, h=CLIP_L+ATOM*2);
    }
}

module clip() {
    // semi-tube
    difference() {
        rotate([-90, 0, 0]) tube(DEPTH);

        translate([0, -ATOM, -CABLE_D])
        cube([CABLE_D, CLIP_L+ATOM*2, CABLE_D]);
    }

    d = CABLE_D+TH*2;
    l = DEPTH * 2;

    // ground plate
    translate([0, 0, -DEPTH/2])
    cube([l + d*2.5, CLIP_L, TH]);

    // mid plate
    translate([DEPTH/2-TH, 0, 0])
    cube([l - DEPTH/2 + TH, CLIP_L, TH]);

    // cable clip
    translate([l + d/2 -TH, 0, 0])
    difference() {
        z = DEPTH/2 - (CABLE_D/2+TH*2) + TH;
        translate([0, 0, z])
        rotate([-90, 0, 0]) tube(d);

        h = (DEPTH/2 - TH) / 2;
        translate([-d, -ATOM, -h])
        cube([d*2, CLIP_L+ATOM*2, h]);

        h2 = (DEPTH/2 - TH);
        translate([0, -ATOM, -h2])
        cube([d, CLIP_L+ATOM*2, h2]);

        translate([-d, -ATOM, -DEPTH/2-h2])
        cube([d*2, CLIP_L+ATOM*2, h2]);
    }

    // funnel
    x = l + d -TH -.1;
    translate([x, 0, 0])
    rotate([0, -16, 0]) intersection() {
        cube([d, CLIP_L, TH]);
        
        hull() for(y=[d*2, CLIP_L - d*2])
            translate([0, y, 0])
            scale([1, 2, 1])
            cylinder(d=d*2, h=TH*3, center=true);
    }

    // avoid inner brim
    translate([x, 0, 0])
    rotate([0, 16, 0]) cube([d+.1, .3, TH/2]);

}


rotate([90, 0, 0])
clip();