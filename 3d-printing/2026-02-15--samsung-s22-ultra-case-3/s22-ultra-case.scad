/* Case for smartphone Samsung Galaxy S22 Ultra.
 *
 * Features:
 * - Frontside lid on long edge with double hinge allowing 180° rotation.
 *
 * - Backside flap that can:
 *    - contain a multitool,
 *    - give access to credit card storage
 *    - serves as easel in vertical orientation (one angle possible),
 *    - serve as easel in horizontal orientation (with grooves in the lid
 *      holding the chosen angle).
 *
 * - Backside camera shutter with double hinge and hole for the flash.
 */
 
use <hinge3.scad>
use <../chamferer.scad>

// Adjusts
HINGE_Z_SHIFT              =  9.8;
PARTITIONER_Y_TWEAK        =  1.7 -.5;
HINGE_Z_SHIFT_TWEAK        = -1.2;

// Consts
$fn  = $preview ? 10*0+35 : 35;
ATOM =  0.01;

// Dimensions
WALL_THICKNESS             =   2.0 +.2;
CUTS_D                     =   5.0;

S22_WIDTH                  =  75.4  + 2.5      +0.15     -.18;
S22_LENGTH                 = 164.45 + 1.2  -.4 -0.7;
S22_THICKNESS              =  10.0  + 0.5;

S22_CAM_POS_Z              = 107  +3           +1.5;
S22_CAM_HEIGHT             =  48  -2;
S22_CAM_WIDTH              =  28  -2           -1.0;
S22_CAM_OFFSET_X           =   9               +0.5;

S22_TOP_HOLE_POS           =  48;

WIDTH                      = S22_WIDTH;
LENGTH                     = S22_LENGTH;
THICKNESS                  = S22_THICKNESS;

USB_PLUG_WIDTH             =  15.0;

POWER_BUTTON_POS           = 107.0    -5.5 - 1.5;
POWER_BUTTON_HEIGHT        =  46           + 1;
POWER_BUTTON_OFFSET        =  -1.0;

SUPPORT_THICKNESS          =   0.45;
LID_SPACING                =   0.15;

PREVIEW_CUTS               = false;

HINGE_NB_LAYERS            = 9+4;
HINGE_LAYER_HEIGHT         = 9.9 *.8  *1.34  -1.52  +.036;

HINGE_THICKNESS_ORIG       = get_hinge_thickness();  // 3.975
HINGE_THICKNESS            =  4.5;
HINGE_K = HINGE_THICKNESS / HINGE_THICKNESS_ORIG;

CAM_SHUTTER_MARGIN         = 2;
CAM_SHUTTER_THICKNESS      = 0.4;
CAM_SHUTTER_EXTRA_WIDTH    = 2    +8 +1;
CAM_SHUTTER_POS_Y          = 1;

CAM_SHUTTER_WIDTH          = S22_CAM_WIDTH + CAM_SHUTTER_EXTRA_WIDTH;
CAM_SHUTTER_WIDTH_EXT      = CAM_SHUTTER_WIDTH + CAM_SHUTTER_MARGIN*2;
CAM_SHUTTER_HANDLE_D       = 3;
CAM_NB_LAYERS              = 5 +2;
CAM_FLAP_HEIGHT            = S22_CAM_HEIGHT + CUTS_D;

CAM_FLASH_POS_X            = 24 -1 ;
CAM_FLASH_POS_Z            = 34;
CAM_FLASH_D                =  6;

TEXTURE_STEP               = 10     -  2   *0;
TEXTURE_ANGLE              = 70     - 10   *0;
TEXTURE_DEPTH              =  0.45  -  0.2 *0;
TEXTURE_WIDTH              =  1.5   -  1   *0;

PLYER_THICKNESS            = 0.065;

FLAP_NB_LAYERS             = 8;
FLAP_X_ADJUST              = 1;
FLAP_EXTEND_ADJUST         = -7;
FLAP_LAYER_HEIGHT          = 7.25*6 / FLAP_NB_LAYERS;

FLAP_POS_Y                 = THICKNESS/2 + get_hinge_thickness()/2;
FLAP_POS_X                 = WIDTH/2 + FLAP_X_ADJUST;
FLAP_POS_Z                 = 10;

CARD_HEIGHT                = 87;
CARD_WIDTH                 = 55;
CARD_THICKNESS             =  0.4;

TOOL_WIDTH                 = 24.5 - .15;
TOOL_LENGTH                = 79.5 +1 + 3;
TOOL_THICKNESS             =  2.0    + CARD_THICKNESS;
TOOL_RECESS                =  0.35;
TOOL_LOCK                  =  0.2;

SPACING                    = 0.3;

FLAP_HEIGHT = FLAP_LAYER_HEIGHT * FLAP_NB_LAYERS * 2;

/******************************************************************************/

module phone(extra_x=0, edgy=false) {
    hull() {
        translate([S22_THICKNESS/2, S22_THICKNESS/2, 0])
        cylinder(d=S22_THICKNESS, h=S22_LENGTH);

        translate([S22_WIDTH-S22_THICKNESS/2, S22_THICKNESS/2, 0])
        cylinder(d=S22_THICKNESS, h=S22_LENGTH);
        
        if (edgy) {
            d = S22_THICKNESS/2;
            translate([S22_WIDTH-d/2, d/2, 0])
            cylinder(d=d, h=S22_LENGTH);

            translate([S22_WIDTH-d/2, S22_THICKNESS - d/2, 0])
            cylinder(d=d, h=S22_LENGTH);
        }
    }
}

/******************************************************************************/

module cam_gripper(z) {
    d = WALL_THICKNESS;
    z = S22_CAM_POS_Z + S22_CAM_HEIGHT/2;
    x = WIDTH-S22_CAM_OFFSET_X+d;
    dx = d/2;
    y = THICKNESS + WALL_THICKNESS*2;
    h = S22_CAM_HEIGHT / 2;
    hull() {
        translate([x, y, z + h/2]) sphere(r=d);
        translate([x, y, z - h/2]) sphere(r=d);

        translate([x+dx, y, z + h/2]) sphere(r=d);
        translate([x+dx, y, z - h/2]) sphere(r=d);
    }
}

module cam_cutoff() {
    extra_w = 3;

    hull()
    for (z=[0, S22_CAM_HEIGHT]) {
        // rounded angles
        for (x=[0, S22_CAM_WIDTH+CAM_SHUTTER_EXTRA_WIDTH]) {
            translate([WIDTH-S22_CAM_OFFSET_X-x, THICKNESS, z + S22_CAM_POS_Z])
            rotate([-90, 0, 0]) cylinder(d=CUTS_D, h=THICKNESS*2, center=true, $fn=35);
        }

        // square angles
        x = S22_CAM_WIDTH+CAM_SHUTTER_EXTRA_WIDTH + extra_w;
        translate([WIDTH-S22_CAM_OFFSET_X-x, THICKNESS*1.25, z + S22_CAM_POS_Z])
        cube(CUTS_D, center=true);
    }

    // gripper
    cam_gripper();

    // snappers
    x0 = WIDTH-S22_CAM_OFFSET_X;
    y = THICKNESS+WALL_THICKNESS -.5;
    z = S22_CAM_POS_Z-CUTS_D/2;
    translate([x0, y, z])
    camera_flap_snapper(SPACING);
}

module camera_flap_snapper(extra=0, ky=1, kz=1) {
    CAM_FLAP_SNAPPER_R = WALL_THICKNESS/3;
    CAM_FLAP_SNAPPER_INSET = .35;
    dz = CAM_FLAP_SNAPPER_R -CAM_FLAP_SNAPPER_INSET;
    dx = WALL_THICKNESS*3;

    for (z=[dz, S22_CAM_HEIGHT+CUTS_D -dz - CAM_FLAP_SNAPPER_R]) {
        hull() {
            for (i=[0, 1]) {
                translate([-WALL_THICKNESS-dx, 0, z+CAM_FLAP_SNAPPER_R*i])
                scale([1, ky, kz])
                sphere(r=CAM_FLAP_SNAPPER_R + extra);

                translate([-WALL_THICKNESS, 0, z+CAM_FLAP_SNAPPER_R*i])
                scale([1, ky, kz])
                sphere(r=CAM_FLAP_SNAPPER_R + extra);
            }
        }
    }
}

module camera_flap() {
    x0 = WIDTH-S22_CAM_OFFSET_X;
    y = THICKNESS/2+WALL_THICKNESS;
    x = S22_CAM_WIDTH+CAM_SHUTTER_EXTRA_WIDTH;
    z = S22_CAM_POS_Z-CUTS_D/2;
    w = S22_CAM_WIDTH + CAM_SHUTTER_EXTRA_WIDTH - WALL_THICKNESS*5.5;
    
    hth = 4;
    marg = .5;

    translate([x0, y, z]) {

        difference() {
            py = -WALL_THICKNESS*.5 + .9;
            px = 1;
            union() {
                intersection() {
                    // hinge
                    translate([-x -px, py, -marg])
                    camera_hinge(nb_layers=CAM_NB_LAYERS, height=CAM_FLAP_HEIGHT + marg*2,
                                 thickness=hth, extra_gap=hinge_extra_gap);

                    // hinge gap
                    union() {
                        translate([-WALL_THICKNESS*2-x-px, -WALL_THICKNESS, SPACING])
                        cube([S22_CAM_WIDTH*2, WALL_THICKNESS, S22_CAM_HEIGHT+WALL_THICKNESS*2-.1]);

                        translate([-x0, -.55, -z])
                        cube([S22_WIDTH, WALL_THICKNESS*2, S22_LENGTH]);
                    }
                }

                // door, inner slice
                translate([0, -.2, 0])
                hull() {
                    translate([0, 0, CUTS_D/2])
                    rotate([-90, 0, 0])
                    cylinder(d=CUTS_D-SPACING*2, h=hth, center=true, $fn=35);

                    translate([0, 0, S22_CAM_HEIGHT + CUTS_D/2])
                    rotate([-90, 0, 0])
                    cylinder(d=CUTS_D-SPACING*2, h=hth, center=true, $fn=35);

                    translate([-w -.2, 0, hth+SPACING-hth/2])
                    cube(hth, center=true);

                    translate([-w -.2, 0, hth+SPACING-hth/2 + S22_CAM_HEIGHT+SPACING])
                    cube(hth, center=true);
                }
                
                // door, outer slice, left
                dh = .55;
                xd = marg*2 + SPACING*2;
                h = hth - WALL_THICKNESS + dh;
                translate([0, -.2 -dh, 0])
                hull() {

                    translate([0, .2, CUTS_D/2])
                    rotate([-90, 0, 0])
                    cylinder(d=CUTS_D-SPACING*2 + xd, h=h, center=false, $fn=35);

                    translate([0, .2, S22_CAM_HEIGHT + CUTS_D/2])
                    rotate([-90, 0, 0])
                    cylinder(d=CUTS_D-SPACING*2 + xd, h=h, center=false, $fn=35);

                    translate([-w -.2, WALL_THICKNESS, hth+SPACING-hth/2 - marg-SPACING])
                    translate([-hth/2, -hth/2, -hth/2])
                    cube([hth, h, hth], center=!true);

                    translate([-w -.2, WALL_THICKNESS, hth+SPACING-hth/2 + S22_CAM_HEIGHT + SPACING+marg*2-.1])
                    translate([-hth/2, -hth/2, -hth/2])
                    cube([hth, h, hth], center=!true);
                }

                // door, outer slice, right
                translate([0, -.2 -dh, 0])
                hull() {
                    translate([-x-hth*2, WALL_THICKNESS, hth+SPACING-hth/2 - marg-SPACING])
                    translate([-hth/2, -hth/2, -hth/2])
                    cube([hth, h, hth], center=!true);

                    translate([-x-hth*2, WALL_THICKNESS, hth+SPACING-hth/2 + S22_CAM_HEIGHT + SPACING+marg*2-.1])
                    translate([-hth/2, -hth/2, -hth/2])
                    cube([hth, h, hth], center=!true);

                    translate([-x0+S22_CAM_OFFSET_X, .2, CUTS_D/2])
                    rotate([-90, 0, 0])
                    cylinder(d=CUTS_D-SPACING*2 + xd, h=h, center=false, $fn=35);

                    translate([-x0+S22_CAM_OFFSET_X, .2, S22_CAM_HEIGHT + CUTS_D/2])
                    rotate([-90, 0, 0])
                    cylinder(d=CUTS_D-SPACING*2 + xd, h=h, center=false, $fn=35);
                }

                // snappers
                translate([0, -hth *.42, 0])
                camera_flap_snapper(ky=.75, kz=.85);
            }

            // hole for flash
            translate([CUTS_D/2 - CAM_FLASH_POS_X, 0, CAM_FLASH_POS_Z])
            rotate([90, 0, 0])
            cylinder(d=CAM_FLASH_D, h=WALL_THICKNESS*4, center=true);

            // hollowing for lenses
            w3 = w + CUTS_D -.5;
            dx = CUTS_D/2 + .5;
            h = S22_CAM_HEIGHT + CUTS_D - SPACING*2 -2  -2;

            translate([0, -.5, 0])
            translate([-w3 + dx -.7, -WALL_THICKNESS*3+.5 + hth-WALL_THICKNESS/2 , SPACING +1.5 -.5])
            cube([w3, WALL_THICKNESS*2, h + WALL_THICKNESS/2.5+1.1]);
        }
    }
}

/******************************************************************************/

module case_full_0(extra_x=0, thickness=WALL_THICKNESS) {
    minkowski() {
        phone(extra_x=extra_x, edgy=true);

        scale(1.5)
        sphere(d=thickness);
    }
}

module case_full(thickness=WALL_THICKNESS) {
    dx = -WALL_THICKNESS/2 - .4 +.2;

    // hull
    intersection() {
        case_full_0(thickness=thickness);

        translate ([dx, -THICKNESS/2, -LENGTH/2])
        cube([WIDTH*2,
              THICKNESS*2,
              LENGTH*2]);
    }
}

module buttons_hollowing(button_pos, button_height, button_y_offset) {
    minkowski() {
        translate([WIDTH-WIDTH/4,
                   THICKNESS/2 + button_y_offset + WALL_THICKNESS - THICKNESS,
                   button_pos-CUTS_D])
        cube([WIDTH/2, THICKNESS, button_height - CUTS_D]);
        sphere(d=CUTS_D/2, $fn=60);
    }

    minkowski() {
        translate([WIDTH+CUTS_D*1.5 + 1.6,
                   THICKNESS/2 + button_y_offset + WALL_THICKNESS/2  -1,
                   button_pos-CUTS_D])
        cube([WIDTH/2, .00001, button_height - CUTS_D]);

        scale([1, 1, .5])
        sphere(d=CUTS_D*3.5, $fn=60);
    }
}

/******************************************************************************/

th              =  4.60;

hinge_x         = -3.60;
hinge_py        =  0.65;
hinge_z         = 11.70;
hinge_y         = th*2 + hinge_py;
hinge_extra_gap = 0.03    +.1;

play            =  0.50;
pin_d           =  1.75;
pin_l           =  9 * 3.5;

module hinge_columns(xtra=0, dy=0, dz=0) {
    hull()
    for (z=[.1-dz, S22_LENGTH-.1+dz])
        for (y=[hinge_y + dy, hinge_py - dy])
            translate([0, y, z])
            sphere(d=th+xtra);
}

module hinge_axis_holes() {
    for (z=[-th/2, S22_LENGTH - pin_l + th/2])
        for (y=[hinge_y, hinge_py])
            translate([hinge_x, y, z])
            cylinder(d=pin_d, h=pin_l);
}

module phone_and_hinge(right=true, mid=true, left=true, case=true) {
    difference() {
        union() {
            // hinge
            translate([hinge_x, 0, 0])
            intersection() {
                translate([0, hinge_y, hinge_z])
                main_hinge(th=th, right=right, mid=mid, left=left, extra_gap=hinge_extra_gap);
                
                // case enveloppe
                translate([-th*2, 0, 0]) case_full();

                // hinge chamfering
                hull()
                for (x=[0, S22_WIDTH*1.5])
                    translate([x, 0, 0])
                        hinge_columns();
            }

            // case
            if (case)
            difference() {
                union() {
                    case_full();
                    translate([-th, 0, 0]) case_full();
                }
                translate([hinge_x, 0, 0])
                hinge_columns(xtra=1, dz=th*5, dy=th*2);
            }
        }

        // phone cavity
        phone();
        
        // axis pinholes
        hinge_axis_holes();
    }
}

module partitioner(play_y=0, play_x=0) {
    d = S22_THICKNESS*.75;
    h = S22_LENGTH*2;
    w = S22_WIDTH;
    mx = 1.25;
    my = 1.25;
    adjust_y = .5;
    
    // body
    hull()
    for (x=[d/2 - mx + play_x, w*2])
        for (y=[d/2 + my - play_y - adjust_y, S22_THICKNESS*2])
            translate([x, y, -h/4])
            cylinder(d=d, h=h);

    // to keep right hinge part
    translate([-w/2, my+S22_THICKNESS/2, -h/4])
    cube([w, S22_THICKNESS, h]);
}

module body_texturer() {
    difference() {
        hull() {
            for (y=[2, +.2])
                translate([0, y, 0])
                chamferer(6, "plate-y", shrink=!false, grow=false)
                intersection() {
                    body0(no_hinge=true);
                    translate([0, THICKNESS+WALL_THICKNESS-.4, 0])
                    cube([WIDTH*3, 1, LENGTH*3], center=true);
                }
        }
        step = 14;
        for (x=[0:step:LENGTH*1.5])
            translate([x, 0, 0])
            rotate([0, -45, 0])
            cube([step/sqrt(2) - 2, THICKNESS*4, LENGTH*4], center=true);
    }
}

module body_texturer() {
    difference() {
        chamferer(6, "plate-y", shrink=true, grow=false)
        rotate([-90, 0, 0])
        linear_extrude(height=1)
        projection(cut=true)
        translate([0, 0, -THICKNESS-WALL_THICKNESS/2])
        rotate([90, 0, 0])
        body0(no_hinge=true);

        step = 14;
        for (x=[0:step:LENGTH*1.5])
            translate([x, 0, 0])
            rotate([0, -45, 0])
            cube([step/sqrt(2) - 1.25, THICKNESS*4, LENGTH*4], center=true);
    }
}

module body0(no_hinge=false) {
    difference() {
        intersection() {
            phone_and_hinge(right=!no_hinge, mid=false, left=false, case=true);
            partitioner(play_x=play);
        }

        // chamfer
        m = .6;
        translate([m, -S22_THICKNESS/2, 0])
        cube([S22_WIDTH-m*2, S22_THICKNESS, S22_LENGTH]);
        
        // bottom clearance
        minkowski() {
            extra = 20;
            translate([THICKNESS*.6 - 1.5, -WALL_THICKNESS*2, -LENGTH/2])
            cube([WIDTH-THICKNESS*1.25 -extra +1, THICKNESS, LENGTH]);
            sphere(d=CUTS_D, $fn=6*3);
        }

        // usb plug etching
        minkowski() {
            etch = 1.5;
            width = USB_PLUG_WIDTH - CUTS_D;
            translate([WIDTH/2 - width/2, -WALL_THICKNESS*2 + etch, -LENGTH/2])
            cube([width, THICKNESS, LENGTH]);
            sphere(d=CUTS_D, $fn=6*3);
        }

        // buttons clearance
        translate([WIDTH/2, 0, 0])
        scale([.5, 1, 1])
        buttons_hollowing(POWER_BUTTON_POS, POWER_BUTTON_HEIGHT, POWER_BUTTON_OFFSET);
        
        // speaker clearance
        hull() {
            translate([S22_TOP_HOLE_POS-1, THICKNESS/2, LENGTH/2])
            cylinder(d=1.5, h=LENGTH);
            translate([S22_TOP_HOLE_POS+1, THICKNESS/2, LENGTH/2])
            cylinder(d=1.5, h=LENGTH);
        }

        // camera cutoff
        translate([0, -1.85, 0])
        cam_cutoff();
    }
}

module body(no_hinge=false) {
    difference() {
        body0(no_hinge=no_hinge);
        if (!$preview)
            translate([0, THICKNESS + WALL_THICKNESS/2 +.2, 0])
            body_texturer();
    }
}

module lid() {
    difference() {
        phone_and_hinge(right=false, mid=false, left=true, case=true);

        for(x=[-1.25, 1])
            translate([x, 0, 0])
            phone();

        partitioner(play_y=play);

        // stripes for flap
        h_marg = 1;
        _h = get_hinge_height(nb_layers=FLAP_NB_LAYERS,
                             layer_height=FLAP_LAYER_HEIGHT) + h_marg*2;
        h = LENGTH - FLAP_POS_Z -h_marg*2;
        d = 3;
        depth = 1.7 +.5;
        for (x=[10 + d*2 : d*2: WIDTH-10 -d*2])
            translate([-d/2+x,
                       -THICKNESS/2 +d/2 - WALL_THICKNESS + depth,
                        FLAP_POS_Z - h_marg])
            cube([d, d, h]);
    }
}

module mid() {
    phone_and_hinge(right=false, mid=true, left=false, case=false);
}

module pad(r) {
    cylinder(r=r+1.5, h=.2, $fn=20);
    cylinder(r1=r+1.5, r2=r-5, h=.6, $fn=20);
    difference() {
        cylinder(r=r-5, h=5, $fn=20);
        cylinder(r=r-5-.6, h=6, $fn=20);
    }
}

/******************************************************************************/

module pads() {
    // adhesion pads

    r = 15;
    r2 = r/sqrt(2);

    for(x=[-WIDTH-r*2+r2/2+.5, WIDTH+r-r2/2-2-.5])
    for(y=[-r+r2/2+.5, LENGTH++WALL_THICKNESS*2+r2/2-.5])
        translate([x, y, -THICKNESS-WALL_THICKNESS+.5])
        pad(r); //cylinder(r=r, h=.6, $fn=20);


    for(x=[-THICKNESS+2.2])
    for(y=[-r-1, LENGTH++WALL_THICKNESS*2+r2+1])
        translate([x, y, -THICKNESS-WALL_THICKNESS+.5])
        //scale([.5, 1, 1])
        pad(r); //cylinder(r=r, h=.6, $fn=20);
}

/******************************************************************************/

module rotate_at(x, y, a) {
    translate([x, y, 0])
    rotate([0, 0, a])
    translate([-x, -y, 0])
    children();
}

module flap() {
    translate([0, 5.25, 0])
    camera_flap();
    
    //if ($preview) %body(no_hinge=true);
}

module all_body() {
    body();

    a = -90;
    rotate_at(hinge_x, hinge_y, a) {
        mid();
        rotate_at(hinge_x, hinge_py, a) lid();
    }

    rotate([$preview ? 0 : 90, 0, 0])
    pads();
}

rotate([$preview ? 0 : -90, 0, 0])
intersection() {
    if (1) all_body();
    else flap();

    //if ($preview) translate([0, 0, 34]) cylinder(d=500, h=100, center=false);
    //if ($preview) rotate([0, 90, 0]) cylinder(d=500, h=63, center=false);
}
        