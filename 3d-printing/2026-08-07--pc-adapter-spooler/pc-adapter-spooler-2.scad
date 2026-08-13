use <../chamferer.scad>

L = 280;
BED_FRAME_TH = 52           +1;
ADAPTER_THICKNESS = 21;

TH          =   5;
D           =  60;
W           =  30           +6;
CH          =  15;

ADAPTER_L   = 100;
ADAPTER_W   =  55;
ADAPTER_TH  =  22           -1;

$fn = $preview ? 30 : 60;

module clip(l, th, w, wall) {
    PLAY = 1;
    YZ = [[-wall, -w/2],
          [-th -wall -wall/2 -    0, -w/2],
          [-th -wall -wall/2 - PLAY, -w/2 + PLAY],
          [-th -wall -wall/2 - PLAY, -w/2 + w*.10],
          [-th -wall -wall/2 + PLAY, -w/2 + w*.40],
          [-th -wall -wall/2 + PLAY*2, -w/2 + w*.75],
          [-th -wall -wall/2 -    0, -w/2 + w*.85],
         ];

    for (i=[1:len(YZ)-1]) {
        y0 = YZ[i-1][0];
        z0 = YZ[i-1][1];
        y1 = YZ[i][0];
        z1 = YZ[i][1];

        hull() for (j=[i-1, i])
            for (x=[-l/2, l/2])
                translate([x, YZ[j][0], YZ[j][1]])
                rotate([0, 90, 0])
                cylinder(d=wall, h=wall/2, center=true, $fn=$preview ? 16 : $fn);
//                scale([.5, 1, 1])
//                sphere(d=wall, $fn=$preview?16:$fn);
    }
}

module spooler() {
    // knobs
    for (k=[-1, 1]) {
        scale([k, 1, 1])
        translate([L/2, 0, 0]) {
            hull() {
                translate([0, -W+CH/2, 0])
                resize([D, CH, D])
                sphere(d=D);

                translate([-D/2, -W+CH/2, 0])
                resize([D, CH, D])
                sphere(d=D);
            }
        }
    }

    chamferer($preview ? 0 : 1.5, fn=6) {
        
        // back plate
        hull()
        for (k=[-1, 1]) {
            translate([k*(L/2-1.5), -TH/2, 0])
            cube([3.1, TH, D], center=true);
        }

        // attachments
        for (k=[-1, 1]) {
            scale([k, 1, 1])
            translate([L/2, 0, 0]) {
                translate([0, 0, TH + D*.25 -D/2])
                hull() {
                    translate([-D*.5, CH/2-W, -TH - D*.25])
                    cube([D*.5, W-CH/2, TH*2]);

                    translate([-TH/2 -D*.5, CH/2-W, -TH - D*.25])
                    cube([TH*2, W-CH/2, D*.4]);
                }
            }
        }

        // adapter clip
        clip(ADAPTER_L, ADAPTER_TH, ADAPTER_W, TH);

        translate([0, -ADAPTER_TH - TH*1.45, -ADAPTER_W/2+TH/2])
        rotate([45, 0, 0])
        cube([ADAPTER_L, TH, TH], center=true);

        translate([0, -TH, -ADAPTER_W/2+TH/2])
        rotate([45, 0, 0])
        cube([ADAPTER_L, TH, TH], center=true);

        // bed frame clip
        translate([0, -1, 0])
        for(k=[1, -1]) {
            scale([k, 1, 1])
            translate([L/3 - 1.2, -TH, D/4-TH/2])
            scale([1, -1, -1])
            clip(L/3, BED_FRAME_TH +1, D/2, TH);
        }
    }
}

intersection() {
    spooler();

//    translate([41, 0, 0]) rotate([0, 90, 0]) cylinder(d=1000, h=11);
}

translate([0, BED_FRAME_TH/2, -TH/2])
%cube([50, BED_FRAME_TH, ADAPTER_W], center=true);


translate([0, -ADAPTER_TH/2 -TH, TH/2])
%cube([ADAPTER_L, ADAPTER_TH, ADAPTER_W], center=true);
