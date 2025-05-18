PULLEY_DIAMETER      =  22;
PULLEY_EXTRA         =   3         -2;
PULLEY_AXIS_DIAMETER =   8;

BALL_DIAMETER        =   4.5;
BALLS_PER_TURN       =  14;
BALLS_SPACING        =  19 / 3;

WALL_THICKNESS       =   3;
HANDLE_LENGTH        = 100;
PLAY                 =   0.13;

// computed
R = PULLEY_DIAMETER/2 + BALL_DIAMETER/2;
PULLEYS_DISTANCE = HANDLE_LENGTH - PULLEY_DIAMETER*.75;

ATOM = 0.01;
$fn = 120;


module pulley_struct() {
    th = 2.5;
    cylinder(d=PULLEY_AXIS_DIAMETER + th*2, h=BALL_DIAMETER*5, center=true);

    for (i=[0:2:BALLS_PER_TURN-1]) {
        rotate([0, 0, 360/BALLS_PER_TURN * (i + .5*0)])
        translate([0, -PULLEY_DIAMETER/2, 0])
        cube([th, PULLEY_DIAMETER, BALL_DIAMETER*5], center= true);
    }
    
    difference() {
        cylinder(d=PULLEY_DIAMETER + PULLEY_EXTRA*2, h= BALL_DIAMETER*5-ATOM, center=true);
        cylinder(d=PULLEY_DIAMETER-th*1.5 , h=BALL_DIAMETER*5, center=true);
    }    
}

module pulley_teeth() {
    difference() {
        cylinder(d=PULLEY_DIAMETER + PULLEY_EXTRA, h= BALL_DIAMETER+PLAY*2*0);

        for (i=[0:1:BALLS_PER_TURN-1]) {
            rotate([0, 0, 360/BALLS_PER_TURN*i])
            translate([R-.5, 0, BALL_DIAMETER/2+PLAY*0]) {
                sphere(d=BALL_DIAMETER + PLAY*2, $fn=60);
            }
        }

        cylinder(d=PULLEY_AXIS_DIAMETER+PLAY*4, h=BALL_DIAMETER*5, center=true);
    }
}

module pulley() {
    intersection() {
        pulley_struct();
        pulley_teeth();
    }
}

module chain() {
    for (i=[BALLS_PER_TURN/2:1:BALLS_PER_TURN]) {
        rotate([0, 0, 360/BALLS_PER_TURN*i])
        translate([R, 0, BALL_DIAMETER/2+PLAY]) {
            sphere(d=BALL_DIAMETER, $fn=60);
        }
    }

    for (k=[-1, 1]) for(j=[1:18]) {
        translate([R*k, j*BALLS_SPACING, BALL_DIAMETER/2+PLAY])
        sphere(d=BALL_DIAMETER, $fn=60);
    }
}

module handle_0(extra=0) {
    y = -PULLEY_DIAMETER/2 - BALL_DIAMETER-PLAY*2-WALL_THICKNESS;
    inner = BALL_DIAMETER + PLAY*6;
    hull()
    for (k=[-1, 1]) {
        translate([R*k, y, BALL_DIAMETER/2+PLAY])
        rotate([-90, 0, 0])
        cylinder(d=inner+extra*2, h=HANDLE_LENGTH + PULLEY_DIAMETER);
    }
}

module handle() {
    difference() {
        translate([0, -WALL_THICKNESS, 0])
        handle_0(WALL_THICKNESS);
        handle_0();

        // hole for axis
        cylinder(d=PULLEY_AXIS_DIAMETER, BALL_DIAMETER*4, center=true);

        // hole for axis
        translate([0, PULLEYS_DISTANCE, 0])
        cylinder(d=PULLEY_AXIS_DIAMETER*.75, BALL_DIAMETER*4, center=true);
    }
}

module rivet(axis_diameter) {
    head_thickness = 2.5;
    head_extra = 1;
    h = BALL_DIAMETER + PLAY*6 + head_thickness*3;
    difference() {
        union() {
            translate([0, 0, -head_thickness-PLAY*3 - head_thickness/2])
            cylinder(d=axis_diameter - PLAY*3, h=h);

            translate([0, 0, BALL_DIAMETER + PLAY*5 + WALL_THICKNESS])
            cylinder(d1=PULLEY_AXIS_DIAMETER+head_extra+.5, d2=PULLEY_AXIS_DIAMETER-1, h=head_thickness);

            translate([0, 0, -PLAY*5 - WALL_THICKNESS - head_thickness])
            cylinder(d2=PULLEY_AXIS_DIAMETER+head_extra+.5, d1=PULLEY_AXIS_DIAMETER-1, h=head_thickness);
        }

        w = head_extra * 1.5;
        translate([-axis_diameter, -w/2, -h+BALL_DIAMETER])
        cube([axis_diameter*2, w, h]);
    }
}

module rivet1() { rivet(PULLEY_AXIS_DIAMETER); }
module rivet2() { rivet(PULLEY_AXIS_DIAMETER*.75); }

module rivets(dist=PULLEYS_DISTANCE) {
    rivet1();
    translate([0, dist, 0]) rivet2();
}

module pulleys(dist=PULLEYS_DISTANCE) {
    pulley();
    translate([0, dist, 0]) pulley();
}

module cross_cutter() {
    intersection() {
        children();
        translate([0, -HANDLE_LENGTH/2, -BALL_DIAMETER*2.5])
        cube([PULLEY_DIAMETER, HANDLE_LENGTH*2, BALL_DIAMETER*6]);
    }
}

if (0) cross_cutter() {
    union() {
        handle();
        chain();
        pulleys();
%        rivets();
    }
} else {
    %cross_cutter() handle();

    rivets();
    pulleys();
}
