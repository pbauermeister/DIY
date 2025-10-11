use <../hinge4.scad>

L  = 167;
W  = 140;
TH =   5;
AL =  18;
D  =  30;

$fn = 20;

module basket() {
    difference() {
        union() {
            // hinge
            translate([-TH/2, 0, AL])
            rotate([-90, 180-90, 0])
            hinge4(thickness=TH, arm_length=AL/2, total_height=L, nb_layers=11, angle=180);

            translate([-TH/2, 0, TH/2])
            rotate([-90, -90, 0])
            hinge4(thickness=TH, arm_length=AL/2, total_height=L, nb_layers=11, angle=-90);

            // front
            l = AL*1.5;
            translate([-TH, 0, l])
            cube([TH, L, W-l-TH/2]);

            translate([-TH/2, 0, W-TH/2])
            rotate([-90, 0, 0])
            cylinder(d=TH, h=L);

            // bottom
            translate([-D, 0, 0])
            cube([D-TH*1.5, L, TH]);

            // back
            translate([-D, 0, 0])
            cube([TH, L, W]);
        }

        // back chamfer
        translate([TH-D, -L/2, W-20])
        rotate([0, -10, 0])
        cube([TH*2, L*2, TH*10]);
        
        // thread holes
        for (yk=[[0, 1], [L, -1]]) {
            y = yk[0];
            k = yk[1];
            for (xz=[[0, 0], [-D+TH, -4], [-D+TH, 4]]) {
                x = xz[0];
                z = xz[1];
                translate([x-TH + .75, y, W*.6 + z])
                scale([1, k, 1])
                rotate([90, 0, -45])
                cylinder(d=2, h=TH*5, center=true);
            }
        }

        // screw holes
        for(y=[30, L-30])
        translate([-D, y, W-30])
        rotate([0, 90, 0]) {
            cylinder(d=4, h=TH*3, center=true);
            translate([0, 0, TH/2])
            cylinder(d=9, h=TH);

        for (z=[.3:.8:TH])
            translate([0, 0, z])
            cylinder(d=9*1.5, h=.07);
        }
    }
}

rotate([90, 0, 0])
basket();