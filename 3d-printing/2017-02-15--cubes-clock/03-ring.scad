include <definitions.scad>
include <gears.scad>

COLUMN_HEIGHT = 2;

module ring() {
    h = PLATE2_H4 - PLATE2_H2 + PLAY;
    r = PLATE2_RING_THICKNESS/2;
    ring_height = h + r*2 + PLAY;
    
    translate([0, 0, PLATE2_H4 -h -r*2 - PLAY]) {
        difference() {
            union() {
                barrel(PLATE2_R4-PLAY, PLATE2_R0, h);
                barrel(PLATE2_R4 - r - PLAY, PLATE2_R0, ring_height);
            }

            k = 19.7 * 22/PLATE2_R4;
            // spring cutouts
            rotate([0, 0, 180])
            scale([k, k, PLATE2_H4*2])
            linear_extrude(height=1)
            import("spring-ball-cut.dxf");

            // on-spring cutouts
            k2 = k*1.05;
            translate([0, 0, h - PLAY])
            rotate([0, 0, 180])
            scale([k2, k2, PLATE2_H4*2])
            linear_extrude(height=1)
            offset(r=1/k *1.1)
            import("spring-ball-cut.dxf");

        }
        // legs
        translate([0, 0, ring_height])
        alignment_columns(-TOLERANCE, COLUMN_HEIGHT);
    }
    
    // ratchet ball
    translate([0, 0, PLATE2_H4-PLATE2_H1])
    translate([PLATE2_R4-PLATE2_RATCHET_RADIUS/3, 0, 0])
    sphere(r=PLATE2_RATCHET_RADIUS, true);
}

difference() {
    ring();
//    cube(50);
}

