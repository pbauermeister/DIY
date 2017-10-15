include <definitions.scad>
elevation =  BASE_MIN_THICKNESS + PIPE_DIAMETER_INNER/2 + PIPE_MARGIN - WALL_THICKNESS;

module diagonal_end_rest_raw(thin=false) {
    translate([0, 0, elevation])
    rotate([0, 45, 0]) {
        // bottom-most wall, shorter to create rest
        translate([0, 0, -REST_HEIGHT/2])
        difference() {
            // wall, full surface, creating rest top
            thickness = thin ? 0.5 : WALL_THICKNESS;
            dz = REST_HEIGHT + thickness/2;
            translate([-dz, 0, dz])
            cube([PIPE_DIAMETER_INNER* S2 *2, PIPE_DIAMETER_INNER, thickness], true);

            translate([-REST_LENGTH-WALL_THICKNESS, 0, REST_HEIGHT])
            cube([PIPE_DIAMETER_INNER* S2 + REST_HEIGHT*S2, PIPE_DIAMETER_INNER+ATOM*2, REST_HEIGHT+WALL_THICKNESS], true);
        }
    }
}

module diagonal_end_rest(thin=false, recessed=false) {
    intersection() {
        radius = PIPE_DIAMETER_INNER/2 - (recessed ? 0.5 : 0);
        diagonal_end_rest_raw(thin);
        barrel(radius, 0, PIPE_HEIGHT);
    }
}

module diagonal_end_raw() {
    translate([0, 0, elevation])
    rotate([0, 45, 0]) {
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
            translate([-REST_LENGTH-WALL_THICKNESS, 0, WALL_THICKNESS*1.5])
            cube([PIPE_DIAMETER_INNER* S2 + REST_HEIGHT*S2, PIPE_DIAMETER_INNER, REST_HEIGHT+WALL_THICKNESS], true);
        }

        // long foot
        h = PIPE_DIAMETER_INNER * 2;
        translate([0, 0, h/2 - REST_HEIGHT/2])
        cube ([PIPE_DIAMETER_INNER* S2*S2, WALL_THIN_THICKNESS, h], true);
        
        // short foot
        translate([0, 0, PIPE_DIAMETER_INNER/2 - REST_HEIGHT/2])
        cube ([WALL_THIN_THICKNESS, PIPE_DIAMETER_INNER, PIPE_DIAMETER_INNER], true);
    }
}

module diagonal_end(flat=false) {
    sink = flat ? -elevation + REST_HEIGHT / S2 : 0;
    rot = flat ? -45 : 0;
    
    rotate([0, rot, 0])
    translate([0, 0, sink])
    {
        diagonal_end_rest();
        intersection() {
            diagonal_end_raw();
            barrel(PIPE_DIAMETER_INNER/2, 0, PIPE_HEIGHT);
        }
    }
}

module diagonal_end_rest_border() {
    sink = -elevation + REST_HEIGHT / S2;
    rot = -45;
    
    rotate([0, rot, 0])
    translate([0, 0, sink]) {
        difference() {
            diagonal_end_rest(thin=true);
            diagonal_end_rest(thin=true, recessed=true);
        }
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
                 translate([-WALL_THIN_THICKNESS, 0, -WALL_THIN_THICKNESS])
                perpendicular_end_raw(WALL_THIN_THICKNESS);
            }
            barrel(PIPE_DIAMETER_INNER/2, 0, PIPE_HEIGHT);
        }
        perpendicular_end_stop();
    }
}

perpendicular_end();
diagonal_end();
%barrel(PIPE_DIAMETER_OUTER/2, PIPE_DIAMETER_INNER/2, PIPE_HEIGHT);

