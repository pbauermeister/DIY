// Two pieces that attach an Insta360 telescopic pole to a ski pole.

POLE_DIAMETER  =  24;
STICK_DIAMETER =  23;
LENGTH_1       = 100;
LENGTH_2       = 120;

THICKNESS      =   4.5;
ANGLE          =  15;
DISTANCE       =  35;
GAP            =   1.5 /2;
PLAY           =   0.5;

SCREW_DIAMETER =   8.5 + .65;
SCREW_HEAD     =  15   + .65;

$fn = $preview ? 20 : 100;

module bar(d, h, oval=false, fluted=false, center=false) {
    k = oval ? (d+PLAY*2) / d : 1;
    th = 0.25;
    step = 15;
    
    scale([1, k, 1]) {
        difference() {
            dd = d + (fluted?PLAY:0);
            cylinder(d=dd, h=h, center=center);
            if (fluted) {
                for (k=[-1, 1])
                for(z=[-h:step:h]) {
                    translate([(dd/2)*k, 0, z])
                    cube([th*2, dd, 1], center=true);
                }
            }
        }
    }
}

//!bar(24, 100, fluted=true);

module pole_and_stick(drilling) {
    bar(d=POLE_DIAMETER, h=LENGTH_1*4, oval=drilling, fluted=drilling, center=true);

    translate([0, DISTANCE, 0])
    rotate([-ANGLE, 0, 0])
    translate([0, 0, STICK_DIAMETER*sin(ANGLE)/2])
    bar(d=STICK_DIAMETER, h=LENGTH_2*4, oval=drilling, fluted=drilling, center=!true);
}

module profiled_bar(d, h){
    intersection_for (a=[0, 45]) {
        rotate([0, 0, a])
        translate([-d/2, -d/2, 0])
        cube([d, d, h]);
    }
}

module core0() {
    profiled_bar(d=POLE_DIAMETER, h=LENGTH_1);

    intersection() {
        d = max(STICK_DIAMETER, POLE_DIAMETER);
        translate([0, DISTANCE, 0])
        rotate([-ANGLE, 0, 0])
        translate([0, 0, -LENGTH_2])
        profiled_bar(d=d, h=LENGTH_2*2);
        
        cylinder(r=LENGTH_2, h=LENGTH_2*2);
    }
}

module core() {
    // lower slice
    hull()
    intersection() {
        core0();
        cylinder(r=LENGTH_2, h=LENGTH_1/5);
    }
 
    // center
    core0();

    // upper slice
    hull()
    intersection() {
        core0();
 
        translate([0, 0, LENGTH_1/5*4])
        cylinder(r=LENGTH_2, h=LENGTH_1/5);
    }
}

module screw_hole() {
    l = POLE_DIAMETER+STICK_DIAMETER;

    translate([0, 0, POLE_DIAMETER/2-1]) {
        cylinder(d=SCREW_DIAMETER, h=l, center=true);
        translate([0, 0, POLE_DIAMETER/2 +1]) {
            translate([0, 0, -POLE_DIAMETER/4])
            cylinder(d=SCREW_HEAD, h=l, $fn=6);
            // reinforcement cracks
            translate([0, 0, -POLE_DIAMETER])
            difference() {
                cylinder(d=SCREW_HEAD, h=l, $fn=6);
                cylinder(d=SCREW_HEAD -.25, h=l, $fn=6);
            }
        }
    }
}

module screw_holes() {
    for (zy=[[LENGTH_1*.1, POLE_DIAMETER/2 + DISTANCE/4.8],
             [LENGTH_1*.9, POLE_DIAMETER/2 + DISTANCE/2]]) {
        z = zy[0];
        y = zy[1];
        translate([0, y, z]) {
            rotate([0, 90, 0])
            translate([0, 0, -POLE_DIAMETER/2+1])
            screw_hole();
        }
    }
}

module holder() {
    difference()
    {
        minkowski() {
            core();
            sphere(r=THICKNESS);
        }

        // passages
        pole_and_stick(true);

        // screw
        screw_holes();
        
        // base
        translate([0, 0, -6-THICKNESS])
        cylinder(r=100, h=6);
    }
}

module partitioner() {
    d = 12;
    l = 200;
    h = LENGTH_2*1.5;
    flatten = 1; //.5;
    d2 = d*sqrt(2);
    k = .35;

    scale([k, 1, 1]) {

        for(z=[-d2/2-3.5: d2: h]) {
            translate([d2/4, 0, z]) {
                intersection() {
                    rotate([0, 45, 0])
                    cube([d, l, d], center=true);
                    
                    // flatten corner
                    cube([d2-flatten*2, l, d*2], center=true);
                }
            }
        }

        // flatten corner
        translate([d2/4 - flatten, -l/2, -d])
        cube([(POLE_DIAMETER+STICK_DIAMETER)/k, l, h]);
    }
}

module support() {
    L = 60;
    H = 60;
    translate([-L+STICK_DIAMETER/2, -STICK_DIAMETER * .25, -THICKNESS])
    cube([L, .4, H]);
}

module holder_left() {
    difference() {
        holder();
        partitioner();
    }

    rotate([0, 0, 180])
    support();

}

module holder_right() {
    intersection() {
        holder();
        partitioner();
    }
    
    support();
}

//translate([-1, 0, 0]) holder_left();
translate([1, 0, 0]) holder_right();

//partitioner();
