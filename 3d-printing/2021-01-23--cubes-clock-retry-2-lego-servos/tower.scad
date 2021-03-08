include <definitions.scad>

use <servos_123.scad>
use <servos_123_cavities.scad>

/*
TODO:
- sign markers on cube faces
- base, fixed to bottom supprt, with cavities for cables and arduino
*/

module support_bottom() {
    height = CUBE_HEIGHT / 2 + CUBE_RAISE -SERVO_TAB_BOTTOM_TO_HORN_HEIGHT;
    echo("support_bottom height", height);
    difference() {
        union() {
            translate([0, 0, -CUBE_RAISE]) 
            cylinder(d=SUPPORT_DIAMETER, h=height);
            
            translate([0, 0, -CUBE_RAISE]) 
            cylinder(d=CUBE_WIDTH - PLAY, h=CUBE_RAISE);
        }

        servos_cavities();
    }
}

module adhesion() {
    // ribbed bottom surface for moderate adhesion
    rotate([0, 0, 45])
    difference() {
        cylinder(d=SUPPORT_DIAMETER-2, h=.3);
        for (i=[-CUBE_WIDTH/2:1:CUBE_WIDTH/2]) {
            translate([-CUBE_WIDTH/2, i, -CUBE_HEIGHT/2])
            cube([CUBE_WIDTH, 0.5, CUBE_HEIGHT]);
        }
    }
}

module support_mid() {
    height = CUBE_HEIGHT/2 - SERVO_TAB_BOTTOM_TO_HORN_HEIGHT;
    
    difference() {
        union() {
            translate([0, 0, CUBE_HEIGHT-height])
            cylinder(d=SUPPORT_DIAMETER, h=height);
            translate([0, 0, CUBE_HEIGHT])
            cylinder(d=SUPPORT_DIAMETER,
                     h=CUBE_HEIGHT-SERVO_TAB_BOTTOM_TO_HORN_HEIGHT
                       -SERVO_TOP_TO_CUBE_MARGIN);
        }
        servos_cavities();
        servos_cavities();
    }
}

module cube_lower() {
    difference() {
        cube_any(0, ceiling_thickness=0);
        servos_cavities();
    }
}

module cube_upper() {
    horn_heigh = SERVO_TOTAL_HEIGHT - SERVO_BODY_HEIGHT;
    cube_any(CUBE_HEIGHT, ceiling_thickness=horn_heigh/2);
}

module cube_walls(altitude, inner_width, inner_height) {
    difference() {
        translate([-CUBE_WIDTH/2+CHAMFER, -CUBE_WIDTH/2+CHAMFER, altitude+CHAMFER])
        minkowski() {
            cube([CUBE_WIDTH-CHAMFER*2, CUBE_WIDTH-CHAMFER*2, CUBE_HEIGHT-CHAMFER*2]);
            if (!$preview)
                sphere(r=CHAMFER);
        }

        translate([-inner_width/2, -inner_width/2, altitude])
        cube([inner_width, inner_width, inner_height]);
    }
}

module cube_any(altitude, ceiling_thickness) {
    inner_width = CUBE_WIDTH - CUBE_WALL_THICKNESS*2;
    inner_height = CUBE_HEIGHT - CUBE_WALL_THICKNESS;

    // walls
    color("#eeeeee")
    cube_walls(altitude, inner_width, inner_height);
    
    // bottom chamfer
    thickness = 1;
    difference() {
        r1 = CUBE_WIDTH/2 - WALL_THICKNESS - (SPACING/2);
        r2 = CUBE_WIDTH/2 * sqrt(2) - WALL_THICKNESS;
        h  = (r2 - r1) * 1.5;

        translate([-inner_width/2, -inner_width/2, altitude])
        cube([inner_width, inner_width, h+thickness]);

        translate([0, 0, altitude+thickness])
        cylinder(r1=r1, r2=r2, h=h+ATOM);

        translate([0, 0, altitude-ATOM])
        cylinder(r1=r1, r2=r1, h=thickness+ATOM*2);
    }
    
    // top chamfer
    r1 = ceiling_thickness ? CUBE_WIDTH/2 - WALL_THICKNESS - (SPACING/2) : SERVO_BODY_WIDTH/2;
    r2 = CUBE_WIDTH/2 * sqrt(2) - WALL_THICKNESS;
    h  = ceiling_thickness ? (r2 - r1) * 1.5                             : (r2 - r1) * 1;
    translate([0, 0, altitude-h-WALL_THICKNESS-ceiling_thickness])
    difference() {

        translate([-inner_width/2, -inner_width/2, CUBE_HEIGHT])
        cube([inner_width, inner_width, h]);

        translate([0, 0, CUBE_HEIGHT])
        cylinder(r1=r2, r2=r1, h=h+ATOM);
    }

    // ceiling
    if (ceiling_thickness)
    difference() {
        translate([-CUBE_WIDTH/2+CHAMFER,
                   -CUBE_WIDTH/2+CHAMFER,
                   altitude + CUBE_HEIGHT - SERVO_TOP_TO_CUBE_MARGIN-ceiling_thickness-ATOM])
        cube([CUBE_WIDTH-CHAMFER*2, CUBE_WIDTH-CHAMFER*2,
              SERVO_TOP_TO_CUBE_MARGIN+ceiling_thickness]);
        translate([0,
                   0,
                   altitude + CUBE_HEIGHT - SERVO_TOP_TO_CUBE_MARGIN-ceiling_thickness-PLAY-ATOM*2])
        horn_cross(.3, ceiling_thickness+PLAY + ATOM*2);
    }
}

module horn_cross(play, h) {
    rotate([0, 0, 90])
    translate([-HORN_CROSS_WIDTH/2-play/2, -HORN_ARM_THICKNESS/2-play/2, 0])
    cube([HORN_CROSS_WIDTH+play, HORN_ARM_THICKNESS+play, h]);

    translate([-HORN_CROSS_WIDTH/2-play/2, -HORN_ARM_THICKNESS/2-play/2, 0])
    cube([HORN_CROSS_WIDTH+play, HORN_ARM_THICKNESS+play, h]);
}

//rotate([0, 0, -45]) 
intersection() {
    union() {
        support_bottom();
        support_mid();
        
        translate([0, 0, .2]) cube_lower();
        translate([0, 0, .4]) cube_upper();
        %
        servos();
    }

    if (true) {
        rotate([0, 0, 45*0]) 
        translate([-75, 0, -20]) cube(150);  // vertical cross-cut
        //translate([-75, -75, -75]) cube(150);  // vertical cross-cut
    }

}
