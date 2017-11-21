THICKNESS = 0.4;
EMBOSS = 0.3;

LENGTH = 50;
WIDTH = 13;

BORDER = 1;
CARVE = 0.2;
R = 1.2;

module all() {
    difference() {
        union() {
            // body
            translate([0, 0, -THICKNESS])
            cube([LENGTH, WIDTH, THICKNESS]);

            // logo
            resize([LENGTH, WIDTH, EMBOSS])
            linear_extrude(height=1)
            import("design.dxf");
        }

        // carved back
        translate([BORDER, BORDER, -THICKNESS])
        cube([LENGTH-BORDER*2, WIDTH-BORDER*2, CARVE]);

        // corners
        translate([0, 0, 0])      rotate([0, 0, 45]) cube([R, R, 10], true);
        translate([LENGTH, 0, 0]) rotate([0, 0, 45]) cube([R, R, 10], true);
        translate([0, WIDTH, 0])      rotate([0, 0, 45]) cube([R, R, 10], true);
        translate([LENGTH, WIDTH, 0]) rotate([0, 0, 45]) cube([R, R, 10], true);
    }
}

//k = 15/13;
//scale([k, k, 1])
rotate([180, 0, 0])
all();