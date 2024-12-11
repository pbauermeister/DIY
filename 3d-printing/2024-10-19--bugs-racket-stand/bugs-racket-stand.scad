/* Cylinder with central hole, to hold a bug killing electrical racket.

Faceted sides and hollow to be filled with concrete.
*/


INNER_DIAMETER =  39;
INNER_HEIGHT   = 150;
WALL           =   8;
PROTUDE        =   1;
R              = 120/2;
N              =  52;
A              = 360/N;
C              = sin(A) * R;
BASE_H         = C*2;
OUTER_HEIGHT   = INNER_HEIGHT + BASE_H;
M              = floor(OUTER_HEIGHT/C) + 1;
HEIGHT         = M * C;
SKIN           = 0.8;

ATOM = 0.01;
$fn = $preview ? 100 : 200;

function get_vars() = [N, M, R, INNER_DIAMETER, SKIN];

module ring(n, m, r, protude, inset=0) {
    a = 360/n;
    v = r * (1-cos(a));
    c = sin(a) * r;
    
    cylinder(r=r-v*2-inset, h=m*c);

    if (protude>0) {
        for(j=[0:m-1]) {
            for (i=[0:n-1]) {
                translate([0, 0, j*c])
                rotate([0, 0, 360/n*i])
                translate([r-v-inset, 0, c/2])
                rotate([0, 90, 0])
                hull() {
                    translate([0, 0, -WALL/4])
                    cube([c, c, WALL/2], center=true);

                    translate([0, 0, protude])
                    cube([ATOM, ATOM, ATOM], center=true);
                }
            }
        }
    }
}

module hole(extra=0) {
    translate([0, 0, BASE_H + INNER_DIAMETER/2]) {
        cylinder(d=INNER_DIAMETER+extra, h=HEIGHT*2);
        sphere(d=INNER_DIAMETER+extra);
    }
}

module all() {
    difference() {
        union() {
            ring(N, M, R, 0);
            ring(N, M, R, PROTUDE);
        }

        // hole
        hole();

        // chamfer
        h = INNER_DIAMETER*.75;
        translate([0, 0, HEIGHT - h + ATOM])
        cylinder(d2=INNER_DIAMETER + WALL*2 - 2, d1=0, h=h);

        // base hollowing
        difference() {
            translate([0, 0, -ATOM])
            ring(N, M-1, R, $preview?0:PROTUDE, inset=SKIN);
            
            hole(SKIN*2);
        }
    }
}

module cap() {
    k = .98;
    rr = R*k - 3;
    h = 1 - .2;
    difference() {
        hull() {
            for (z=[0, .3]) {
                translate([0, 0, z])
                intersection() {
                    ring(N, 1, R, PROTUDE);
                    cylinder(r=R*2, h=ATOM);
                }
            }

            translate([0, 0, h])
            scale([k, k, 1])
            intersection() {
                ring(N, 1, R, PROTUDE);
                cylinder(r=R*2, h=ATOM);
            }
        }
    
        cylinder(r=rr, h=2, center= true);
    }
    
    n = 9;
    intersection() {
        union()
        for (i=[0:n-1]) {
            rotate([0, 0, 360/n*i])
            translate([-1, 0, 0])
            cube([2, rr, .7]);
        }
        cylinder(r=rr-.1, h=2, center= true);
    }
}

if(0)
    cap();
else
rotate([0,180, 0])
difference() {
    all();
    //cube(1000);
}

echo(M);

