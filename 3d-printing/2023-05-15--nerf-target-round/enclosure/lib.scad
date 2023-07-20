/* Case for an Adafruit Feather 328p with Featherwing OLED 128x64.
*/

H_EXCESS = 2.3;
H_EXTRA = 2;
INNER_WIDTH = 23.5;
INNER_LENGTH = 51.5;
INNER_HEIGHT = 12 + H_EXCESS + H_EXTRA;

OLED_LENGTH = 34 -2;
OLED_WIDTH = 18 -1.4;
OLED_X_OFFSET = -1;

WALL_H_THICKNESS = 1;
WALL_V_THICKNESS = 1;
WALL_H_THICKNESS2 = 2;

PLUG_WIDTH = 9;
PLUG_HEIGHT = 4.5;
PLUG_OFFSET = 1 + H_EXCESS + H_EXTRA -.5;

WHEEL_R = INNER_HEIGHT + WALL_V_THICKNESS*2 +5;
WHEEL_PROTUDE = 1;

SCREEN_THICKNESS = 1.1;
SCREEN_PILLAR_SIZE_X = 3.2 - 1;
SCREEN_PILLAR_SIZE_Y = 3.2;
SCREEN_PILLAR_THICKNESS = SCREEN_THICKNESS + 1.3 -.7;

PCB_THICKNESS = 1.9;

INNER_FRAME_THICKNESS = 0.3 +.5 +.15;
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

MAGNET_DIAMETER = 12.7 -.2;
MAGNET_HEIGHT = 5 +.1 +.5;
BASE_BOTTOM_THICKNESS = 1;

LIP_H = 1;
LIP_TH = .2;

$fn = $preview ? 8 : 20*3;

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
    k = .90;
    w = BUTTON_WIDTH * k;
    spacey = BUTTON_WIDTH * (1-k);
    spacex = 2.25; //spacey+1;

    for (y=[-BUTTON_WIDTH-PLAY, 0, BUTTON_WIDTH+PLAY]) {
        translate([a, y-w/2, INNER_HEIGHT/2 - ATOM]) {
            // plates
            cube([b-spacex, w, WALL_V_THICKNESS]);

            // balls
            translate([b-spacex -w, 0, WALL_V_THICKNESS])
            cube([w, w, WALL_V_THICKNESS]);
if(0)
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

module blockers() {
    width = SCREEN_PILLAR_SIZE_X * 3;
    thickness = .7-.2;
    for (x=[-INNER_LENGTH/2 + width/2, INNER_LENGTH/2 - width/2]) {
        for (p=[[-INNER_WIDTH/2+thickness/2, -1], [INNER_WIDTH/2-thickness/2, 1]]) {
            y = p[0]; k = p[1];
            translate([x, y, INNER_HEIGHT/2 - SCREEN_PILLAR_THICKNESS - PCB_THICKNESS])
            rotate([6*k, 0, 0])
            translate([-width/2, -thickness/2, -INNER_HEIGHT/2])
            cube([width, thickness, INNER_HEIGHT/2]);
        }
    }
}

module case() {
    difference() {
        case_0();
        button_cuts();
    }
    buttons();
    blockers();
    
    for (x=[-INNER_WIDTH/2, INNER_WIDTH/2]) {
        translate([0, x, -INNER_HEIGHT/2 -H_EXTRA/2 + LIP_H/2*1.3])
        rotate([0, 90, 0])
        resize([LIP_H*1.3, LIP_TH*2, INNER_LENGTH])
        cylinder(d=1, h=1, center=true);
    }
}

module base() {
    difference() {
        h = 2; // INNER_HEIGHT
        union() {
            // base
            hull() for (a=[0:4:40]) {
                translate([0, -INNER_WIDTH/2, 0])
                rotate([a, 0, 0]) {
                    l = INNER_LENGTH; // + WALL_H_THICKNESS*2;
                    w = INNER_WIDTH; // + WALL_H_THICKNESS*2;
                    translate([-l/2, WALL_H_THICKNESS+PLAY/2, -h + BASE_BOTTOM_THICKNESS])
                    minkowski() {
                        cube([l, w, h]);
                        cylinder(r=WALL_H_THICKNESS, h=ATOM);
                    }
                }
            }
            // inset
            translate([0, -INNER_WIDTH/2, 0])
            rotate([40, 0, 0]) {
                l = INNER_LENGTH - PLAY;
                w = INNER_WIDTH - PLAY;
                dh = LIP_H + PLAY;
                dw = LIP_TH + PLAY;
                chamfer = .7;
                hull() {
                    hh = h+H_EXCESS - dh -dh;
                    translate([-l/2, WALL_H_THICKNESS+PLAY, BASE_BOTTOM_THICKNESS + dh])
                    cube([l, w, hh]);

                    translate([-l/2, WALL_H_THICKNESS+PLAY+dw, BASE_BOTTOM_THICKNESS+dh-chamfer])
                    cube([l, w-dw*2, chamfer]);

                    translate([-l/2, WALL_H_THICKNESS+PLAY+dw*2, BASE_BOTTOM_THICKNESS+dh+chamfer + hh])
                    cube([l, w-dw*4, chamfer]);
                }
                translate([-l/2, WALL_H_THICKNESS+PLAY+dw, BASE_BOTTOM_THICKNESS])
                cube([l, w-dw*2, h+H_EXCESS-dh]);

            }
        }

        // limit to ground
        translate([-INNER_LENGTH, -INNER_WIDTH, -INNER_HEIGHT])
        cube([INNER_LENGTH*2, INNER_WIDTH*2, INNER_HEIGHT]);

        // battery compartment
        translate([0, INNER_WIDTH/2 - MAGNET_DIAMETER/2, -ATOM*2]) {
            cylinder(d=MAGNET_DIAMETER+PLAY, h=MAGNET_HEIGHT+ATOM);

            translate([0, 0, MAGNET_HEIGHT])
            intersection() {
                rotate([40, 0, 0])
                translate([0, 0, -INNER_HEIGHT])
                cylinder(d=MAGNET_DIAMETER * .4, h=INNER_HEIGHT*2);
                cylinder(d=MAGNET_DIAMETER*3, h=INNER_HEIGHT);
            }
            
            for (i=[1:3]) {
                rotate([0, 0, 60*i])
                translate([0, 0, MAGNET_HEIGHT/2])
                cube([MAGNET_DIAMETER + 1.5, MAGNET_DIAMETER/3, MAGNET_HEIGHT], center=true);
            }
        }

        // bottom
        nx = 13;
        ny = 6;
        dx = INNER_LENGTH / nx;
        dy = INNER_WIDTH / ny;
        echo(dx, dy);
        th = .5;
        difference() {
            for (y=[-INNER_WIDTH/2+1:dy:INNER_WIDTH/2-dy+1])  {
                for (x=[-INNER_LENGTH/2:dx:INNER_LENGTH/2-dx/2])  {
                    translate([x+th/2, y+th/2, -ATOM])
                    cube([dx-th, dy-th, .4]);
                }
            }

            translate([0, INNER_WIDTH/2 - MAGNET_DIAMETER/2, -ATOM*2])
            cylinder(d=MAGNET_DIAMETER+3.5, h=MAGNET_HEIGHT*2, center=true);    
        }
    }
    
}

//translate([0, 0, INNER_HEIGHT/2+WALL_V_THICKNESS]) rotate([180, 0, 0])
translate([0, 0, INNER_HEIGHT/2 +WALL_V_THICKNESS])
case();

translate([0, INNER_WIDTH*1.25+3, 0])
base();