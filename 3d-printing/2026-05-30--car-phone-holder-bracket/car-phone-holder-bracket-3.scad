use <../chamferer.scad>
L  = 70             + 10;
W  = 10-4           + 4 -.4;
H  = 18-4;

W2 = W; //W*.6 +2;

L2 = 35;
L3 = L; //44 + 20;

D  = 6;
D2 = 4.25;

RW = 8.6;
RH = 4.5;

SD = 4.5;

$fn  = $preview ? 20 : 60;
ATOM = 0.01;


module rail() {
    w = RW;
    h = RH;
    translate([-w/2, 0, 0])
    cube([w, 100, h]);

    translate([0, 0, h+w/2-1.75])
    rotate([0, 45, 0])
    cube([w, 100, w], center=true);
}

//!rail();

module body(w=W, with_gripper=true, with_pinholes=false, with_groove=true) {
    difference() {
        chamferer(1, fn=8)
        union() {
            difference() {
                chamferer(6, "cylinder-y", fn=4)
                translate([0, 0, 2])
                cube([L, w, H], center=true);

                // chamfer
                for (kx=[1, -1])
                translate([L/2*kx, W*1.25 * (with_pinholes?1:-1), 0])
                rotate([0, 0, 45])
                cube(W*2, center=true);
            }

            if(0)
            if (!with_gripper)
                translate([0, 3, 2+1.5])
                cube([L2-RW, w, H-3], center=true);
        }        

        // pin holes
        if (with_pinholes) {
            for(x=[-L2/2, L2/2])
                translate([x, w, -1+.5])
                rotate([90, 0, 0])
                cylinder(d=D2, h=w*2);

            rotate([-90, 0, 0])
            for(x=[-L2/2, L2/2])
                translate([x, -20, 2.5])
                rail();
           
            translate([0, W/2, -H/2+H/3.3])
            cube([15, 5, H/3], center=true);
        }

        // rails
        for(x=[-L2/2, L2/2])
            translate([x, -20, 2.5])
            rail();

        // groove
        d = 3.6;
        if (with_groove)
        hull() for (y=[-d/2 -1, -d*3])
            translate([0, -w/2+d/2 + y, d*.45]) {
            //rotate([45, 0, 0])
            cube([L*2, d, d*.5], center=true);
        }
        
        // spring cavities
        for(j=[1, -1]) for(k=[1, -1])
            translate([(L2/2-RW*1.33*j)*k, w/4 + (with_groove?w/2:0), 2])
            rotate([90, 0, 0])
            cylinder(d=SD, h=w);
    }
}

module body_back() {
        body(w=W2, with_gripper=false, with_pinholes=true, with_groove=false);
}


module front_piece() { 
    body();
}


module back_piece() { 
    body_back();
}



if(1)
rotate([$preview ? 0 : 90, 0, 0]) front_piece();

if(1)
translate([0, 40, 0])
rotate([$preview ? 0 : -90, 0, 0]) back_piece();

