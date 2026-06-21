use <../chamferer.scad>
L = 70;
W = 10              -4;
H = 18              -4;

W2 = W*.6 +2;

L2 = 35;
L3 = 44;

D = 6;
D2 = 4.25;
$fn = $preview ? 20 : 60;

ATOM = 0.01;


module rail() {
    w = 8.6;
    translate([-w/2, 0, 0]) cube([w, 100, 4.5]);
}

//!rail();

module body(ds, w=W, with_gripper=true, with_pinholes=false, with_groove=true) {
    difference() {
        if (with_gripper) {
            chamferer(1, fn=8) difference() {
                chamferer(6, "cylinder-y", fn=4)
                translate([0, 0, 2]) {
                    cube([L, w, H], center=true);

                    translate([0, w/4, H/4])
                    cube([L*.75, w/2, H], center=true);
                }
                translate([0, 0, W*2+1-.5])
                cube(W+1, center=true);                
            }
        } else {
            chamferer(1, fn=8) {
                translate([0, 0, 2])
                cube([L3, w, H], center=true);
 
                translate([0, 0, SCR_Z])
                rotate([90, 0, 0])
                cylinder(d=20, h=w, center=true);
            }
        }

        // big screw
        if (with_pinholes) {
            translate([0, -SCR_H/2, SCR_Z])
            rotate([-90, 0, 0])
            screw(.16 +.1);
        }

        // pin holes
        if (with_pinholes)
        for(x=[-L2/2, L2/2])
            translate([x, w, -1+.5])
            rotate([90, 0, 0])
            cylinder(d=D2, h=w*2);

        // rails
        for(x=[-L2/2, L2/2])
            translate([x, -20, 2.5])
            scale([with_groove?1:1.05, 1, with_groove?1:2])
            rail();

        // groove
        d = 3.6;
        if (with_groove)
        hull() for (y=[-d/2 -1, -d*3])
            translate([0, -w/2+d/2 + y, d*.45]) {
            //rotate([45, 0, 0])
            cube([L*2, d, d*.5], center=true);
            }
        
        // screw
        if (with_groove) {
            translate([0, 0, -H*.25])
            cylinder(d=ds, h=H*3, center=!true);
        }

        // bite
        /*
        if (!with_groove)
            translate([0, 0, -14])
            rotate([90, 0, 0])
            cylinder(d=18, h=20, center=true);
        */
    }
}

module body_back(ds) {
        body(ds, w=W2, with_gripper=false, with_pinholes=true, with_groove=false);
}


module partitioner(extra=0) {
    translate([0, 0, 2.5 + 3 -1.8]) {
        translate([0, 0, H/2])
        cube([L*2, W*2, H], center=true);
        
        scale([1, 1, .5]) {
            d = 3;
            rotate([45, 0, 0])
            cube([L*2, d+extra, d+extra], center=true);

            translate([0, 0, -d*.25])
            rotate([0, 0, 90])
            cube([L*2, d*3+extra, d+extra], center=true);
        }
    }
}

module front_piece() { 
    difference() {
        body(ds=3);
        partitioner(.4);
    }

    translate([0, 0, 1])
    intersection() {
        body(ds=4);
        partitioner();
    }
}


module back_piece() { 
    difference() {
        body_back(ds=3);
    }
}



if(0)
rotate([$preview ? 0 : -90, 0, 0]) front_piece();

if(0)
translate([0, 40, 0])
rotate([$preview ? 0 : -90, 0, 0]) back_piece();


SCR_H    = 15;
SCR_D    =  9;
SCR_STEP =  1.5;
SCR_HH   =  3.5;
SCR_HD   = 25;
SCR_Z    =  4;

module screw(xr=0) {
    max_a = 360*SCR_STEP * SCR_H;
    da = $preview ? 10: 2;
    xa = 360*SCR_STEP;
    dh = SCR_STEP/360;
    fn = 100;
    intersection() {
        union() {
            for (aa=[-xa:da:max_a+xa]) {
                hull() for (a=[aa, aa+da]) {
                    translate([0, 0, dh*a])
                    rotate([0, 0, a])
                    translate([SCR_D/2 + xr, 0, 0])
                    rotate([0, 45, 0])
                    cube([SCR_STEP, ATOM, SCR_STEP], center=true);
                }
            }
            cylinder(d=SCR_D+xr*2, h=SCR_H, $fn=$preview?$fn:fn);
            cylinder(d=SCR_D+xr*2 + SCR_STEP*.75, h=SCR_H, $fn=$preview?$fn:fn);
        }
        
        chamferer(SCR_STEP*2, fn=$preview?8:16)
        cylinder(d=SCR_D + SCR_STEP*sqrt(2) - SCR_STEP/4 + xr*2, h=SCR_H, $fn=$preview?$fn:fn);
    }
    
    intersection() {
        n = 12;
        difference() {
            cylinder(d=SCR_HD, h=SCR_HH);
            for (a=[0:360/n:360])
                rotate([0, 0, a])
                translate([SCR_HD/1.55, 0, 0])
                cylinder(d=SCR_D, h=SCR_HH*3, center=true, $fn=n);
        }
            
        chamferer(.5, fn=n)
        cylinder(d=SCR_HD, h=SCR_HH);
    }
}

if ($preview) translate([0, 30, SCR_Z]) rotate([-90, 0, 0]) screw();
else          translate([0, -30, 0]) screw();
