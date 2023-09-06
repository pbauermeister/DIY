/* Bender robot head, holder for earplugs.
 *
 *
 * https://upload.wikimedia.org/wikipedia/en/a/a6/Bender_Rodriguez.png
 */

// Eyes
EYE_SPHERE = 10;
EYE_DIAMETER = 12;
EYE_LENGTH = 24;

// Head
HEAD_DIAMETER = EYE_DIAMETER*2 + 3;
HEAD_HEIGHT = HEAD_DIAMETER*1.66;

// Visor
VISOR_POS_Z = HEAD_DIAMETER*.85;
VISOR_POS_X = HEAD_DIAMETER*.15;

// Mouth and teeth
MOUTH_RECESS = 2;
MOUTH_ANGLE = 30;
MOUTH_D = HEAD_DIAMETER/3;
MOUTH_Z = MOUTH_D * .5;
TEETH_GAP = .5;
TEETH_ANGLE_STEP = 20;
TEETH_GAP_RECESS = .25;

// Antenna
_ANTENNA_DIAMETERS = [HEAD_DIAMETER/6, HEAD_DIAMETER/12, HEAD_DIAMETER/20, HEAD_DIAMETER/8];
ANTENNA_DIAMETERS = [HEAD_DIAMETER/4, HEAD_DIAMETER/10, HEAD_DIAMETER/14, HEAD_DIAMETER/6];
ANTENNA_HEIGHTS = [HEAD_DIAMETER/18, HEAD_DIAMETER/4];

// General
WALL = 1.2; //1.5;

// Misc
ATOM    =  0.01;
HIRES   = !$preview;
$fn     = HIRES ? 100:20;
fn_mink = HIRES ?  20: 6;

module eye() {
    hull() {
        translate([EYE_LENGTH - EYE_SPHERE/2, 0, 0])
        sphere(d=EYE_SPHERE);

        rotate([0, 90, 0])
        cylinder(d=EYE_DIAMETER, h=ATOM);
    }
}

module eyes() {
    translate([0, -EYE_DIAMETER/2, 0]) eye();
    translate([0,  EYE_DIAMETER/2, 0]) eye();
}

VISOR_K = .66;
VISOR_LENGTH = EYE_LENGTH-EYE_SPHERE*.20;

module visor_block(extra=0) {
    hull() {
        translate([-extra, -EYE_DIAMETER*(1-VISOR_K/2), 0])
        scale([1, VISOR_K, 1])
        rotate([0, 90, 0])
        cylinder(d=EYE_DIAMETER, h=VISOR_LENGTH+extra*2);

        translate([-extra, +EYE_DIAMETER*(1-VISOR_K/2), 0])
        scale([1, VISOR_K, 1])
        rotate([0, 90, 0])
        cylinder(d=EYE_DIAMETER, h=VISOR_LENGTH+extra*2);
    }
}

module eyes_hollowing(extra=0) {
    hull() {
        translate([-HEAD_DIAMETER, -EYE_DIAMETER/2, 0])
        rotate([0, 90, 0])
        cylinder(d=EYE_DIAMETER-WALL, h=HEAD_DIAMETER);

        translate([-HEAD_DIAMETER, EYE_DIAMETER/2, 0])
        rotate([0, 90, 0])
        cylinder(d=EYE_DIAMETER-WALL, h=HEAD_DIAMETER);
    }
}


module visor_core() {
    difference() {
        minkowski() {
            visor_block();
            rotate([0, 90, 0])
            cylinder(d=ATOM, h=ATOM, $fn=fn_mink);
        }
        visor_block(1);
    }
}

module visor() {
    minkowski() {
        visor_core();
        sphere(d=WALL, $fn=fn_mink);
    }
}

module head_block() {
    cylinder(d=HEAD_DIAMETER, h=HEAD_HEIGHT - HEAD_DIAMETER/2);
    translate([0, 0, HEAD_HEIGHT - HEAD_DIAMETER/2])
    sphere(d=HEAD_DIAMETER);
}

module head() {
    difference() {
        head_block();

        // visor hollowing
        translate([-VISOR_POS_X, 0, VISOR_POS_Z])
        visor_block();

        // back hollowing
        if (1) {
            translate([-VISOR_POS_X, 0, VISOR_POS_Z])
            scale([1, .66, .8])
            visor_block(30);
        } else {
            translate([-VISOR_POS_X*0, 0, VISOR_POS_Z])
            eyes_hollowing(30);
        }

        // mouth hollowing
        translate([0, 0, MOUTH_D/2 + MOUTH_Z])
        hull() {
            rotate([0, 0, MOUTH_ANGLE]) rotate([90, 0, 0])
            cylinder(d=MOUTH_D, h=HEAD_DIAMETER);

            rotate([0, 0, 180-MOUTH_ANGLE]) rotate([90, 0, 0])
            cylinder(d=MOUTH_D, h=HEAD_DIAMETER);
        }
    }

    teeth();
}

module teeth() {
    translate([0, 0, MOUTH_Z]) {
        cylinder(d=HEAD_DIAMETER - MOUTH_RECESS - TEETH_GAP_RECESS*2, h=MOUTH_D);
        difference() {
            cylinder(d=HEAD_DIAMETER - MOUTH_RECESS, h=MOUTH_D);

            translate([0, 0, MOUTH_D/3])
            cylinder(d=HEAD_DIAMETER, h=TEETH_GAP, center=true);

            translate([0, 0, MOUTH_D/3*2])
            cylinder(d=HEAD_DIAMETER, h=TEETH_GAP, center=true);
     
            for (a=[MOUTH_ANGLE:TEETH_ANGLE_STEP:180-MOUTH_ANGLE]) {
                rotate([0, 0, a-90])
                translate([0, -TEETH_GAP/2, -MOUTH_D*0.25])           
                cube([HEAD_DIAMETER, TEETH_GAP, MOUTH_D*1.5]);
            }
        }
    }
}

module antenna() {
    translate([0, 0, HEAD_HEIGHT-ATOM]) {
        h = HEAD_DIAMETER/10;
        d = ANTENNA_DIAMETERS[3];
        translate([0, 0, -h])        
        cylinder(d=ANTENNA_DIAMETERS[0], h);
        
        
        cylinder(d1=ANTENNA_DIAMETERS[0], d2=ANTENNA_DIAMETERS[1], h=ANTENNA_HEIGHTS[0]);
        translate([0, 0, ANTENNA_HEIGHTS[0]])
        cylinder(d1=ANTENNA_DIAMETERS[1], d2=ANTENNA_DIAMETERS[2], h=ANTENNA_HEIGHTS[1] + d/2);

        translate([0, 0, ANTENNA_HEIGHTS[0]+ANTENNA_HEIGHTS[1]+ANTENNA_DIAMETERS[3]/2])
        sphere(d=d);
    }
}

module bender_head() {
    translate([-VISOR_POS_X, 0, VISOR_POS_Z]) {
        visor();
        %eyes();
    }
    head();
    antenna();
}

//rotate([0, -45, 0])
bender_head();
