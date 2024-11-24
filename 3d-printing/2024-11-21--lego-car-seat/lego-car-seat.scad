use <mando.scad>;

UU = 39.8 / 5;
HH = 23.4 / 3;

A = 2;
B = 3;
C = 4;
D = 5;
E = 6;
F = 7;
G = 8;
H = 9;
I = 10;
J = 11;
K = 12;
L = 13;

R = 19;
S = 20;
T = 21;
U = 22;
V = 23;
W = 24;
X = 25;
Y = 26;
Z = 27;

$fn = 90;
ATOM = .01;

MAP = [
    // plane -1
    [
        [0,A,Z,Z,Z,1,0,0,0,0,0,1,0,0,0,1,K],
        [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
        [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
        [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
        [0,B,Z,Z,Z,1,0,0,0,0,0,1,0,0,0,1,L],
    ],
    // plane 0
    [
        [X,A,1,1,1,1,0,1,1,1,1,1,1,U,1,1,K],
        [0,R,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1],
        [0,R,0,0,0,0,0,0,0,0,1,1,Z,Z,Z,1,1],
        [0,R,0,0,0,0,0,0,0,0,1,1,Z,Z,Z,1,1],
        [X,B,1,1,1,1,0,1,1,1,1,1,1,U,1,1,L],
    ],
    // plane 1
    [
        [X,A,1,1,1,1,0,1,1,1,1,1,1,1,1,1,K],
        [0,R,0,0,0,0,0,1,0,0,0,0,1,0,0,0,1],
        [0,R,0,0,0,0,0,1,0,0,0,0,1,0,0,0,1],
        [0,R,0,0,0,0,0,1,0,0,0,0,1,0,0,0,1],
        [X,B,1,1,1,1,0,1,1,1,1,1,1,1,1,1,L],
    ],
    // plane 2
    [
        [0,E,G,G,G,G,G,G,0,0,0,0,0,0,0,0,0],
        [0,C,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0],
        [0,C,1,1,1,1,0,1,0,0,0,0,1,0,0,0,0],
        [0,C,1,1,1,1,1,1,0,0,0,0,1,0,0,0,0],
        [0,F,H,H,H,H,H,H,0,0,0,0,0,0,0,0,0],
    ],
    // plane 3
    [
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,G,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,H,0,0,0,0],
        [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    ],
];


module block(t, x, y, z) {
    if (t) {
        translate([x*UU, y*UU, z*HH])
        difference() {
            intersection() {
                if (t==X) {
                    translate([UU/2 * 1.9, UU/2, UU/2]) {
                        d = UU*.8;
                        rotate([0, 90, 0])
                        cylinder(d=d, h=UU);
                        //scale([.33, 1, 1]) sphere(d=d);
                    }
                }
                else {
                    cube([UU, UU, HH]);
                }
                
                if (t==A || t==W) {
                    translate([UU, UU, 0])
                    cylinder(r=UU, h=HH*3, center=true);
                }
                if (t==B || t==V) {
                    translate([UU, 0, 0])
                    cylinder(r=UU, h=HH*3, center=true);
                }
                if (t==C) {
                    translate([UU, 0, 0])
                    rotate([90, 0, 0])
                    cylinder(r=UU, h=HH*3, center=true);
                }
                if (t==D) {
                    rotate([90, 0, 0])
                    cylinder(r=UU, h=HH*3, center=true);
                }
                if (t==E) {
                    translate([UU, UU, 0])
                    sphere(r=UU);
                }
                if (t==F) {
                    translate([UU, 0, 0])
                    sphere(r=UU);
                }
                if (t==G) {
                    translate([0, UU, 0])
                    rotate([90, 0, 90])
                    cylinder(r=UU, h=HH*3, center=true);
                }
                if (t==H) {
                    rotate([90, 0, 90])
                    cylinder(r=UU, h=HH*3, center=true);
                }
                if (t==I) {
                    translate([0, UU, 0])
                    sphere(r=UU);
                }
                if (t==J) {
                    sphere(r=UU);
                }
                if (t==K) {
                    translate([0, UU, 0])
                    cylinder(r=UU, h=HH*3, center=true);
                }
                if (t==L) {
                    cylinder(r=UU, h=HH*3, center=true);
                }


                if (t==Y) {
                    rotate([0, -45, 0])
                    cylinder(r=UU*3, h=HH*2);
                }
                if (t==Z || t==W || t==V) {
                    translate([0, 0, HH/2])
                    cylinder(r=UU*3, h=HH);
                }
            }
            
            // diffs
            union() {
                if (t==R) {
                    for (h=[.25, .75]) {

                        translate([UU*.1, -UU/2, HH*h])
                        rotate([0, 180+45, 0])
                        cube([UU, UU*2, UU]);                    
                    }

                }
                if (t==S) {
                    rotate([0, 90, 0])
                    cylinder(r=UU, h=HH*3, center=true);
                }
                if (t==T) {
                    translate([0, UU, 0])
                    rotate([0, 90, 0])
                    cylinder(r=UU, h=HH*3, center=true);
                }
                if (t==U) {
                    h = 1.2;
                    d1 = 5.1;
                    d2 = 6.3;

                    translate([UU/2, UU/2, HH/2])
                    cylinder(d=d1, h=HH*2, center=true);

                    translate([UU/2, UU/2, -ATOM])
                    cylinder(d1=d2, d2=d1, h=h);

                    translate([UU/2, UU/2, HH-h+ATOM])
                    cylinder(d2=d2, d1=d1, h=h);
                }
            }
        }
    }
}


%block(R, 5-4, -2, 0);
%block(X, 5-3, -2, 0);
%block(1, 5-2, -2, 0);

for (z = [0:len(MAP)-1]) {
    plane = MAP[z];
    for (y = [0:len(plane)-1]) {
        row = plane[y];
        for (x = [0:len(row)-1]) {
            cell = row[x];
            block(cell, x, y, z);
        }
    }
}

translate([UU*11.3, -UU*2.5, HH*1.2])
mando();

