/*
This piece is to be screwed to the dyson-v7-holder.scad so that the v7
will hold without rotating.
*/

R = 50;
RR = 120/2                     +2.5;
D = 30                         +5;
A = [50, 50/3, -50/3, -50];

N = 21/2;
H = 20;
TH = 5;

R2 = R+D/7;
R3 = R+D/2+2 -1                +1;
R4 = R+D*.85 -1                -3;

SCREW_DIAMETER =  3;
SCREW_HEAD     =  9;
SCREW_REST     = 15;
SCREW_REINFORCEMENT = SCREW_DIAMETER*1.3;

SCREW_DIST = 2;

ATOM = .01;


module screw_hole(only_head=false) {
    fn = 30;
    l = 50;
    rotate([0, 0, 0]) {
        cylinder(d=SCREW_HEAD, h=l, $fn=fn);

       if (!only_head) {
            translate([0, 0, -TH]) {
                translate([0, 0, 1])
                cylinder(d=SCREW_DIAMETER, h=TH, $fn=fn);
                cylinder(d=1.5, h=TH, $fn=fn);
            }


            th = .08;
            for (a=[0:30:360]) {
                rotate([0, 0, a])
                translate([0, -th/2, -TH])
                cube([SCREW_REINFORCEMENT, th, TH]);
            }
        }
    }
}

module remover() {
    cylinder(r=R2, h=H*3, center=true);

    c = R*4;
    translate([-c/2 + R*.8, 0, 0])
    cube(c, true);
}

module ring(h=H, th=TH) {
    difference() {
        intersection() {
            hull() {
                cylinder(r=R3, h=h);
                cylinder(r=R4, h=th);
            }
            cube([R*4, R*2.06, H*2], center=true);
        }

        remover();
        cutouts();

        // marker
        if (0)
        difference() {
            cylinder(r=RR, h=1);
            cylinder(r=RR-.5, h=3, center=true);
        }
    }
}

module cutouts(extra=0) {
    for (i=A) {
        rotate([0, 0, i])
        translate([R, 0, -ATOM]) {
            cylinder(d=D+extra, h=H+1);
        }
    }
}

module screws() {
    r = R4 - SCREW_REINFORCEMENT - SCREW_DIST;
    for (i=[-1, 0, 1]) {
        rotate([0, 0, i*50/3*2]) {
            translate([r, 0, TH +.1])
            screw_hole();

            hull() {
                translate([r, 0, TH +.1])
                screw_hole(only_head=true);

                translate([r*2, 0, TH +.1])
                screw_hole(only_head=true);
            }
        }
    }
}

module all() {
    $fn = 200;
    difference() {
        ring();
        cutouts();

        c = R*4;
        translate([-c/2 + R*.7, 0, 0])
        cube(c, true);

        screws();
    }
}

module all_test() {
    th = .6;

    difference() {
        union() {
            cutouts(th);
            cylinder(r=R2+th, h=H+.9);
        }
        cutouts();
        remover();
    }
    difference() {
        ring(th, th);
        screws();
    }

}

if (1) {
    all();
}
else {
    all_test();

%    difference() {
        union() {
            cube([5,150,1], true);
            cylinder(r=R, h=1, center=true);
        }
        cylinder(r=1, h=10, center=true);
    }
}
