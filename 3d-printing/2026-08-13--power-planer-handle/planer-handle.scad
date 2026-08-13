WALL = 18;
TH   = 36  +2;
CH   = TH/4 * (1 + (sqrt(2)-1)/2);

ATOM = 0.01;

module handle0() {
    minkowski() {
        th = TH - WALL;
        translate([0, 297, -th/2])
        scale([1, -1, 1])
        linear_extrude(th)
        import("handle-spine.dxf");

        sphere(r=CH, $fn=8);
    }

    //%translate([WALL/2 *1.1, 0, -WALL/2]) cube([82, 82, TH]);
}

module handle() {
    difference() {
        translate([0, -0, 0])
        handle0();
        
        // screw axis       
        translate([0, 25, 0])
        rotate([0, 90, 0]) {
            cylinder(d=6.5, h=500, $fn=20, center=true);
            %cylinder(d=6.5, h=500, $fn=20, center=true);
        }
        
        // Ends
        translate([0, -10, 0])
        cube([400, 20, WALL*4], center=true);

        // slants
        for (k=[1, -1]) {
            translate([102/2, -102/2-TH*.25, 0])
            rotate([0, 0, k*45])
            cube([400, 20, WALL*4], center=true);
        }
        
        // grooves
        dz = 28 + 2.25;
        for (k=[-1, 1]) {
            translate([TH/4 -3, -.5, k*(dz/2) -1])
            cube([82+4 +3, 43.5, 2]);

            translate([TH/4 -3, -.5, k*(dz/2+2) -2.5])
            cube([82+4 +3, 43.5, 5]);

        }
    }
}

handle();

/*
translate([0, 0, -6])
intersection() {
    handle();
    translate([0, 0, 6])
    cylinder(r=1000, h=.5);
}


translate([50, 0, .5])
rotate([0, 90, 0])
translate([-1-94, 0, 0])
intersection() {
    handle();

    translate([93, 0, 0])
    cube([5, 100, 100], center=true);
}
*/