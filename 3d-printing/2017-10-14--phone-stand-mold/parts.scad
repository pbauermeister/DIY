include <definitions.scad>
elevation =  BASE_MIN_THICKNESS + PIPE_DIAMETER_INNER/2 + PIPE_MARGIN - WALL_THICKNESS;

module diagonal_end_rest_raw(flat=false, with_hole=false) {
    translate([0, 0, elevation])
    rotate([0, 45, 0]) {
        // bottom-most wall, shorter to create rest
        translate([0, 0, -REST_HEIGHT/2])
        difference() {
            // wall, full surface, creating rest top
            thickness = flat? REST_HEIGHT /2 : REST_LENGTH;
            dz = REST_HEIGHT + thickness/2;
            translate([-dz, 0, dz])
            cube([PIPE_DIAMETER_INNER* S2 *2, PIPE_DIAMETER_INNER, thickness], true);

            // remove extraneous rest top
            translate([-REST_LENGTH-WALL_THICKNESS, 0, REST_HEIGHT])
            cube([PIPE_DIAMETER_INNER* S2 + REST_HEIGHT*S2, PIPE_DIAMETER_INNER+ATOM*2, REST_HEIGHT+REST_LENGTH*2], true);
            
            if (with_hole)
                translate([0, 0, SCREW_HEAD_THICKNESS + WALL_THICKNESS])
                make_screw(true);
        }
    }
}

module diagonal_end_rest(flat=false, with_hole=false) {
    thickness = REST_LENGTH;
    dz = REST_HEIGHT + thickness/2 +REST_HEIGHT/2;
    dz = WALL_THICKNESS*2;
    rotate([0, flat?-45:0, 0])
    translate([0, 0, flat?-elevation-dz:0])
    intersection() {
        radius = PIPE_DIAMETER_INNER/2;
        diagonal_end_rest_raw(flat, with_hole);
        if (flat)
            barrel(radius-TOLERANCE, 0, PIPE_HEIGHT);
    }
}

module diagonal_end_holes(is_wall) {
    translate([0, 0, elevation])
    rotate([0, 45, 0]) {
        d = is_wall ? LOGO_TENONS_DIAMETER + WALL_THINNER_THICKNESS * 2 : LOGO_TENONS_DIAMETER;
        z =  -REST_HEIGHT/2  +  (is_wall ? WALL_THINNER_THICKNESS : -ATOM);
        translate([LOGO_TENONS_X_SHIFT, +LOGO_TENONS_DISTANCE/2, z])
        cylinder(d=d, h=LOGO_TENONS_DEPTH);
        translate([LOGO_TENONS_X_SHIFT, -LOGO_TENONS_DISTANCE/2, z])
        cylinder(d=d, h=LOGO_TENONS_DEPTH);
    }
}

module make_screw(is_clearance) {
    pos = (PIPE_DIAMETER_INNER* S2 + REST_HEIGHT*S2)/2 - REST_LENGTH + WALL_THICKNESS;
    translate([pos, 0, REST_HEIGHT/2 + WALL_THICKNESS])
    screw(is_clearance_hole=is_clearance);
}

module diagonal_end_raw() {
    translate([0, 0, elevation])
    rotate([0, 45, 0]) {
        difference() {
            union() {
                //
                // bottom-most wall, shorter to create rest
                //
                difference() {
                    union() {
                        translate([-REST_LENGTH, 0, 0])
                        cube([PIPE_DIAMETER_INNER* S2 + REST_HEIGHT*S2, PIPE_DIAMETER_INNER, REST_HEIGHT], true);
                        // cable grove
                        cube([PIPE_DIAMETER_INNER* S2 + REST_HEIGHT*S2, PLUG_GROVE_WIDTH, REST_HEIGHT], true);   
                    }
                    // make wall thinner
                    translate([-REST_LENGTH-WALL_THICKNESS, 0, WALL_THICKNESS*1.5])
                    cube([PIPE_DIAMETER_INNER* S2 + REST_HEIGHT*S2, PIPE_DIAMETER_INNER, REST_HEIGHT+WALL_THICKNESS], true);
                }

                // long diameter foot
                h = PIPE_DIAMETER_INNER;
                hf1 = 1;
                translate([0, 0, h/2*hf1 - REST_HEIGHT/2])
                cube ([PIPE_DIAMETER_INNER* S2*S2, WALL_THIN_THICKNESS, h*hf1], true);

                // short diameter foot
                hf2 = 1/4;
                translate([0, 0, PIPE_DIAMETER_INNER/2*hf2 - REST_HEIGHT/2])
                cube ([WALL_THIN_THICKNESS, PIPE_DIAMETER_INNER, PIPE_DIAMETER_INNER*hf2], true);
            }
            // screw hole
            make_screw(false);
        }
    }

    diagonal_end_holes(true);
}

module diagonal_end(flat=false) {
    sink = flat ? -elevation + REST_HEIGHT / S2 : 0;
    rot = flat ? -45 : 0;
    
    rotate([0, rot, 0])
    translate([0, 0, sink])
    difference() {
        intersection() {
            diagonal_end_raw();
            barrel(PIPE_DIAMETER_INNER/2, 0, PIPE_HEIGHT);
        }
        // remove rest
        diagonal_end_rest();
        diagonal_end_holes(false);
    }
}

module perpendicular_end_raw(recess) {
    translate([0, 0, CABLE_GROVE_HEIGHT/2 + PIPE_MARGIN/2])
    trapezoid ([PIPE_DIAMETER_OUTER, CABLE_GROVE_WIDTH-recess*2, CABLE_GROVE_HEIGHT + PIPE_MARGIN], true);

    translate([-CAVITY_SHORTAGE/2, 0, CAVITY_HEIGHT/2 + PIPE_MARGIN/2])
    trapezoid ([PIPE_DIAMETER_INNER-CAVITY_SHORTAGE, CAVITY_WIDTH-recess*2, CAVITY_HEIGHT + PIPE_MARGIN], true);

    if (!recess) {
        // marks
        translate([0, 0, PIPE_MARGIN/2])
        trapezoid ([PIPE_DIAMETER_OUTER, CABLE_GROVE_WIDTH+MARK_THICKNESS*2-recess*2, PIPE_MARGIN], true);

        translate([-CAVITY_SHORTAGE/2, 0, PIPE_MARGIN/2])
        trapezoid ([PIPE_DIAMETER_INNER-CAVITY_SHORTAGE, CAVITY_WIDTH+MARK_THICKNESS*2-recess*2, PIPE_MARGIN], true);
        
        // strut
        strut_height = WALL_THICKNESS;
        translate([0, 0, strut_height/2])
        cube ([WALL_THICKNESS, PIPE_DIAMETER_INNER, strut_height], true); 
    }
}

module perpendicular_end_stop() {
    translate([0, 0, -STOP_THICKNESS/2])
    cube ([PIPE_DIAMETER_OUTER, CABLE_GROVE_WIDTH+MARK_THICKNESS*2, STOP_THICKNESS], true);

    translate([-CAVITY_SHORTAGE/2 -PIPE_THICKNESS/2, 0, -STOP_THICKNESS/2])
    cube ([PIPE_DIAMETER_OUTER-PIPE_THICKNESS-CAVITY_SHORTAGE, CAVITY_WIDTH+MARK_THICKNESS*2, STOP_THICKNESS], true);
    
    translate([0, 0, -STOP_THICKNESS/2])
    cube ([WALL_THICKNESS, PIPE_DIAMETER_OUTER, STOP_THICKNESS], true); 
}

module perpendicular_end(flat=false) {
    translate([0, 0, flat ? STOP_THICKNESS : 0])
    {
        intersection() {
             difference(){
                perpendicular_end_raw(0);
                 translate([-WALL_THINNER_THICKNESS, 0, -WALL_THINNER_THICKNESS])
                perpendicular_end_raw(WALL_THINNER_THICKNESS);
            }
            barrel(PIPE_DIAMETER_INNER/2, 0, PIPE_HEIGHT);
        }
        perpendicular_end_stop();
    }
}

perpendicular_end();
diagonal_end();
%barrel(PIPE_DIAMETER_OUTER/2, PIPE_DIAMETER_INNER/2, PIPE_HEIGHT);

translate([150, 0, 0])
diagonal_end(flat=true);
