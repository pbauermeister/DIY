D         = 40.0;
THICKNESS =  1.5;

WALL      =  0.15;

$fn       = $preview ? 10 : 30;
ATOM      =  0.01;

module disc(semi=false, thickness=THICKNESS) {
    minkowski() {

        difference() {
            linear_extrude(ATOM) circle(d=D-thickness, $fn=360);
            if (semi) rotate([0, -90, 0]) cylinder(d=D*2, h=D);
        }

        sphere(d=thickness);
    }        
}

module oloid() {
    rotate([0, -90, 0])
    hull() {
        disc();
        translate([D/2, 0, 0])
        rotate([90, 0, 0]) disc();
    }

}

module sphericon() {
    rotate([0, -90, 90])
    hull() {
    disc(semi=true);
    rotate([90, 0, 0]) rotate([0, 0, 180]) disc(semi=true);
    }
}


oloid();

sphericon();

module support() {
    extra = 2;
    h = D/2;
    l = D;
    d = D * .5;
    dd = D/7;
    layer = .3*2;
    translate([0, 0, -layer-D/2]) {
        translate([-WALL/2, -l/2 - extra*2, 0])
        cube([WALL, l + extra * 4, D/2]);

        for (y=[-D/2-d/2-extra, D/2+d/2+extra]) {
            translate([0, y, 0])
            difference() {
                cylinder(d=d, h=h);
                cylinder(d=d-WALL*2, h=h*3, center=true);
            }
        }
    }
}