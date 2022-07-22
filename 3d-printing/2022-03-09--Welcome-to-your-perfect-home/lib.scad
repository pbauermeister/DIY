// https://www.thingiverse.com/thing:3317484/files

D = 200;
ATOM = 0.01;
$fn=30;

LAYER = .17;
PLAY = .17*2;

module _plateau_1() {
   import("orig/Plateau_1.stl");
}

module plateau_2() {
   import("orig/Plateau_2.stl");
}

module plateau_1_a() {
    difference() {
        _plateau_1();
        translate([-D/2, 0, -D/2])
        cube([D, D, D]);
   }
   tabs();
}

module plateau_1_b() {
    difference() {
        _plateau_1();
        translate([-D/2, -D, -D/2]) cube([D, D, D]);
        tabs(extra_h=.5, extra_d= .17*2);
   }
}

////////////////////////////////////////////////////////////////////////////////

module tabs(extra_h=0, extra_d=0) {
    for(i=[0:2]) {
        D = 10;
        S = 3.5;
        translate([i*63.1-80 -S, D*.45 *.9, 0])
        tab(extra_h, extra_d);

        translate([i*63.1 - 80 +33.65 +S, D*.45 *.9, 0])
        tab(extra_h, extra_d);
    }
}

module tab(extra_h=0, extra_d=0) {
    D = 8;
    DD = D + extra_d;

    translate([0, -1, 0])
    cylinder(d=D+extra_d, h=DD/2);

    translate([0, -1, D/2])
    sphere(d=DD);
}

module tenons(extra_h=0, extra_y=0, thick_k=1) {
    width = 5;
    step = 11;
    length = 12;
    height = 2.3*thick_k + extra_h;
    d = width + extra_y*2;
    for (i=[0:7]) {
        translate([17+14 -(extra_y?LAYER:0), -step*i -width -2.6-2, 0])
        translate([width*.85, 0, 0]) {
            cylinder(d=d, h=height);

            cw = width*.6 + extra_y*2;
            translate([-width, -cw/2, 0])
            cube([width, cw, height]);
        }
    }
}

module tenons_carve(thick_k=1) {
    translate([0, 0, -ATOM])
    tenons(.35, PLAY, thick_k);
}

////////////////////////////////////////////////////////////////////////////////

module plateau_1_a_1() {
    difference() {
        plateau_1_a();
        translate([31.5, -200+10, -1])
        cube(200);
    }
    tenons();
}

module plateau_1_a_2() {
    difference() {
        intersection() {
            plateau_1_a();
            translate([31.5, -200+10, -1])
            cube(200);
        }
        tenons_carve();
    }
}

module plateau_1_b_1() {
    difference() {
        intersection() {
            plateau_1_b();
            translate([-31.5-200, -10, -1])
            cube(200);
        }
        rotate([0, 0, 180])
        tenons_carve(thick_k=3.5);
    }
}

module plateau_1_b_2() {
    difference() {
        plateau_1_b();
        translate([-31.5-200, -10, -1])
        cube(200);
    }
    rotate([0, 0, 180])
    tenons(thick_k=3.5);
}

module plateau_2_1() {
    difference() {
        plateau_2();
        translate([-31.5-200, -10-100, -1])
        cube(200);
    }
    translate([0, -48, 0])
    rotate([0, 0, 180])
    tenons(thick_k=1.5);
}

module plateau_2_2() {
    difference() {
        intersection() {
            plateau_2();
            translate([-31.5-200, -10-100, -1])
            cube(200);
        }
        translate([0, -48, 0])
        rotate([0, 0, 180])
        tenons_carve(thick_k=1.5);
    }
}

union() {
%translate([-.17, 0, -.01])
plateau_1_a_1();
plateau_1_a_2();
}

plateau_1_b_1();
plateau_1_b_2();

plateau_2_1();
!plateau_2_2();
