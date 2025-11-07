use <hinge3.scad>

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

ANGLE = 45 - 14*0;

$fn = 90*2;

ELEVATION =  BASE_MIN_THICKNESS + PIPE_DIAMETER_INNER/2 + PIPE_MARGIN - WALL_THICKNESS;

module barrel(outer_radius, inner_radius, height) {
    scale([1, 1, height])
    difference() {
        cylinder(r=outer_radius);
        if (inner_radius)
            translate([0, 0, -0.5]) scale([1, 1, 2])
            cylinder(r=inner_radius);
    }
}

////////////////////////////////////////////////////////////////////////////////

GRIP_HEIGHT = 20 + 4;
GRIP_PLATE_THICKNESS = 4;
GRIP_PLATE_SHIFT = -4;
GRIP_LEG_THICKNESS = 1.5;
GRIP_WALL_THICKNESS = 2*2;
GRIP_WEDGE = 2.5;


module diagonal_grip_stripes() {
    translate([0, 0, ELEVATION])
    rotate([0, ANGLE, 0]) {
        // bottom stripes
        th = GRIP_PLATE_THICKNESS;
        for (y=[0: th: PIPE_DIAMETER_INNER]) 
            translate([-PIPE_DIAMETER_INNER*1.5 + GRIP_PLATE_SHIFT -2,
                       th*.75 + y - PIPE_DIAMETER_INNER/2,
                       -REST_HEIGHT/2-th*.35])
            rotate([45, 0, 0])
            translate([-8, -th/2, -th/2])
            cube([PIPE_DIAMETER_INNER*2, th, th]);
    }
}


module diagonal_grip_plate() {
    translate([0, 0, ELEVATION])
    rotate([0, ANGLE, 0]) {
        difference() {
            w = 12;
            d = 1;
            translate([-PIPE_DIAMETER_INNER*1.5 + GRIP_PLATE_SHIFT -7.6,
                       -PIPE_DIAMETER_INNER/2,
                       -REST_HEIGHT/2])
            cube([PIPE_DIAMETER_INNER*2, PIPE_DIAMETER_INNER, GRIP_PLATE_THICKNESS]);

            // hinge 2
            x = -PIPE_DIAMETER_INNER * sin(ANGLE)*1.13;
            translate([x, -PLUG_GROVE_WIDTH/2, -10])
            cube([w, PLUG_GROVE_WIDTH, GRIP_HEIGHT*2]);

            // axis
            translate([x+w/2, 0, -REST_HEIGHT/2 + GRIP_PLATE_THICKNESS/2])
            rotate([90, 0, 0])
            cylinder(d=d, h=PIPE_DIAMETER_INNER, center=true);
        }

        dx = -7.5;
        // hinge
        translate([PIPE_DIAMETER_INNER/2 -1 + dx, 40.2 , -3 + .5])
        rotate([90, 0, 0])
        support_hinge(5);

        // rest
        x = PIPE_DIAMETER_INNER*.5 + GRIP_PLATE_SHIFT - GRIP_WALL_THICKNESS + dx;
        z = -REST_HEIGHT/2 + GRIP_PLATE_THICKNESS;
        difference() {
            union() {
                translate([x, -PIPE_DIAMETER_INNER/2, z])
                cube([GRIP_WALL_THICKNESS, PIPE_DIAMETER_INNER, GRIP_HEIGHT]);

                // lip
                translate([x, 0, z+GRIP_HEIGHT -GRIP_WALL_THICKNESS/2])
                hull() for (k=[-1,1])
                    translate([0, PIPE_DIAMETER_INNER*.27*k, 0])
                    sphere(r=2, $fn=30);
            }
            
            w = PLUG_GROVE_WIDTH+1;
            translate([x-15, -w/2, z])
            cube([30, w, GRIP_HEIGHT*2]);
        }

        // available space
        translate([-5, 0, 9.0])
        %cube([107, 50, 20], center=true);
    }   
}

module diagonal_grip_leg() {
    translate([0, 0, ELEVATION])
    rotate([0, ANGLE, 0]) {
        difference() {
            // cable grove
            cl = PIPE_DIAMETER_INNER* S2 + REST_HEIGHT*S2;
            cw = PLUG_GROVE_WIDTH + .2;
            ch = GRIP_LEG_THICKNESS;   
            w = PIPE_DIAMETER_INNER* S2 + REST_HEIGHT*S2 +6-GRIP_WALL_THICKNESS;
            l = PIPE_DIAMETER_INNER;
            h = GRIP_HEIGHT - GRIP_WEDGE;

            hull() {
                translate([-cl/2 - REST_LENGTH -5.7, -cw/2, -REST_HEIGHT/2])
                cube([cl, cw, ch*1.65 *2], !true);   

                translate([-cl/2 - REST_LENGTH -5.7 + 28, -cw/2, -REST_HEIGHT/2])
                cube([cl, cw, ch], !true);   
            }

            
            translate([-REST_LENGTH - WALL_THICKNESS*2.5, 0, -REST_HEIGHT/2-ATOM*5])
            translate([-w/2, -l/2, 0])
            cube([w, l, h]);
        }
    }
}

module diagonal_grip(flat=false) {
    sink = flat ? -ELEVATION + REST_HEIGHT / S2 : 0;
    rot = flat ? -ANGLE : 0;
    
    rotate([0, rot, 0])
    translate([0, 0, sink]) {
        //%barrel(PIPE_DIAMETER_INNER/2, 0, PIPE_HEIGHT);

        intersection() {
            difference() {
                diagonal_grip_plate();
                intersection() {
                    diagonal_grip_stripes();
                    barrel(PIPE_DIAMETER_INNER/2 - 2, 0, PIPE_HEIGHT);
                }
            }
            barrel(PIPE_DIAMETER_INNER/2, 0, PIPE_HEIGHT);
        }

        intersection() {
            diagonal_grip_leg();
//            barrel(PIPE_DIAMETER_INNER/2, 0, PIPE_HEIGHT);
        }


    }

}


///////////////////////
// rotating adaptor
diagonal_grip(true);
