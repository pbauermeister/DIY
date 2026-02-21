use <../chamferer.scad>

ATOM = 0.01;
d1 = 4.6 +.15; h1 = 4.0 +.15;
d2 = d1 - .1; h2 = 4.0;
d3 = 10;
d4 = 26;
mk = .25;
hh = 73;

shave1 = 1;
shave2 = 1;

module plate0() {
    intersection() {
        union() {
            if (0)
%            minkowski() {
                translate([-d3/2, 0, +1]) cube([d3, 1, 8-1]);
                rotate([270, 0, 0]) cylinder(r=mk, $fn=16);
            }
            if (0)
            minkowski() {
                translate([-d4/2, 0, +1]) cube([d4, 1, 6-2-1]);
                rotate([270, 0, 0]) cylinder(r=mk, $fn=16);
            }
 
            chamferer(2.45, "cylinder-y", fn=16)
            translate([-d3/2+shave2, 0, +2]) cube([d3-shave2*2, 1, 8-1-2 -shave1+1]);

            chamferer(.5, "cylinder-y")
            translate([-d4/2, 0, +1+1.5-1-1]) cube([d4, 1, 6-2-1+1]);
         }
        rotate([270, 0, 0])
        cylinder(r=d4, h=1, $fn=16);
    }
}

module piece() {
    d11 = d1 + .6 -.1 -.4;
    difference() {

        union() {
            scale([1,1, hh])
            rotate([90, 0, 180])
            plate0();

            chamferer(2, "cylinder", fn=16)
            hull() {
                translate([-d1, 3.5, 0])
                cube([d1*2, ATOM, 8]);

                translate([-d1, -6 + 2.8, 0])
                cube([d1*2, 1, 8]);
            }
        }


        // base loop window
        translate([-d11/2, -3.8+2.5, -ATOM])
        cube([d11, 9-2.5, 37-4]); //8+ATOM*2]);

        translate([-d11/2, -3.8+2.5 +3, -ATOM])
        cube([d11, 9-2.5 - 3, 37]); //8+ATOM*2]);

        // base window
        translate([-d11/2, 0, -ATOM])
        cube([d11, 50, 7+ATOM]);
             
        // mid window
        difference() {
            translate([-d11/2, -5 + 7.5, 26])
            cube([d11, 5, 11]);

            translate([0, 5+3, 27.75])
            cube([d11, 4-.5, 3.5], center=true);
        }

        // slants
        translate([0, 0, 65+1.75+2+1])
        rotate([45, 0, 0])
        translate([-d4, -d4/2, 0])
        cube(d4*2);

        translate([0, 0, 65+1.75+2+1+7.5])
        rotate([-45, 0, 0])
        translate([-d4, -d4/2, 0])
        cube(d4*2);

        // ratchets
        for (z=[3.5:6:hh]) {
            translate([d3/2+mk+ATOM -1, 6.75, z])
            rotate([0, 90, 0])
            cylinder(r=3, h=d4, $fn=36);

            translate([-d4-d3/2-mk-ATOM +1, 6.75, z])
            rotate([0, 90, 0])
            cylinder(r=3, h=d4, $fn=36);
        }
    }

    translate([0, 4.8, 27.75])
    cube([d11, 4-.5, 3.5], center=true);
}

module pieces_x2() {
    piece();

    d = 12.5;
    translate([-d, -d, 0])
    rotate([0, 0, 90])
    piece();
    

    for (z=[hh/3, hh*.67])
        translate([-d-.7, .25, z])
        rotate([0, 0, 45])
        cube([5, .4, 1], center=true);
}

module pieces_x4() {
    translate([d4/2, -.5, 0])
    pieces_x2();

    translate([d4, -d4, 0])
    rotate([0, 0, 180])
    translate([d4/2, -.5, 0])
    pieces_x2();
}

//!piece();
//!pieces_x2();

for (i=[0:1]) {
    translate([i*d4*1.55, 0, 0])
    pieces_x4();
}
