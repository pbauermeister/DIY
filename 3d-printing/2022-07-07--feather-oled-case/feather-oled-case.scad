/* Case for an Adafruit Feather 328p with Featherwing OLED 128x64.
*/

INNER_WIDTH = 23.5;
INNER_LENGTH = 51.5;
INNER_HEIGHT = 12;

OLED_LENGTH = 34 -2;
OLED_WIDTH = 18 -1.4;
OLED_X_OFFSET = -1;

WALL_H_THICKNESS = 1;
WALL_V_THICKNESS = 1;
WALL_H_THICKNESS2 = 2;

PLUG_WIDTH = 9;
PLUG_HEIGHT = 4.5;
PLUG_OFFSET = 1;

WHEEL_R = INNER_HEIGHT + WALL_V_THICKNESS*2 +5;
WHEEL_PROTUDE = 1;

SCREEN_THICKNESS = 1.1;
SCREEN_PILLAR_SIZE_X = 3.2 - 1;
SCREEN_PILLAR_SIZE_Y = 3.2;
SCREEN_PILLAR_THICKNESS = SCREEN_THICKNESS + 1.3;

INNER_FRAME_THICKNESS = 0.3;
INNER_FRAME_BORDER = 1.3;

GUIDE_WIDTH = INNER_HEIGHT;
BUTTON_WIDTH = 5;
BUTTON_LENGTH = 10;
BUTTON_SHIFT = 1.3;

BUTTON_R_SHIFT = 1;
BUTTON_R_WIDTH = 3;
ATOM = 0.001;
PLAY = .35;
GUIDE_SLANT = -18;

$fn = 20*3;

module button_cuts() {
    a = OLED_LENGTH/2 + OLED_X_OFFSET + BUTTON_SHIFT;
    b = INNER_LENGTH/2 -a;
    translate([a, -OLED_WIDTH/2, INNER_HEIGHT/2 - ATOM])
    cube([b + WALL_H_THICKNESS, OLED_WIDTH, INNER_HEIGHT+1]);
    
    translate([a, -INNER_WIDTH/2 +ATOM, INNER_HEIGHT/2 - ATOM])
    cube([b-SCREEN_PILLAR_SIZE_X, (INNER_WIDTH-OLED_WIDTH)/2, INNER_HEIGHT+1]);
    
}

module buttons() {
    a = OLED_LENGTH/2 + OLED_X_OFFSET + BUTTON_SHIFT;
    b = INNER_LENGTH/2 -a ;
    k = .80;
    w = BUTTON_WIDTH * k;
    spacey = BUTTON_WIDTH * (1-k);
    spacex = 2.25; //spacey+1;

    for (y=[-BUTTON_WIDTH-PLAY, 0, BUTTON_WIDTH+PLAY]) {
        translate([a, y-w/2, INNER_HEIGHT/2 - ATOM]) {
            // plates
            cube([b-spacex, w, WALL_V_THICKNESS]);

            // balls
            translate([b/2 -.5, w/2, 1])
            scale([1.5, 1, .67])
            intersection() {
                sphere(1.5);
                cylinder(r=2, h=2);
            }
        }
    }

    ygap = .8;
    xgap = spacey + .3;
    translate([a+xgap, -INNER_WIDTH/2 +ygap, INNER_HEIGHT/2 - ATOM])
    cube([b-SCREEN_PILLAR_SIZE_X-xgap, (INNER_WIDTH-OLED_WIDTH)/2-ygap, WALL_V_THICKNESS]);

    // pseudo-support
    for (xx=[1.3: 1.3 :b-3]) {
        translate([a+xx, -INNER_WIDTH/2+.5, INNER_HEIGHT/2-.5 -.3])
        cube([.5, INNER_WIDTH-1, .5]);
    }
}

module cavity(v_recess=0) {
    translate([-INNER_LENGTH/2, -INNER_WIDTH/2, v_recess])
    cube([INNER_LENGTH, INNER_WIDTH, INNER_HEIGHT-v_recess*2]);
}

module oled_cut() {
    translate([-OLED_LENGTH/2 + OLED_X_OFFSET, -OLED_WIDTH/2, 0])
    cube([OLED_LENGTH, OLED_WIDTH, INNER_HEIGHT*2]);
}

module plug_cut() {
    translate([0, -PLUG_WIDTH/2, PLUG_OFFSET])
    cube([INNER_LENGTH, PLUG_WIDTH, PLUG_HEIGHT]);
}

module box() {
    minkowski() {
        cavity(v_recess=WALL_H_THICKNESS-WALL_V_THICKNESS);

        if (1)
        union() {
            sphere(r=WALL_H_THICKNESS);
            translate([0, 0, -WALL_H_THICKNESS])
            cylinder(r=WALL_H_THICKNESS, h=WALL_H_THICKNESS);
        }
        else cube(WALL_H_THICKNESS*2, center=true);
    }
}

module pillars() {
    for (x=[-INNER_LENGTH/2 + SCREEN_PILLAR_SIZE_X/2, INNER_LENGTH/2 - SCREEN_PILLAR_SIZE_X/2]) {
        for (y=[-INNER_WIDTH/2 + SCREEN_PILLAR_SIZE_Y/2, INNER_WIDTH/2 - SCREEN_PILLAR_SIZE_Y/2]) {
            translate([x, y, INNER_HEIGHT/2-SCREEN_PILLAR_THICKNESS])
            translate([-SCREEN_PILLAR_SIZE_X/2, -SCREEN_PILLAR_SIZE_Y/2, 0])
            cube([SCREEN_PILLAR_SIZE_X, SCREEN_PILLAR_SIZE_Y, SCREEN_PILLAR_THICKNESS]);
        }
    }
}

module inner_frame() {
    translate([-OLED_LENGTH/2 + OLED_X_OFFSET, -OLED_WIDTH/2, 0]) {
        difference() {
            translate([-INNER_FRAME_BORDER, -INNER_FRAME_BORDER, INNER_HEIGHT/2-INNER_FRAME_THICKNESS])
            cube([OLED_LENGTH+INNER_FRAME_BORDER*2, OLED_WIDTH+INNER_FRAME_BORDER*2, INNER_FRAME_THICKNESS]);
            cube([OLED_LENGTH, OLED_WIDTH, INNER_HEIGHT]);
        }
    }
}

module case_0() {
    translate([0, 0, -INNER_HEIGHT/2]) {
        difference() {
            box();
            cavity();
            oled_cut();
            plug_cut();

            translate([0, 0, -WALL_V_THICKNESS*2]) cavity();
        }
    }
    pillars();
    inner_frame();
}

module case() {
    difference() {
        case_0();
        button_cuts();
    }
    buttons();
}

module cap_side(left) {
    l2 = INNER_WIDTH + WALL_H_THICKNESS*2;
    w2 = WALL_H_THICKNESS2;
    h2 = INNER_HEIGHT + WALL_V_THICKNESS*2;
    translate([INNER_LENGTH/2 + WALL_H_THICKNESS, -l2/2, -h2/2])

    difference() {
        cube([w2, l2, h2]);
        translate([-ATOM, INNER_WIDTH/2+WALL_H_THICKNESS, WALL_V_THICKNESS]) 
        scale([2, 1, 1])
        minkowski() {
            guide();
            cube(PLAY, center=true);
        }
    }
    
    k = .3;
    translate([INNER_LENGTH/2 + WALL_H_THICKNESS *2 - (left? WALL_H_THICKNESS:0),
               -l2/2,
               h2*(.5-k)])
    cube([WALL_H_THICKNESS, l2, h2*k]);

}

module cap() {
    l = INNER_LENGTH + WALL_H_THICKNESS2*2 + WHEEL_PROTUDE*2 + PLAY*2;
    w = INNER_WIDTH + WALL_H_THICKNESS*2;
    h = WALL_V_THICKNESS;

    translate([-l/2, -w/2, INNER_HEIGHT/2+WALL_H_THICKNESS])
    cube([l, w, h]);
    
    translate([PLAY, 0, 0])
    cap_side(false);

    translate([-INNER_LENGTH -WALL_H_THICKNESS2*2 -PLAY, 0, 0])
    cap_side(true);
    
}

module combined() {
    difference() {
        union() {
            color("lightgrey") case();

            rotate([180, 0, 0])
    //        translate([0, -1.85, -6.2]) rotate([180-GUIDE_SLANT*2, 0, 180])
            color("white") 
            translate([0, 0, PLAY/2]) cap();
        }
        //if ($preview) translate([0, 0, -WALL_H_THICKNESS*2]) cube(INNER_WIDTH+INNER_HEIGHT);
    }
}

//combined();

//translate([0, 0, INNER_HEIGHT/2+WALL_V_THICKNESS]) rotate([180, 0, 0])
case();

if (0)
translate([0, INNER_WIDTH + WALL_H_THICKNESS + 2, 0])
translate([0, 0, INNER_HEIGHT/2+WALL_V_THICKNESS*2]) rotate([180, 0, 0]) cap();
