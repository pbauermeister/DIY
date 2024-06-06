include <values.inc.scad>;
use <ratchet.scad>;

$fn  = $preview ? 15 : 60;

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

    ratchet();
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


module box_letters() {
    for (i=[0:TURNS-1]) {
        rotate([0, 0, 360/(TURNS)*i]) {
            translate([0, 0, BOX_HEIGHT - LETTER_DEPTH])
            linear_extrude(5)
            rotate([0, 0, -90])
            translate([-5.7, 18+2, 0])
            text(str(i), size=13, font="helvetica:bold");
        }
    }
}


module box() {
    difference() {
        box_body();
        box_letters();

        translate([0, 0, -ATOM])
        ratchet_cavity();
    }
}


module all() {
    knob();
    box();
}


difference() {
    all();
    if ($preview) translate([BOX_SIZE*0, 0, -ATOM]) cube(BOX_SIZE);
//    if ($preview) translate([0, 0, -BOX_SIZE+2.25]) cube(BOX_SIZE*2, true);
}