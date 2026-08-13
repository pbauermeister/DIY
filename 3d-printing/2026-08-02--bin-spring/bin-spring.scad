use <../chamferer.scad>

SPRING_D    = 15;
SPRING_L    = 55;

WALL        = 3;

PISTON_D    = SPRING_D-3;
PISTON_L    = SPRING_L*2 + WALL*4;
PLAY        = 0.6;

BRACKET_TH  = PISTON_D + PLAY + WALL*2;
BRACKET_L   = 50;

SCREW_D     = 4;

$fn = $preview ? 20 : 100;

// Piston
module piston(dt=0) {
    w = PISTON_D/sqrt(2) + dt;

    // head
    if (!dt)
        chamferer(1.5, fn=4, shrink=false)
        translate([-w, -w/2, 0])
        cube([w*2, w, WALL*2]);

    // rod
    difference() {
        intersection() {
            chamferer(1.5, fn=4, shrink=false)
            translate([-w/2, -w/2, 0])
            cube([w, w, PISTON_L]);

            w2 = w * sqrt(2);
            rotate([0, 0, 45])
            cube([w2, w2, PISTON_L*3], center=true);
        }
        // screw hole
        translate([0, 0, PISTON_L-PISTON_D/4])
        rotate([90, 0, 0])
        cylinder(d=3, h=SPRING_D);
    }
}


// bracket
module bracket()
translate([0, 0, SPRING_L+WALL*2]) {
    difference() {
        chamferer($preview ? 0 : 1)
        union() {
            cylinder(d=BRACKET_TH, h=SPRING_L);
            
            translate([-BRACKET_L/2, BRACKET_TH/2-WALL*2, 0])
            chamferer(5, "cylinder-y", fn=$fn)
            cube([BRACKET_L, WALL*2, SPRING_L]);
        }

        piston(dt=PLAY);

        // screw holes
        for (kx=[-1, 1]) {
            for (dy=[[SCREW_D, BRACKET_TH], [SCREW_D*2.5, BRACKET_TH/2 - 2.5]])
            hull() for (y=[SCREW_D*3, SPRING_L-SCREW_D*3])
                translate([kx*((BRACKET_L-BRACKET_TH)/2), dy[1], y])
                rotate([90, 0, 0])
                cylinder(d=dy[0], h=SPRING_L*3);
        }
    }
}


piston();
bracket();