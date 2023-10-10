include <values.inc.scad>;

$fn  = $preview ? 10 : 60;

module gripper(height, diameter, n, m, k) {
    cylinder(d=diameter, h=height);

    intersection() {
        cylinder(d=diameter*1.05, h=height);
        
        union() {
            for (j=[0:m]) {
                z = height - j*height/5*k;
                translate([0, 0, z])
                for (i=[0:n-1]) {
                    alt = j%2 ? i%2 : !(i%2);
                    a = 360/n*i;
                    zz = alt ? 0 : diameter/10/3;
                    rotate([0, 0, a])
                    translate([diameter/2 *.915, 0, zz - diameter/10*.68])
                    rotate([0, 90, alt ? 0 : 180])
                    rotate([0, 54.6, 0])
                    rotate([0, 0, 45])
                    cube(diameter/10, center=true);
                }
            }
        }
    }
}


module knob(for_hollowing=false) {
    // gripper
    if(!for_hollowing) 
        translate([0, 0, KNOB_HEIGHT/2])
        gripper(KNOB_HEIGHT/2, KNOB_DIAMETER, N, 5, 1);
    
    // needle
    if(!for_hollowing)
    intersection() {
        translate([0, 0, KNOB_HEIGHT/2])
        cylinder(d=KNOB_DIAMETER*1.2, h=KNOB_HEIGHT/2);

        translate([KNOB_DIAMETER*.05, 0, KNOB_HEIGHT*.75])
        rotate([0, 45, 0])
        cube([KNOB_DIAMETER, KNOB_DIAMETER/6, KNOB_HEIGHT], true);

        translate([0, -KNOB_DIAMETER/2, 0])
        cube(KNOB_DIAMETER);
    }

    dd = for_hollowing ? PLAY*2 : 0;

    // ring
    h = KNOB_HEIGHT/8;
    translate([0, 0, KNOB_HEIGHT/4 - h*.75])
    hull() {
        cylinder(d=KNOB_DIAMETER + dd, h=h*2);
        translate([0, 0, h/2])
        cylinder(d=KNOB_DIAMETER+h  + dd, h=h);
    }

    // body and ratchet
    difference() {
        union() {
            // body
            translate([0, 0, for_hollowing ? -.1 : 0])
            cylinder(d=KNOB_DIAMETER+dd, h=KNOB_HEIGHT + .1);

            // ratchet
            d = h*.66;
            translate([KNOB_DIAMETER/2, 0, d/2 + 1])
            sphere(d=d + dd*2);
        }
        
        if(!for_hollowing)
        rotate([0, 0, -7*0]) {
            h = KNOB_HEIGHT/7;
            translate([KNOB_DIAMETER*.35, -KNOB_DIAMETER*.2, -ATOM])
            cube([1, KNOB_DIAMETER, h]);

            translate([KNOB_DIAMETER*.35, -KNOB_DIAMETER*.25, h-ATOM*2])
            cube([10, KNOB_DIAMETER, .2]);
            }
    }
}


module box_body() {
    //gripper(KNOB_HEIGHT*.4, KNOB_DIAMETER*2, N*2, 4, 1.9);

    intersection() {
        cylinder(d=BOX_SIZE*2, h=BOX_HEIGHT*2);
        hull() {
            for (i=[-1, 1]) {
                for (j=[-1, 1]) {
                    for (k=[0, 1]) {
                        translate([i*BOX_SIZE/2, j*BOX_SIZE/2, k*BOX_HEIGHT - CHAMFER])
                        sphere(r=CHAMFER, $fn=36);
                    }
                }
            }
        }
    }
}

module box() {
    difference() {
        box_body();
        
        for (i=[0:TURNS]) {
            rotate([0, 0, 360/(TURNS+1)*i]) {
                knob(for_hollowing=true);

                translate([0, 0, BOX_HEIGHT - LETTER_DEPTH])
                linear_extrude(5)
                rotate([0, 0, -90])
                translate([-5.7, 18+2, 0])
                text(str(i), size=13, font="helvetica:bold");
            }
        }
        
    }
}

module all() {
    knob();
    box();
}


difference() {
    all();
    if ($preview) translate([-BOX_SIZE, 0, -ATOM]) cube(BOX_SIZE);
}