use <../hinge4.scad>

WALL               = 1.3;
L                  = 95 + WALL*2;
W                  = 60 + WALL*2;
H                  = 35 + WALL*2;

GAP                = .12;
ROUNDING_CUTOFF    = H/3.5;
HINGE_THICKNESS    = 3;
VENT_DIAMETER      = 3;
LOCK_WIDTH         = 20;
LOCK_BUMP_DIAMETER = 1.5;

OPENING_ANGLE      = 90;

$fn                = $preview ? 12 : 120;
ATOM               = .01;


module shape(l=L, recess=0, z_cutoff=0) {
    d = H-recess;
    intersection() {
        hull() {
            for (kx=[-1, 1]) {
                for (z=[ROUNDING_CUTOFF, l-ROUNDING_CUTOFF]) {
                    translate([(W-H)/2*kx, 0, z])
                    sphere(d=d);
                }
            }
        }
        translate([0, 0, z_cutoff])
        cylinder(d=H*3, h=l-z_cutoff*2);
    }
}

module lock_bump(xtra=0) {
    d = LOCK_BUMP_DIAMETER;
    
    translate([W - WALL + GAP*2, d*1.75+.5, L/2])
    cylinder(d=d + xtra*2, h=LOCK_WIDTH - 3 + xtra*2, center=true);
}

module lock_flap() {
    difference() {    
        minkowski() {
            difference() {
                translate([W-H/2 + H/4, 0, L/2])
                cylinder(d=H/2 - WALL, h=LOCK_WIDTH, center=true);

                translate([0, WALL*2, 0])
                cube([W, H, L]);
            }
            rotate([0, 0, 360/8/2])
            sphere(d=WALL*2, $fn=8);
        }
        translate([0, -GAP, 0])
        cube([W-WALL + GAP*3, H, L]);        
                translate([W/2 - HINGE_THICKNESS/2, 0, 0])
                shape();
    }
    lock_bump();
}

module cavity() {
    translate([W/2 - HINGE_THICKNESS/2, 0, 0])
    difference() {
        shape(l=L, recess=WALL*2, z_cutoff=WALL);

        translate([-W/2 + HINGE_THICKNESS/2, 0, 0])
        cube([WALL*4.5, W, L*3], center=true);
    }
}

module shape_half(male_lock) {
    translate([W/2 - HINGE_THICKNESS/2, 0, 0])
    difference() {
        shape();

        // cavity
        translate([-W/2 + HINGE_THICKNESS/2, 0, 0])
        cavity();
        
        // vents
        translate([0, 0, -H])
        shape(L*2, H-VENT_DIAMETER);
        
        // half
        translate([-L, -GAP, -L])
        cube(L*3);
        
        // hinge angle clearance
        translate([-W/2 +HINGE_THICKNESS/2 -H + GAP*2 + HINGE_THICKNESS/2, -H*.9, -L])
        cube([H, H, L*3]);

        if(0)
        translate([-W/2 +HINGE_THICKNESS/2 -H + GAP + HINGE_THICKNESS/2,
                   -H-HINGE_THICKNESS/2-GAP, -L])
        cube([H, H, L*3]);

        // lock groove
        if (!male_lock) scale([1, -1, 1])
            translate([-W/2 + HINGE_THICKNESS/2, 0, 0])
            lock_bump(.15*2);
    }
    
    if (male_lock) lock_flap();
}

module hinge() {
    intersection(){
        aa = $preview ? [15] : [0, 15, 30];
        union() for (a=aa)
            rotate([0, 0, 90 + OPENING_ANGLE])
            translate([0, 0, ROUNDING_CUTOFF])
            rotate([0, 0, -a])
            hinge4(thickness=HINGE_THICKNESS, arm_length=40, 
                   total_height=L-ROUNDING_CUTOFF*2, nb_layers=7,
                   angle=180 - OPENING_ANGLE +a*2, extra_angle=45+45);

        // shave hinge sides
        union() for (a=[0, OPENING_ANGLE])
            rotate([0, 0, a])
            translate([-HINGE_THICKNESS/2, 0, 0])
            translate([W/2, 0, 0])
            shape();
    }
}

module box() {
    difference() {
        union() {
            shape_half(true);

            rotate([0, 0, OPENING_ANGLE]) scale([1, -1, 1]) shape_half();
        }

        // hinge axis clearance
        gap = .3;
        translate([0, 0, ROUNDING_CUTOFF-gap])
        cylinder(d=HINGE_THICKNESS+1, h=L-ROUNDING_CUTOFF*2 + gap*2);
    }

    difference() {
        hinge();

        cavity();
        rotate([0, 0, OPENING_ANGLE])
        cavity();
    }
}


intersection() {
    box();
    cylinder(d=H*4, h=L/2);
}