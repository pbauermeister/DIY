ATOM = 0.001;
d1 = 4.6 +.15; h1 = 4.0 +.15;
d2 = d1 - .1; h2 = 4.0;
d3 = 10;
d4 = 26;
mk = .25;
hh = 37;

module plate0() {
    intersection() {
        union() {
            minkowski() {
                translate([-d3/2, 0, +1]) cube([d3, 1, 8-1]);
                rotate([270, 0, 0]) cylinder(r=mk, $fn=16);
            }
            minkowski() {
                translate([-d4/2, 0, +1]) cube([d4, 1, 6-2-1]);
                rotate([270, 0, 0]) cylinder(r=mk, $fn=16);
            }
        }
        rotate([270, 0, 0])
        cylinder(r=d4, h=1, $fn=16);
    }
}

module plate1() {
    difference() {
        plate0();
        
        translate([-d1/2, -ATOM, 1])
        cube([d1, 1 + ATOM*2, h1]);

        translate([-d2/2, -ATOM, -1])
        cube([d2, 1 + ATOM*2, h2]);
    }
}

module piece0() {
    scale([1,1, hh])
    rotate([90, 0, 180])
    plate1();
}

module piece() {
    difference() {
        piece0();
        
        d11 = d1 + .6;
        translate([-d11/2, -25, 0])
        cube([d11, 50, 7]);
        
        translate([-d1/2, -50 + 7.5 , 65  -36-2])
        cube([d1, 50, 7+4]);
     
        translate([0, 0, 65+1.75+2+1  -36])
        rotate([45, 0, 0])
        translate([-d4, -d4/2, 0])
        cube(d4*2);

        for (z=[3.5:6:hh]) {
            translate([d3/2+mk+ATOM, 6.5, z])
            rotate([0, 90, 0])
            cylinder(r=3, h=d4, $fn=36);

            translate([-d4-d3/2-mk-ATOM, 6.5, z])
            rotate([0, 90, 0])
            cylinder(r=3, h=d4, $fn=36);
        }
    }
}

for(y=[-4:3]) {
    for(x=[-1:1]) {
        translate([d4*1.125*x, 11*y, 0])
        piece();
    }
}
