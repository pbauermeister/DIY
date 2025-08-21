use <../chamferer.scad>
use <../Getriebe.scad>

K = 1/2; // 1/3.5;

TOLERANCE       =   0.3;

ARM_LENGTH      = 120*K;
ARM_THICKNESS   =  12*K            ;// + .5;
ARM_WIDTH       =  90*K            ;// *0+18;
SPACING         =  40*K;

WHEEL_DIAMETER  =  30*K;

D               =  90*K            ;//  +1.2;
D2              =  75*K;

CHAMFER         =   1*K;

SCREW_DIAMETER  =   4*K            ;// *0+2.2;

ARM_L2          = ARM_THICKNESS + TOLERANCE*1;

$fn  = 200;
ATOM = 0.001;

module rounded_bar(l, w, th) {
    hull() {
        cylinder(d=w, h=th);
        translate([l, 0, 0]) cylinder(d=w, h=th);
    }
}

module segments(xy, d, h) {
    for (i=[1:len(xy)-1]) {
        hull() {
            translate([xy[i-1][0], xy[i-1][1], 0])
            cylinder(d=d, h=h);
            translate([xy[i][0], xy[i][1], 0])
            cylinder(d=d, h=h);
        }
    }
}

module wheel(mirror=false) {
    n = 5+2;
if (1)
    rotate([0, 0, mirror ? 0 : 180])
    pfeilrad(modul=WHEEL_DIAMETER / n,
             zahnzahl=n,
             hoehe=ARM_WIDTH,
             bohrung=0,
             eingriffswinkel=20,
             schraegungswinkel=25);
else
    cylinder(d=WHEEL_DIAMETER + 3.1416*WHEEL_DIAMETER/(n*2-3), h=ARM_WIDTH);
}

if (0) !union() {
    wheel();
    translate([0, WHEEL_DIAMETER, 0])

    scale([1, -1, 1])
    wheel(1);
}


module arm(wheel_at_other_end=false, mirror_wheel=false) {
    difference() {
        union() {
            xy = [[ARM_LENGTH, 0],
                  [(SPACING-ARM_THICKNESS/2)*0 + ARM_THICKNESS, 0],
                  [0, ARM_L2]];

            chamferer($preview?0:CHAMFER, "cone")
            segments(xy, ARM_THICKNESS, ARM_WIDTH);
            
            translate([wheel_at_other_end?ARM_LENGTH:0,
                       wheel_at_other_end?0:ARM_L2, 0])

//            %cylinder(d=WHEEL_DIAMETER, h=ARM_WIDTH);
            wheel(mirror_wheel);
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
        cube([WHEEL_DIAMETER, WHEEL_DIAMETER/2, h], center=true);

    }
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
    }    
}

module plate() {
    translate([0, 0, ARM_THICKNESS/2]){
        // round base
        h = ARM_THICKNESS*1.5 + WHEEL_DIAMETER/2;


        chamferer($preview?0:CHAMFER, "cone")
        difference() {
            translate([0, 0, -ARM_THICKNESS/2])
            cylinder(d=D, h=h);

            recess = 3*K;
            chamferer($preview?0:recess, "cone")
            translate([0, 0, ARM_THICKNESS*1.5 -recess])
            cylinder(d=D2+recess*2, h=ARM_THICKNESS*2);

        }

        l = SPACING + D/2 + ARM_L2 + ARM_THICKNESS/2;

        difference() {
            //arm
            chamferer($preview?0:CHAMFER, "cone")
            hull() {
                w = ARM_WIDTH; //*1.5;
                translate([-l, 0, 0]) rotate([-90, 0, 0])
                cylinder(d=ARM_THICKNESS, h=w, center=true);

                cube([ATOM, w, ARM_THICKNESS], center=true);
            }

            // hollowings
            for (ky=[-1, 1]) {
                y = (ARM_WIDTH*3/8+TOLERANCE/2)*ky;
                w = ARM_WIDTH/4+TOLERANCE;
                translate([-l+SPACING, y, ARM_THICKNESS/2])
                rotate([0, -45, 0])
            cube([ARM_THICKNESS*2, w, ARM_THICKNESS*2], center=true);

                translate([-l, y, 0])
                cube([ARM_THICKNESS*1.125, w, ARM_THICKNESS*3], center=true);            
            }

            // screw holes
            for (x=[-l, -l+SPACING])
                translate([x, 0, 0])
            rotate([90, 0, 0])
            cylinder(d=SCREW_DIAMETER+TOLERANCE, h=ARM_WIDTH*2, center=true);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////

module arms(with_spacing=false) {
    sp = with_spacing ? 12*K : 0;

    if (with_spacing)
        translate([ARM_LENGTH/2, -ARM_THICKNESS*5 - WHEEL_DIAMETER, -ARM_WIDTH/4])
        translate([D, 0, ARM_WIDTH/4])
        spacer();
    else
        translate([0, 0, ARM_WIDTH/4])
        spacer();

    translate([0, -ARM_L2 -sp*3, 0])
    arm();

    translate([ARM_LENGTH+SPACING,  -sp*2, 0])
    scale([-1, -1, 1])
    arm(true);

    translate([0,
               WHEEL_DIAMETER+ARM_L2 +sp, // ARM_L2*2 + WHEEL_DIAMETER/2,
               0])
    scale([1, -1, 1])
    arm(, mirror_wheel=true);

    translate([ARM_LENGTH+SPACING,
               WHEEL_DIAMETER, //ARM_L2 -sp*1 + WHEEL_DIAMETER/2,
               0])
    scale([-1, 1, 1])
    arm(true, mirror_wheel=true);
}

module arms_printing() {
    translate([D/2 + ARM_THICKNESS*3+3, 0, 0])
    rotate([0, 0, 90])
    translate([-ARM_LENGTH/2-SPACING/2, 0, 0])
    union()
    arms(with_spacing=true);
}

difference() {
    union() {
        l = SPACING + D/2 + ARM_L2 + ARM_THICKNESS/2;
        translate([0, 0, ARM_L2+ARM_THICKNESS/2])
        rotate([90, 0, 0])
        translate([-ARM_LENGTH - l, 0, -ARM_WIDTH/2]) arms();

        // plate down
        plate();

        // plate up
        translate([0, 0,
                   //ARM_THICKNESS*4 + TOLERANCE*3 + WHEEL_DIAMETER/2
                   ARM_THICKNESS*3 + WHEEL_DIAMETER + TOLERANCE*2
                   ])
        scale([1, 1, -1])
%        plate();
    }

    translate([-500, 0, -500])
    cube(1000);
}



module all_printing() {
    arms(with_spacing=true);

    translate([0, -D*1.3, 0])
    rotate([0, 0, 90])
    plate();

    translate([D*1.1, -D*1.3, 0])
    rotate([0, 0, 90])
    plate();
}

!all_printing();
