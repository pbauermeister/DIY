S2 = sqrt(2);
ATOM = 0.001;
TOLERANCE = 0.17;
PLAY = 0.4;

PIPE_THICKNESS = 2.5;
PIPE_DIAMETER_INNER = 102;
PIPE_DIAMETER_OUTER = PIPE_DIAMETER_INNER + 2 * PIPE_THICKNESS;
PIPE_MARGIN = 10;
PIPE_HEIGHT = 135 - 4.5; // please manually adjust

WALL_THICKNESS = 3;
WALL_THIN_THICKNESS = 2;
WALL_THINNER_THICKNESS = 1;
REST_HEIGHT = 10;
REST_LENGTH = 25;
BASE_MIN_THICKNESS = 25;
PLUG_GROVE_WIDTH = 12;

CABLE_GROVE_WIDTH = 7;
CABLE_GROVE_HEIGHT = 5;

BASE_GROOVE_WIDTH = 3.5;

CAVITY_WIDTH = 20;
CAVITY_SHORTAGE = 35;
CAVITY_HEIGHT = 30;
CAVITY_SPHERE_RADIUS_TUNING = 3;
CAVITY_SPHERE_SHIFT_TUNING = -3;

MARK_THICKNESS = 0.5;
STOP_THICKNESS = 2;

SUPPORT_THICKNESS = 0.5;

LOGO_TENONS_DISTANCE = 30;
LOGO_TENONS_DIAMETER = 5;
LOGO_TENONS_DEPTH = 10;
LOGO_TENONS_HEIGHT = 7.5;
LOGO_TENONS_X_SHIFT = 5;

SCREW_DIAMETER = 2.9;
SCREW_HEAD_DIAMETER = 5.5;
SCREW_HEAD_THICKNESS = 2;
SCREW_HEIGHT = 12; // overall


$fn = 90;

module barrel(outer_radius, inner_radius, height) {
    scale([1, 1, height])
    difference() {
        cylinder(r=outer_radius);
        if (inner_radius)
            translate([0, 0, -0.5]) scale([1, 1, 2])
            cylinder(r=inner_radius);
    }
}

module trapezoid(size, center, conicity=20, rounded=false) {
//    cube(size, center);
    x = size[0];
    y = size[1];
    z = size[2];
    d = z / conicity; // conicity
    
    points = [
    [ 0,  0,  0 ],  //0
    [ x,  0,  0 ],  //1
    [ x,  y,  0 ],  //2
    [ 0,  y,  0 ],  //3
    [ 0,  d,  z ],  //4
    [ x,  d,  z ],  //5
    [ x,  y-d,  z ],  //6
    [ 0,  y-d,  z ]]; //7

    faces = [
    [0,1,2,3],  // bottom
    [4,5,1,0],  // front
    [7,6,5,4],  // top
    [5,6,2,1],  // right
    [6,7,3,2],  // back
    [7,4,0,3]]; // left

    translate([center ? -x/2 : 0, center ? -y/2 : 0, center ? -z/2 : 0]) {
        polyhedron(points, faces);

        if (rounded)
            translate([x/2, y/2, z])
            scale([1, 1, 0.5])
            rotate([0, 90, 0])
            cylinder(h=x, r=y/2-d, center=true);
    }
}

module screw(head_extent=0, is_clearance_hole=false) {   
    // thread
    translate([0, 0, -SCREW_HEIGHT + SCREW_HEAD_THICKNESS])
    cylinder(h=SCREW_HEIGHT,
             r=SCREW_DIAMETER/2 - TOLERANCE
               + (is_clearance_hole ? TOLERANCE*2 : 0));
    // head
    for (i=[0:head_extent])
        translate([0, 0, i])
        cylinder(h=SCREW_HEAD_THICKNESS, 
                 r=SCREW_HEAD_DIAMETER/2 + (is_clearance_hole ? PLAY : 0));
}

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
                cube([PIPE_DIAMETER_INNER* S2*S2, WALL_THIN_THICKNESS, h*hf1], true);

                // short diameter foot
                hf2 = 1/4;
                translate([0, 0, PIPE_DIAMETER_INNER/2*hf2 - REST_HEIGHT/2])
                cube([WALL_THIN_THICKNESS, PIPE_DIAMETER_INNER, PIPE_DIAMETER_INNER*hf2], true);
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
    // small chamber
    translate([0, 0, CABLE_GROVE_HEIGHT/2 + PIPE_MARGIN/2])
    trapezoid([PIPE_DIAMETER_OUTER, CABLE_GROVE_WIDTH-recess*2, CABLE_GROVE_HEIGHT + PIPE_MARGIN], true, 10, true);

    // big chamber
    translate([-CAVITY_SHORTAGE/2, 0, CAVITY_HEIGHT/2 + PIPE_MARGIN/2]) {
        intersection() {
            trapezoid([PIPE_DIAMETER_INNER-CAVITY_SHORTAGE, CAVITY_WIDTH-recess*2, CAVITY_HEIGHT + PIPE_MARGIN], true, 10, true);
        
            translate([-PIPE_DIAMETER_INNER/8 + CAVITY_SPHERE_SHIFT_TUNING, 0, -PIPE_DIAMETER_INNER/4])
            sphere(d=PIPE_DIAMETER_INNER + CAVITY_SPHERE_RADIUS_TUNING);
        }
    }

    if (!recess) {
        // small chamber mark
        translate([0, 0, PIPE_MARGIN/2])
        trapezoid([PIPE_DIAMETER_OUTER, CABLE_GROVE_WIDTH+MARK_THICKNESS*2-recess*2, PIPE_MARGIN], true);

        // big chamber mark
        translate([-CAVITY_SHORTAGE/2, 0, PIPE_MARGIN/2])
        trapezoid([PIPE_DIAMETER_INNER-CAVITY_SHORTAGE, CAVITY_WIDTH+MARK_THICKNESS*2-recess*2, PIPE_MARGIN], true);
        
        // strut
        strut_height = WALL_THICKNESS;
        translate([0, 0, strut_height/2])
        cube([WALL_THICKNESS, PIPE_DIAMETER_INNER, strut_height], true); 
    }
}

module perpendicular_end_stop() {
    difference() {
        union() {
            // small chamber base
            translate([0, 0, -STOP_THICKNESS/2])
            cube([PIPE_DIAMETER_OUTER, CABLE_GROVE_WIDTH + MARK_THICKNESS*2, STOP_THICKNESS], true);

            // big chamber base
            translate([-CAVITY_SHORTAGE/2 -PIPE_THICKNESS/2, 0, -STOP_THICKNESS/2])
            cube([PIPE_DIAMETER_OUTER-PIPE_THICKNESS-CAVITY_SHORTAGE, CAVITY_WIDTH+MARK_THICKNESS*2, STOP_THICKNESS], true);
            
            // strut
            translate([0, 0, -STOP_THICKNESS/2])
            cube([WALL_THICKNESS, PIPE_DIAMETER_OUTER, STOP_THICKNESS], true); 
        }
        // groove
        translate([0, 0, -STOP_THICKNESS/2])
        cube([PIPE_DIAMETER_OUTER+ATOM, BASE_GROOVE_WIDTH, STOP_THICKNESS+ATOM], true);
    }

    // groove filler
    translate([WALL_THICKNESS+5, PIPE_DIAMETER_OUTER/2 +CAVITY_WIDTH/2 + 5 , -STOP_THICKNESS/2])
    //%translate([0, 0 , -STOP_THICKNESS/2 -STOP_THICKNESS ])
    {
        // grove filler
        translate([0, 0, STOP_THICKNESS])
        cube([PIPE_DIAMETER_OUTER+ATOM, BASE_GROOVE_WIDTH - TOLERANCE*1.5, STOP_THICKNESS+ATOM], true);

        // support (cross)
        cube([PIPE_DIAMETER_OUTER+ATOM, CABLE_GROVE_WIDTH + MARK_THICKNESS*2, STOP_THICKNESS+ATOM], true);
        cube([WALL_THICKNESS, PIPE_DIAMETER_OUTER * .8, STOP_THICKNESS], true); 
    }
}

module perpendicular_end(flat=false) {
    translate([0, 0, flat ? STOP_THICKNESS : 0])
    {
        intersection() {
            difference() {
                perpendicular_end_raw(0);
                translate([-WALL_THINNER_THICKNESS, 0, -WALL_THINNER_THICKNESS])
                perpendicular_end_raw(WALL_THINNER_THICKNESS);
            }
            barrel(PIPE_DIAMETER_INNER/2, 0, PIPE_HEIGHT);
        }
        perpendicular_end_stop();
    }
}

///////////////////////


PLATE_THICKNESS = 0.8;
PLATE_WIDTH = 44;
PLATE_HEIGHT = 17;
FONT_SIZE = 6;
FONT = "Arial:style=Bold";
FONT_THICKNESS = 0.4;
FONT_SPACING = 1.2;

module write(text, valign) {
    scale([0.8, 1, 1]) // make font narrow
    linear_extrude(height=FONT_THICKNESS)
    text(text, halign="center", valign=valign,
         size=FONT_SIZE, font=FONT, spacing=FONT_SPACING);
}

module fplate() {
// Tenons
for (i=[-1, 1])
    translate([i*LOGO_TENONS_DISTANCE/2, 0, PLATE_THICKNESS])
    cylinder(d=LOGO_TENONS_DIAMETER - TOLERANCE*8.1, h=LOGO_TENONS_HEIGHT);

K = 1.2;
scale([K, K, 1])
difference() {
    // Plate
    translate([0, 0, PLATE_THICKNESS/2 + ATOM])
    cube([PLATE_WIDTH, PLATE_HEIGHT, PLATE_THICKNESS], true);

    // Engraved texts
    translate([0.5, +1, 0]) write("FABLAB", valign="bottom");
    translate([0.5, -1, 0]) write("FRIBOURG", valign="top");
 }
 
if(0) translate([0, 12, 0])
 cylinder(d=1.5, h=0.4);
}

translate([120, 90, 0])
fplate();

///////////////////////

perpendicular_end();
//diagonal_end();
//%barrel(PIPE_DIAMETER_OUTER/2, PIPE_DIAMETER_INNER/2, PIPE_HEIGHT);

translate([150, 0, 0])
diagonal_end(flat=true);



///////////////////////

translate([170, 0, 0])
difference() {
    diagonal_end_rest(flat=true, with_hole=true);

    translate([WALL_THICKNESS, 0, WALL_THICKNESS])
    diagonal_end_rest(flat=true, with_hole=false);
}

