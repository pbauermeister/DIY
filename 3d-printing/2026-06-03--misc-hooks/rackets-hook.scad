use <../chamferer.scad>
L  = 200;
W  =  40;
TH =  15;

D1  = 4.5;
D1B = 11;
D2  = 3;

$fn = $preview ? 20 : 100;


module holes() {
    n = 4;
    sp = L / n;
    intersection() {
        union() {
            cylinder(d=D1, h=TH*4, center=true);
            translate([0, 0, TH/4])
            cylinder(d=D1B, h=TH*4, center=false);

            for (i=[0:4-1]) translate([sp*i -  sp*(n/2-.5), 0, 0]) {
                cylinder(d=D2, h=TH*4, center=true);
                
                for (a=[0, 90]) rotate([0, 0, a])
                    cube([D2/2, D2*2, TH*3], center=true);
            }
        }
        
        cube([L, W, TH+.1], center=true);
    }
    
    for (i=[0:4-1]) translate([sp*i -  sp*(n/2-.5), 0, 0])
        for (a=[0, 90, 45, 135]) rotate([0, 0, a])
            translate([0, 0, -.5])
            cube([D2/6, D2*6, TH], center=true);
}


module hook() {
    difference() {
        // body
        chamferer($preview ? 0 : TH/4, "cone-up", fn=10)
        chamferer($preview ? 0 : W/4, "cylinder", fn=40)
        cube([L, W, TH], center=true);
        
        // recess for sticker band
        translate([0, 0, -TH/2 -.5])
        chamferer(/*$preview ? 0 : */ 5, "cylinder", fn=8, grow=false)
        chamferer(/*$preview ? 0 : */ W/4, "cylinder", fn=20)
        cube([L, W, 4], center=true);

        // holes for all screws
        holes();
    }
}

scale([1, 1, -1]) hook();
