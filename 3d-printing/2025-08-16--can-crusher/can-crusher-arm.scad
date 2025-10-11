use <../chamferer.scad>
use <../Getriebe.scad>

//K = 1/3.5;
K = 1;

TOLERANCE       =   0.3;

ARM_LENGTH      = 120*K;
ARM_THICKNESS   =  12*K;
ARM_WIDTH       =  90*K      - 30*K;
SPACING         =  40*K;

WHEEL_DIAMETER  =  30*K;

D               =  80*K      - 10*K;
D2              =  66*K;
D3              =  55*K;
DH              =   2*K;

CHAMFER         =   1.5*K;

SCREW_DIAMETER  =   4*K;

ARM_L2          = ARM_THICKNESS + TOLERANCE*1;
L               = SPACING + D/2 + ARM_L2/2 + ARM_THICKNESS;

$fn  = 60*2;
fn2  = 8         * 5;
ATOM = 0.001;

module rounded_bar(l, w, th) {
    hull() {
        cylinder(d=w, h=th, $fn=fn2);
        translate([l, 0, 0]) cylinder(d=w, h=th, $fn=fn2);
    }
}

module segments(xy, d, h) {
    for (i=[1:len(xy)-1]) {
        hull() {
            translate([xy[i-1][0], xy[i-1][1], 0])
            cylinder(d=d, h=h, $fn=12);
            translate([xy[i][0], xy[i][1], 0])
            cylinder(d=d, h=h, $fn=fn2);
        }
    }
}

module wheel(mirror=false) {
    n = 5+2;

    //cylinder(d=ARM_L2*2+ARM_THICKNESS, h=ARM_WIDTH);
    intersection() {
        // gear
        rotate([0, 0, mirror ? 0 : 180])
        pfeilrad(modul=WHEEL_DIAMETER / n,
                 zahnzahl=n,
                 hoehe=ARM_WIDTH,
                 bohrung=0,
                 eingriffswinkel=20,
                 schraegungswinkel=28);

        // enveloppe
        if (!$preview)
            chamferer(CHAMFER, "cone")
            cylinder(d=ARM_L2*2+ARM_THICKNESS, h=ARM_WIDTH);
    }
}

if (0) !union() {
    wheel();
    translate([0, WHEEL_DIAMETER, 0])

    scale([1, -1, 1])
    wheel(1);
}

module bumperer(bumper) {
    k = 1.4;
    if (bumper=="m") {
        d = WHEEL_DIAMETER;
        translate([SPACING*.85, -ARM_THICKNESS/2, ARM_WIDTH/2])
        scale([1, 1, k])
        intersection() {
            sphere(d=d);
            translate([0, -d/2, 0])
            cube(d, center=true);
        }
    }

    if (bumper=="f" || bumper=="m") {
        d = WHEEL_DIAMETER * 1.25;
        translate([SPACING*.85, -ARM_THICKNESS/2, ARM_WIDTH/2])
        scale([1, 1, k])
        difference() {
            intersection() {
                sphere(d=d);

                rotate([90, 0, 0])
                cylinder(d=d, h=WHEEL_DIAMETER/2 - ARM_THICKNESS/2-TOLERANCE/2);
            }

            translate([0, -WHEEL_DIAMETER/2-ARM_THICKNESS/4, 0])
            sphere(d=WHEEL_DIAMETER+TOLERANCE*2);

        }
    }
}

module arm(wheel_at_other_end=false, mirror_wheel=false, bumper=false, draft=false) {
    difference() {
        union() {
            xy = [[ARM_LENGTH, 0],
                  [ARM_THICKNESS, 0],
                  [0, ARM_L2]];
            chamferer($preview||draft?0:CHAMFER, "cone")
            segments(xy, ARM_THICKNESS, ARM_WIDTH);
            
            if (!draft)
            translate([wheel_at_other_end?ARM_LENGTH:0,
                       wheel_at_other_end?0:ARM_L2, 0])
            wheel(mirror_wheel);

            if (bumper) {
                bumperer(bumper);
            }
        }

        // screw holes
        translate([0, ARM_L2, 0])
        cylinder(d=SCREW_DIAMETER+TOLERANCE, h=ARM_WIDTH*3, center=true);
        translate([ARM_LENGTH, 0, 0])
        cylinder(d=SCREW_DIAMETER+TOLERANCE, h=ARM_WIDTH*3, center=true);

        // clearances
        h = ARM_WIDTH/2 + TOLERANCE*2;
        w = ARM_THICKNESS*1.125;
        w2 = ARM_THICKNESS*3;
        w3 = ARM_THICKNESS + TOLERANCE*2;
        translate([ARM_LENGTH + w, 0, ARM_WIDTH/2])
        cube([w*3, w2, h], center=true);

        // shave ends'middle
        translate([0, ARM_L2+w3/2, ARM_WIDTH/2])
        cube([w2, w3*2, h], center=true);

        translate([0, ARM_L2, ARM_WIDTH/2])
        rotate([0, 0, -45])
        cube([ARM_THICKNESS*3.05, w2*2, h], center=true);

        // shave wheel
        translate([ARM_LENGTH/2 + ARM_L2*2, w2-ARM_L2+TOLERANCE, ARM_WIDTH/2])
        cube([ARM_LENGTH, w2, ARM_WIDTH+2], center=true);

        translate([ARM_LENGTH, -WHEEL_DIAMETER/4-ARM_THICKNESS/2, ARM_WIDTH/2])
        cube([WHEEL_DIAMETER*2, WHEEL_DIAMETER/2, h], center=true);

        translate([0, -WHEEL_DIAMETER/4-ARM_THICKNESS/2, ARM_WIDTH/2])
        cube([WHEEL_DIAMETER, WHEEL_DIAMETER/2, ARM_WIDTH], center=true);
    }

    if(!wheel_at_other_end)
        chamferer($preview||draft?0:CHAMFER, "cone")
        translate([-WHEEL_DIAMETER/2+ARM_THICKNESS/4, 0, 0])
        rounded_bar(WHEEL_DIAMETER*1.5, ARM_THICKNESS, ARM_WIDTH);
}

if(0) !union() {
    translate([0, -ARM_L2, 0]) arm();
    translate([0, 0, ARM_WIDTH/4]) spacer();
}

module spacer() {
    //y = ARM_L2 + WHEEL_DIAMETER/2;
    y = WHEEL_DIAMETER;

    difference() {
        hull() /*union()*/ {
            rotate([0, 0, 90])
            rounded_bar(y, ARM_THICKNESS, ARM_WIDTH/2);

            translate([SPACING, 0, 0])
            rotate([0, 0, 90])
            rounded_bar(y, ARM_THICKNESS, ARM_WIDTH/2);

            translate([0, y/2, 0])
            chamferer($preview?0:CHAMFER, "cone")
            rounded_bar(SPACING, ARM_THICKNESS, ARM_WIDTH/2);

        }

        // screw holes
        for (px=[0, SPACING]) for (py=[0, y]) {
            translate([px, py, 0])
            cylinder(d=SCREW_DIAMETER+TOLERANCE, h=ARM_WIDTH*3, center=true);
        }
        
        // central hole
        k = .8;
        d1 = SPACING * k;
        d2 = WHEEL_DIAMETER * k;
        translate([SPACING/2, y/2, 0])
        resize([d1, d2, ARM_WIDTH*3])
        cylinder(center=true);
    }
}

module plate_arms(h, bottom) {
    l = L;
    l2 = l * .65;

    // arm
    difference() {
        // full arms
        for (i=[0: bottom?2:0]) {
            rotate([0, 0, i*120])
            chamferer($preview?0:CHAMFER, "cone")
            hull() {
                r = i==0 ? l : l2;
                w = ARM_WIDTH * (i==0 ? 1 : .9);
                translate([-r, 0, 0]) rotate([-90, 0, 0])
                cylinder(d=ARM_THICKNESS, h=w, center=true, $fn=fn2);

                th = i==0 ? ARM_THICKNESS : h*.9;
                translate([0, 0, i==0 ? 0 : th/2 - ARM_THICKNESS/2])
                cube([ATOM, w, th], center=true);
            }
        }

        // hollowings
        for (ky=[-1, 1]) {
            y = (ARM_WIDTH*3/8+TOLERANCE/2)*ky;
            w = ARM_WIDTH/4+TOLERANCE;
            translate([-l+SPACING, y, ARM_THICKNESS/2])
            rotate([0, -45, 0])
            cube([ARM_THICKNESS*2, w, ARM_THICKNESS*2], center=true);

            translate([-l, y, 0])
            cube([ARM_THICKNESS*1.125, w, ARM_THICKNESS*3], center=true);            }

        // screw holes
        for (x=[-l, -l+SPACING])
            translate([x, 0, 0])
        rotate([90, 0, 0])
        cylinder(d=SCREW_DIAMETER+TOLERANCE, h=ARM_WIDTH*2, center=true);
        
        // cylinder
        //cylinder(d=D, h=D*2, center=true);
    }
}

module plate(bottom=false) {
    translate([0, 0, ARM_THICKNESS/2]){
        // round base
        h = ARM_THICKNESS*1.5 + WHEEL_DIAMETER/2;
        cfn = 16;

        difference() {
            union() {
                translate([0, 0, -ARM_THICKNESS/2])
                chamferer($preview?0:CHAMFER,
                          bottom ? "cone-up" : "cone",
                          fn=cfn)
                cylinder(d=D, h=h);

                difference() {
                    plate_arms(h, bottom);
                    if (!bottom)
                        translate([0, 0, -ARM_THICKNESS/2])
                        cylinder(d=D, h=CHAMFER);
                }
            }
            
            translate([0, 0, -ARM_THICKNESS/2 + h -DH+.1])
            cylinder(d1=D3, d2=D3+DH*2, h=DH);

        }
    }
}

!plate(0);

////////////////////////////////////////////////////////////////////////////////

module arms(with_spacing=false) {
    sp = with_spacing ? 15*K : 0;

    if (with_spacing)
        translate([ARM_LENGTH/2, -WHEEL_DIAMETER/2, -ARM_WIDTH/4])
        translate([0, 0, ARM_WIDTH/4])
        spacer();
    else
        translate([0, 0, ARM_WIDTH/4])
        spacer();

    translate([0, -ARM_L2 -sp*3, 0])
    arm();

    translate([ARM_LENGTH+SPACING,  -sp*2, 0])
    scale([-1, -1, 1])
    arm(true, bumper="f");

    translate([0, WHEEL_DIAMETER+ARM_L2 +sp, 0])
    scale([1, -1, 1])
    arm(mirror_wheel=true);

    translate([ARM_LENGTH+SPACING, WHEEL_DIAMETER, 0])
    scale([-1, 1, 1])
    arm(true, mirror_wheel=true, bumper="m");
}

module arms_printing() {
    sp = 3*K;
    sy = ARM_THICKNESS/2 + sp;

    translate([0, sy, 0])
    arm();

    translate([ARM_LENGTH + sp*3,
               sy*5.4,
               0])
    scale([-1, -1, 1])
    arm(true, bumper="f");

    translate([0, -sy, 0])
    scale([1, -1, 1])
    arm(mirror_wheel=true);

    translate([ARM_LENGTH + sp*3, -sy*5.4, 0])
    scale([-1, 1, 1])
    arm(true, mirror_wheel=true, bumper="m");
}

module all(cross_cut=false) {
    difference() {
        union() {
            l = L;
            translate([0, 0, ARM_L2+ARM_THICKNESS/2])
            rotate([90, 0, 0])
            translate([-ARM_LENGTH - l, 0, -ARM_WIDTH/2]) arms();

            // plate down
            plate(bottom=true);

            // plate up
            translate([0, 0,
                       //ARM_THICKNESS*4 + TOLERANCE*3 + WHEEL_DIAMETER/2
                       ARM_THICKNESS*3 + WHEEL_DIAMETER + TOLERANCE*2
                       ])
            scale([1, 1, -1])
    %        plate();
        }

        if (cross_cut)
            translate([-500, 0, -500])
            cube(1000);
    }
}

module all_printing() {
    arms(with_spacing=true);

    translate([0, -D*1.3, 0])
    rotate([0, 0, 90])
    plate(bottom=true);

    translate([D*1.1, -D*1.3, 0])
    rotate([0, 0, 90])
    plate();
}

//!all();
//!all(true);
//!all_printing();
//!arms_printing();


translate([12, 0, 0])
plate(bottom=true);
%cylinder(d=200);
