

POLE_DIAMETER  =  24;
STICK_DIAMETER =  23;
LENGTH_1       = 100;
LENGTH_2       = 120;

THICKNESS      =   4.5;
ANGLE          =  15;
DISTANCE       =  30;
GAP            =   1.5 /2;
PLAY           =   0.5;

SCREW_DIAMETER =   8.5;
SCREW_HEAD     =  15;

$fn = $preview ? 20 : 100;


module bar(d, h, oval=false, fluted=false, center=false) {
    k = oval ? (d+PLAY*2) / d : 1;
    
    scale([1, k, 1]) {
        if (fluted) {
            n = 7;  // must be an odd number
            w = d/n*1.7;
            for (i=[0:n-1])
                rotate([0, 0, 360/n*i + 90])
                translate([-d/2 + PLAY, -w/2, center?-h/2 : 0])
                cube([d-PLAY, w, h]);
            }
        else {
            cylinder(d=d, h=h, center=center);
        }
    }
}

module pole_and_stick(drilling) {
    bar(d=POLE_DIAMETER, h=LENGTH_1*4, oval=drilling, fluted=drilling, center=true);

    translate([0, DISTANCE, 0])
    rotate([-ANGLE, 0, 0])
    translate([0, 0, STICK_DIAMETER*sin(ANGLE)/2])
    bar(d=STICK_DIAMETER, h=LENGTH_2*4, oval=drilling, fluted=drilling, center=!true);
}

module core() {
    hull() {
        bar(d=POLE_DIAMETER, h=LENGTH_1, center=!true);
        translate([0, DISTANCE, 0])
        bar(d=POLE_DIAMETER, h=LENGTH_1, center=!true);
    }

    hull() {
        translate([0, DISTANCE, 0])
        bar(d=POLE_DIAMETER, h=LENGTH_1, center=!true);

        translate([0, DISTANCE, 0])
        rotate([-ANGLE, 0, 0])
        translate([0, 0, STICK_DIAMETER*sin(ANGLE)/2])
        bar(d=STICK_DIAMETER, h=LENGTH_2);
    }
}

module holder(right_half=false, left_half=false) {
    difference()
    {
        minkowski() {
            core();
            sphere(r=THICKNESS);
        }

        // passages
        pole_and_stick(true);
        
        // screw
        z = LENGTH_2*.5; // (LENGTH_1+LENGTH_2)/4;
        l = POLE_DIAMETER+STICK_DIAMETER;
        translate([0, POLE_DIAMETER/2 + DISTANCE/2, z]) {
            rotate([0, 90, 0])
            cylinder(d=SCREW_DIAMETER, h=l, center=true);

            rotate([0, 90, 0])
            translate([0, 0, POLE_DIAMETER/2 +1])
            cylinder(d=SCREW_HEAD, h=l, $fn=6);
        }
        
        // base
        translate([0, 0, -6-THICKNESS + .2])
        cylinder(r=100, h=6);
        
        // halfing
        hw = POLE_DIAMETER+STICK_DIAMETER;
        hl = (POLE_DIAMETER+STICK_DIAMETER+DISTANCE)*4;
        hh = (LENGTH_1+LENGTH_2)*2;
        if (left_half)
            translate([-GAP/2, -hl/2, -hh/2])
            cube([hw, hl, hh]);
        if (right_half)
            translate([GAP/2-hw, -hl/2, -hh/2])
            cube([hw, hl, hh]);
    }

//    %pole_and_stick();
}

translate([-GAP/2, 0, 0])
holder(left_half=true);

translate([GAP/2, 0, 0])
holder(right_half=true);

translate([-GAP*2, STICK_DIAMETER/2 +2, 0])
cube([GAP*4, 1, LENGTH_1]);

translate([-GAP*2, -POLE_DIAMETER/2 -3, 0])
cube([GAP*4, 1, LENGTH_1]);

translate([-GAP*2, DISTANCE+STICK_DIAMETER/2+3, 0])
rotate([-ANGLE, 0, 0])
cube([GAP*4, 1, LENGTH_2]);
