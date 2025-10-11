use <../chamferer.scad>

ATOM = 0.01;

//$fn = $preview ? 8 : 200;

module hook(with_tolerance=false) {
    difference() {
        rotate([90, 0, 0]) {
            hull() {
                fn = $preview ? 100 : 200;
                cylinder(d=20, h=.55, $fn=fn);
                translate([0, 0, 45])
                sphere(d=20, $fn=fn);
            }
            
            translate([0, 0, -20+ATOM])
            cylinder(d=20 + (with_tolerance ? .17*2 : 0), h=20, $fn=4);
        }
        rotate([90, 0, 0]) {
            for (d=[.5:3:18])
                difference() {
                    cylinder(d=d, h=45);
                    cylinder(d=d-.2, h=65*4, center=true);
                }
        }
        translate([-20, -45, 4])
        cube([40, 40, 10]);
    }
}

module body() {
    hull() {
        translate([0, 0, 60])
        cube([80, 30, 20]); 
        cube([20, 30, 80]); 
    }

    translate([-160, 0, 0])
    cube([160, 55, 80]);
}

module screw() {
    rotate([90, 0, 0]) {
        cylinder(d=5.5, h=100);

        translate([0, 0, 15])
        cylinder(d=16, h=100);

        for (d=[2.5:1.25*2:18]) {
            difference() {
                cylinder(d=d, h=16);
                cylinder(d=d-.2, h=16*4, center=true);
            }
        }
    }
}

module holder() {
    difference() {
        chamferer(5, tool="sphere", fn=$preview? 4 : 8, shrink=true, grow=true) {
            body();
        }

        translate([-170, 50, -10])
        cube([250, 10, 100]);

        for (x=[-20, -100])
            translate([x, 50+ATOM, 60])
            screw();


    for (x=[-60:-80:-160+20])
        translate([x, 0, 60])
        hook();
    for (x=[-20:-80:-160+20])
        translate([x, 0, 20])
        hook();
    }

}

holder();

//rotate([-90, 0, 0]) hook(true);