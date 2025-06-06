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
 *
 * - Textured backside for anti-slip and (debatable) fashion.
 */

use <hinge3.scad>

// Adjusts
HINGE_Z_SHIFT              =  9.8;
PARTITIONER_Y_TWEAK        =  1.7 -.5;
HINGE_Z_SHIFT_TWEAK        = -1.2;

// Consts
$fn  = 40 - 5;
ATOM =  0.01;

// Dimensions
WALL_THICKNESS             =   2.0 +.2;
CUTS_D                     =   5.0;

S22_WIDTH                  =  75.4  + 2.5      +0.15;
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
CAM_NB_LAYERS              = 5;
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

module partitionner(extra=0) {
    x_tweak =  .8;
    y_tweak = PARTITIONER_Y_TWEAK;
    chamfer = CUTS_D;
    minkowski() {
        intersection() {
            minkowski() {
                translate([0, THICKNESS/2, 0])
                translate([chamfer/2, chamfer/2, -LENGTH/2])
                translate([-WALL_THICKNESS + x_tweak,
                           -THICKNESS/2  + WALL_THICKNESS*.5*0 + y_tweak,
                           0])
                cube([WIDTH*1.5, THICKNESS*1.5, LENGTH*2]);
                sphere(d=chamfer, $fn=30);
            }
            case_full();
        }
        if (extra)
            cylinder(r=extra, h=1, center=true);
    }
}

HINGE_DX = -HINGE_K * .1;

module partitionner2() {
    translate([HINGE_DX*7, 0, 0])

    hull()
    for (z=[THICKNESS/2-3, LENGTH-THICKNESS/2+WALL_THICKNESS+1]) {
        for (x=[-.5, WIDTH+THICKNESS]) {
            translate([x-HINGE_DX, 0, z])
            rotate([90, 0, 0])
            cylinder(d=THICKNESS, h=THICKNESS*3, center=true);
        }
    }
}

/******************************************************************************/

module phone(extra_x=0, releaser=false) {
    minkowski() {
        translate([S22_THICKNESS/2, S22_THICKNESS/2, 0])
        cube([S22_WIDTH-S22_THICKNESS+extra_x, 0.00001, S22_LENGTH]);
        cylinder(d=S22_THICKNESS, 0.00001);
    }

    if (releaser) {
        phone_releaser();
    }
}

module phone_releaser() {
    h = THICKNESS*.67;
    hull() {
        translate([0, -THICKNESS/2, 0])
        cube([WIDTH, THICKNESS, h]);

        translate([WIDTH/2, -THICKNESS/2, WIDTH])
        cube([ATOM, THICKNESS, ATOM]);
    }

    hull() {
        translate([0, -THICKNESS/2, LENGTH-h])
        cube([WIDTH, THICKNESS, h]);

        translate([WIDTH/2, -THICKNESS/2, LENGTH-WIDTH])
        cube([ATOM, THICKNESS, ATOM]);
    }

    k = 1/4;
    translate([THICKNESS*k/2, -THICKNESS/2, 0])
    cube([WIDTH-THICKNESS*k, THICKNESS, LENGTH]);
}

/******************************************************************************/

//%translate([0, -THICKNESS/2, 0]) cam_cutoff();

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
    hull()
    for (z=[0, S22_CAM_HEIGHT]) {
        // rounded angles
        for (x=[0, S22_CAM_WIDTH+CAM_SHUTTER_EXTRA_WIDTH]) {
            translate([WIDTH-S22_CAM_OFFSET_X-x, THICKNESS, z + S22_CAM_POS_Z])
            rotate([-90, 0, 0]) cylinder(d=CUTS_D, h=THICKNESS*2, center=true);
        }

        // square angles
        x = S22_CAM_WIDTH+CAM_SHUTTER_EXTRA_WIDTH;
        translate([WIDTH-S22_CAM_OFFSET_X-x, THICKNESS, z + S22_CAM_POS_Z])
        cube(CUTS_D, center=true);
    }

    // gripper
    cam_gripper();

    // snappers
    x0 = WIDTH-S22_CAM_OFFSET_X;
    y = THICKNESS+WALL_THICKNESS;
    z = S22_CAM_POS_Z-CUTS_D/2;
    translate([x0, y, z])
    camera_flap_snapper(SPACING);
}


module camera_flap_snapper(extra=0) {
    CAM_FLAP_SNAPPER_R = WALL_THICKNESS/3;
    CAM_FLAP_SNAPPER_INSET = .35;
    dz = CAM_FLAP_SNAPPER_R -CAM_FLAP_SNAPPER_INSET;
    dx = WALL_THICKNESS*3;
    for (z=[dz, S22_CAM_HEIGHT+CUTS_D -dz]) {
        hull() {
            translate([-WALL_THICKNESS-dx, 0, z])
            sphere(r=CAM_FLAP_SNAPPER_R + extra);

            translate([-WALL_THICKNESS, 0, z])
            sphere(r=CAM_FLAP_SNAPPER_R + extra);
        }
    }
}

module camera_flap(only_axis=false) {
    x0 = WIDTH-S22_CAM_OFFSET_X;
    y = THICKNESS/2+WALL_THICKNESS;
    x = S22_CAM_WIDTH+CAM_SHUTTER_EXTRA_WIDTH;
    z = S22_CAM_POS_Z-CUTS_D/2;
    w = S22_CAM_WIDTH + CAM_SHUTTER_EXTRA_WIDTH - WALL_THICKNESS*5.5;

    translate([x0, y, z]) {
        difference() {
            union() {
                // hinge
                translate([-x, 0, 0])
                camera_hinge(nb_layers=CAM_NB_LAYERS, height=CAM_FLAP_HEIGHT,
                             thickness=WALL_THICKNESS*2, only_axis=only_axis);

                // door
                if (!only_axis) {
                    intersection() {
                        // make door
                        hull() {
                            translate([0, 0, CUTS_D/2])
                            rotate([-90, 0, 0])
                            cylinder(d=CUTS_D-SPACING*2, h=WALL_THICKNESS*2, center=true);

                            translate([0, 0, S22_CAM_HEIGHT + CUTS_D/2])
                            rotate([-90, 0, 0])
                            cylinder(d=CUTS_D-SPACING*2, h=WALL_THICKNESS*2, center=true);

                            translate([-w, 0, WALL_THICKNESS+SPACING])
                            cube(WALL_THICKNESS*2, center=true);

                            translate([-w, 0, S22_CAM_HEIGHT + WALL_THICKNESS*1.5-SPACING])
                            cube(WALL_THICKNESS*2, center=true);
                        }

                        // rounded bottom
                        hull() {
                            translate([-S22_CAM_WIDTH, 0, WALL_THICKNESS+SPACING])
                            rotate([0, 90, 0])
                            cylinder(r=WALL_THICKNESS, h=S22_CAM_WIDTH*2);

                            translate([-S22_CAM_WIDTH, -WALL_THICKNESS, WALL_THICKNESS+SPACING])
                            cube([S22_CAM_WIDTH*2, WALL_THICKNESS*2, S22_CAM_HEIGHT*2]);
                        }
                    }

                    // snappers
                    camera_flap_snapper();

                    // support for adhesion
                    th = .3;
                    w2 = w/2;
                    translate([-w2 -w/2-WALL_THICKNESS*2.5, -th/2, 0])
                    cube([w2, th, 1]);
                }
            }

            // hole for flash
            translate([CUTS_D/2 - CAM_FLASH_POS_X, 0, CAM_FLASH_POS_Z])
            rotate([90, 0, 0])
            cylinder(d=CAM_FLASH_D, h=WALL_THICKNESS*4, center=true);

            // hollowing for lenses
            w3 = w + CUTS_D;
            dx = CUTS_D/2 + .5;
            h = S22_CAM_HEIGHT + CUTS_D - SPACING*2 -2  -2;
            translate([0, -.5, 0])
            hull() {
                translate([-w3 + dx, -WALL_THICKNESS*2, SPACING+1 +1])
                cube([w3, WALL_THICKNESS*2, h]);

                translate([-w3 + dx, -WALL_THICKNESS*3, SPACING+1 +1])
                cube([w3, WALL_THICKNESS*2, h + WALL_THICKNESS/2.5]);
            }

            // hollowing for nail
            translate([-x0, -y-WALL_THICKNESS*4.25, -z])
            cam_gripper();

        }
    }
}

//!camera_flap();

/******************************************************************************/

module texturer() {
    translate([0, -THICKNESS/2, 0])
    intersection() {
        difference() {
            // lattice
            translate([0, 0, -3.5])
            union() {
                for (z=[-LENGTH*1.5:TEXTURE_STEP:LENGTH*1.2])
                    translate([0, 0, z])
                    rotate([0, -TEXTURE_ANGLE, 0])
                    translate([WIDTH, THICKNESS+WALL_THICKNESS*2, 0])
                    rotate([45, 0, 0])
                    cube([WIDTH*5, TEXTURE_WIDTH, TEXTURE_WIDTH], center=true);

                for (z=[-LENGTH*.2:TEXTURE_STEP:LENGTH*2.5])
                    translate([0, 0, z])
                    rotate([0, TEXTURE_ANGLE, 0])
                    translate([WIDTH, THICKNESS+WALL_THICKNESS*2, 0])
                    rotate([45, 0, 0])
                    cube([WIDTH*5, TEXTURE_WIDTH, TEXTURE_WIDTH], center=true);

            }
            // keep half of lattice thickness
            translate([-WIDTH/2, WALL_THICKNESS*2 - TEXTURE_DEPTH, -LENGTH/2])
            cube([WIDTH*2, THICKNESS, LENGTH*2]);

            // keep flap hinge axis
            translate([0, THICKNESS/2, 0])
            position_flap() flap_hinge(only_axis=true);

            // keep camera hinge axis
            translate([0, THICKNESS/2, 0])
            camera_flap(only_axis=true);

        }

        // keep within case
        case_full(thickness=WALL_THICKNESS+1);
    }
}

//!texturer();

/******************************************************************************/

module case_full_0(extra_x=0, thickness=WALL_THICKNESS) {
    minkowski() {
        phone(extra_x=extra_x);

        translate([0.4, 1.25, 0])
        scale([1.5+.5, 2.75, 2.5+.5])
        sphere(d=thickness);
    }
}

module case_full(, thickness=WALL_THICKNESS) {
    dx = -WALL_THICKNESS/2 - .4 +.2;

    intersection() {
        case_full_0(thickness=thickness);

        translate ([dx, -THICKNESS/2, -LENGTH/2])
        cube([WIDTH*2,
              THICKNESS*2,
              LENGTH*2]);
    }

    intersection() {
        translate ([dx, -WALL_THICKNESS, -WALL_THICKNESS*2])
        cube([THICKNESS,
              THICKNESS + WALL_THICKNESS*2,
              LENGTH + WALL_THICKNESS*4]);

        translate ([-WIDTH/2, 0, 0])
        case_full_0(thickness=thickness);
    }
}

module case1() {
    translate([0, -THICKNESS/2, 0])
    difference() {

        // case without lid
        intersection() {
            case_full();
            partitionner();
        }

        // hollow hull by phone
        phone(releaser=true);

        // bottom  hollowings
        minkowski() {
            extra = 20;
            translate([THICKNESS*.6-1, -WALL_THICKNESS*2, -LENGTH/2])
            cube([WIDTH-THICKNESS*1.25 -extra +1, THICKNESS, LENGTH]);
            sphere(d=CUTS_D, $fn=6*3);
        }

        // usb plug etching
        minkowski() {
            etch = 1;
            width = USB_PLUG_WIDTH - CUTS_D;
            translate([WIDTH/2 - width/2, -WALL_THICKNESS*2 + etch, -LENGTH/2])
            cube([width, THICKNESS, LENGTH]);
            sphere(d=CUTS_D, $fn=6*3);
        }

        // right buttons
        buttons_hollowing(POWER_BUTTON_POS, POWER_BUTTON_HEIGHT, POWER_BUTTON_OFFSET);

        // camera
        cam_cutoff();

        // flap
        flap_cut();
        translate([0, THICKNESS/2, 0])
        card_cavity();

        //%flap_cut();

        // top hole
        hull() {
            translate([S22_TOP_HOLE_POS-1, THICKNESS/2, LENGTH/2])
            cylinder(d=1.5, h=LENGTH);
            translate([S22_TOP_HOLE_POS+1, THICKNESS/2, LENGTH/2])
            cylinder(d=1.5, h=LENGTH);
        }

        // texture
        //if (!$preview) {
        //    texturer();
        //}
    }
}


module case() {
    difference() {
        case1();

 //       translate([0, -THICKNESS/2, 0])
 //       if (!$preview)
 //           texturer();
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

module lid0() {
    translate([0, -THICKNESS/2, 0]) {
        difference() {
            translate([0, -.07, 0])  // TWEAK
            translate([0, -LID_SPACING/2, 0])
            case_full();

            // hollow hull by phone
            phone();

            // keep face
            partitionner(LID_SPACING);

            // stripes for flap
            h_marg = 1;
            _h = get_hinge_height(nb_layers=FLAP_NB_LAYERS,
                                 layer_height=FLAP_LAYER_HEIGHT) + h_marg*2;
            h = LENGTH - FLAP_POS_Z -h_marg*2;

            d = 3;
            depth = 1.7;
            for (x=[10 + d*2 : d*2: WIDTH-10 -d*2])
                translate([-d/2+x,
                           -THICKNESS/2 +d/2 - WALL_THICKNESS + depth,
                            FLAP_POS_Z - h_marg])
                cube([d*1.25, d, h]);
        }
    }
}

module lid_hinge0(dx=HINGE_DX) {
    k = HINGE_K;
    hth = get_hinge_thickness();
    x_shift = -hth*.8 -.3;
    xtd = THICKNESS/2*-1;
    difference() {
        scale([k, k, 1])
        translate([dx, .1, HINGE_Z_SHIFT_TWEAK]) // TWEAK
        translate([0, -LID_SPACING, -WALL_THICKNESS -10])
        hinge(x_shift=x_shift, extent=xtd,
              nb_layers=HINGE_NB_LAYERS, layer_height=HINGE_LAYER_HEIGHT);

        lid_inner_carver();
    }
}

module lid_inner_carver() {
    translate([-.2, -LID_SPACING, 0])  // TWEAK?
    difference() {
        translate([0, -THICKNESS/2, -LENGTH/2])
        scale([1, 1, 2])
        partitionner();

        translate([-WIDTH/2, 0, -LENGTH/2])
        cube([WIDTH*2, THICKNESS, LENGTH*2]);
    }

    translate([0, -THICKNESS/2, 0]) {
        translate([0, -LID_SPACING, 0])
        translate([0, 0, -LENGTH/2])
        scale([1, 1, 2])
        phone();

        translate([0, 0, -LENGTH/2])
        scale([1, 1, 2])
        phone();
    }
}

module lid_hinge0_new(dx=HINGE_DX) {
    translate([0, 0, HINGE_Z_SHIFT])
    main_hinge();
}


module lid_hinge_partitioner() {
    union() {
        translate([0, -THICKNESS/2, 0])
        translate([-WIDTH/2, 0, 0]) case_full();

        translate([0, -THICKNESS/2 - LID_SPACING, 0])
        translate([-WIDTH/2, 0, 0]) case_full();
    }
}

module lid_hinge() {
    intersection() {
        lid_hinge0();

        lid_hinge_partitioner();
        partitionner2();
    }
}

module lid_hinge_new() {
    difference() {
        intersection() {
            lid_hinge0_new();
            lid_hinge_partitioner();
            partitionner2();
        }
        lid_inner_carver();
    }
}


force_render=true;

module lid_hinge_maybe_cached(no_cache=false) {
    difference() {
        if (no_cache || !$preview || force_render) {
            lid_hinge_new();
        }
        else {
            import("lid-hinge-exported.stl");
        }

        translate([0, -THICKNESS/2, 0])
        flap_cut();
    }
}

// To remake cache: uncomment, render and save as lid-hinge-exported.stl
//!lid_hinge_maybe_cached(true);

module lid1() {
    translate([0, -LID_SPACING, 0]) lid0();
}

module lid() {
    intersection() {
        union() {
            lid1();
            lid_hinge_maybe_cached();
        }
        partitionner2();
    }
}

/******************************************************************************/

module support() {
    // side fins
    thickness2 = .5 +.25 +.25;
    translate([0, 0, -WALL_THICKNESS/2]) {
        for (x=[16, 58]) {
            difference() {
                translate([x, -THICKNESS*.6, 0]) hull() {
                    translate([0, -WIDTH*.7, 0])
                    cube([thickness2, WIDTH*.7, thickness2]);
                    cube([thickness2, thickness2, WIDTH*1.25]);
                }

                translate([x-THICKNESS*2, -THICKNESS*4, WIDTH]) cube(THICKNESS*4);

                rotate([0, 90, 0]) cylinder(r=THICKNESS*3.125, h=WIDTH);

                translate([0, 0, WIDTH*.705]) rotate([0, 90, 0])
                cylinder(r=THICKNESS*2.05, h=WIDTH);
            }
        }

        thickness3 = .5;
        hull()
        for (x=[16, 58]) {
            difference() {
                translate([x, -THICKNESS*.6, 0]) hull() {
                    translate([0, -WIDTH*.7, 0])
                    cube([thickness3, thickness3, thickness3]);

                    translate([0, 0, WIDTH*1.25])
                    cube([thickness3, thickness3, thickness3]);
                }
                translate([x-THICKNESS*2, -THICKNESS*4, WIDTH]) cube(THICKNESS*4);
            }
        }
    }
}

module support() {
    d = WIDTH*.6-4;
    difference() {
        translate([WIDTH/2-1.75, 0, -.8])
        difference() {
            scale([1, 1.3, 1])
            cylinder(d=d, h=LENGTH*.6);

            scale([1, 1.32, 1])
            translate([0, 0, -ATOM])
            cylinder(d=d-1, h=LENGTH*.6+ATOM*2);
        }
        translate([0, -THICKNESS/2 - WALL_THICKNESS + 1.4, -2])
        cube([WIDTH*2, THICKNESS + WALL_THICKNESS*1.6, LENGTH]);

        translate([0, WALL_THICKNESS*.6+.1, LENGTH*.15])
        scale([1, 1, 2.03])
        rotate([0, 90, 0])
        cylinder(d=LENGTH*.2, h=WIDTH);

        translate([0, WALL_THICKNESS*.6+.1, LENGTH*.46])
        scale([1, 1, 1.45])
        rotate([0, 90, 0])
        cylinder(d=LENGTH*.2, h=WIDTH);
    }
}

/******************************************************************************/
FLAP_DIVIDER_Z = 61.5;


module flap_cavity(width) {
    d = TOOL_THICKNESS / sqrt(2) +.2;
    extra_th = 1;
    extra = 1.5;
    width2 = width + extra*2;

    difference() {
        union() {
            // lower parts
            translate([0, -ATOM -.20, 0])
            hull() {
                translate([d/2, -TOOL_RECESS, -1])
                rotate([0, 0, 45]) cube([d, d, TOOL_LENGTH+1]);

                translate([-d/4, TOOL_THICKNESS/2, -1])
                cube([TOOL_THICKNESS, TOOL_THICKNESS/2, TOOL_LENGTH+1]);

                translate([width - d/2, -TOOL_RECESS, -1])
                rotate([0, 0, 45]) cube([d, d, TOOL_LENGTH+1]);

                translate([width-TOOL_THICKNESS + d/4, TOOL_THICKNESS/2, -1])
                cube([TOOL_THICKNESS, TOOL_THICKNESS/2, TOOL_LENGTH+1]);
            }

            // upper part
            difference() {
                translate([-extra, -1, FLAP_DIVIDER_Z - WALL_THICKNESS*2 -9])
                cube([width2, TOOL_THICKNESS+1, TOOL_LENGTH+1]);
            }
        }

        translate([0, 0, FLAP_HEIGHT-3.5*2 - WALL_THICKNESS*1.75])
        rotate([45, 0, 0])
        translate([-extra-ATOM, WALL_THICKNESS*2, 0])
        cube([width2+2*ATOM, FLAP_HEIGHT, FLAP_HEIGHT]);
    }
}

module card_cavity() {
    w = CARD_WIDTH + 5*0;
    translate([WIDTH - w - THICKNESS/2, CARD_THICKNESS, FLAP_POS_Z])
    cube([w, THICKNESS/2, CARD_HEIGHT]);
}

module position_flap() {
    y = FLAP_POS_Y;
    z = FLAP_POS_Z;
    dx = FLAP_POS_X;

    translate([dx, y, z])
    children();
}

module flap_hinge(only_axis=false) {
    flap_hinge0(flap_height=FLAP_HEIGHT +  SPACING/2, nb_layers=FLAP_NB_LAYERS,
                thickness = WALL_THICKNESS*2, only_axis=only_axis);
}

module flap0() {
    y = FLAP_POS_Y;
    z = FLAP_POS_Z;
    dx = FLAP_POS_X;

    position_flap() {
        // door
        difference() {
            union() {
                flap_hinge();

                translate([-WIDTH/2 -FLAP_X_ADJUST +.25, 0, 0])
                flap_door();
            }

            // tool cavity
            translate([-TOOL_WIDTH-6.5, -2 + TOOL_RECESS, 3.5]) {
                flap_cavity(TOOL_WIDTH);
            }

            // hinge limiter
            translate([5, -THICKNESS/2, -LENGTH/4])
            cube([WIDTH/2, THICKNESS, LENGTH]);
        }

        // pin for adhesion
        translate([0, 0, -1])
        cylinder(d=1.5, h=TOOL_LENGTH);

        // fin for adhesion
        th = .3;
        dx = WIDTH/2 - WALL_THICKNESS*1.5;
        translate([-dx, -th/2, -1]) cube([6, th, 2]);
    }
}

//!flap0();
module flap_divider() {
    // Spacing to cut flap in two
    d = WALL_THICKNESS*4;
    translate([-WALL_THICKNESS, FLAP_POS_Y + WALL_THICKNESS*.75 -.5, FLAP_DIVIDER_Z]) {
        difference() {
            translate([0, -d/2, -d/2])
            cube([FLAP_POS_X, d, d]);

            translate([0, 0, sqrt(d)*2])
            rotate([45, 0, 0])
            translate([-ATOM, -d/2, -d/2])
            cube([FLAP_POS_X+ATOM*2, d, d]);

            spacing = .3 * 3;

            translate([0, 0, -sqrt(d)*2 - spacing])
            rotate([45, 0, 0])
            translate([-ATOM, -d/2, -d/2])
            cube([FLAP_POS_X+ATOM*2, d, d*2]);

            // thin rest
            if (0)
            translate([0, -.1, -2])
            cube([FLAP_POS_X+ATOM*2, .1, 4]);
        }
    }
}

module flap() {
    intersection() {
        difference() {
            flap0();
            card_cavity();
            flap_divider();
        }

        translate([0, -THICKNESS/2, 0]) partitionner();
        
    }
}

//!flap();

module flap_cut0(with_groove=true) {
    y = THICKNESS/2*2 + get_hinge_thickness()/2;
    extra_w = WALL_THICKNESS;

    h = FLAP_LAYER_HEIGHT*FLAP_NB_LAYERS*2; // -SPACING/2;
    translate([FLAP_X_ADJUST*2, -WALL_THICKNESS*2.25, 0]) {
        difference() {
            cube([WIDTH/2+extra_w, WALL_THICKNESS*6, h]);
            w = WALL_THICKNESS*2;
            translate([-w*.03, w/2.6, -h])
            scale([.3, 1, 1])
            rotate([0, 0, 45])
            cube([w, w, h*3]);
        }

        if (with_groove) {
            //translate([WALL_THICKNESS*3 +10, WALL_THICKNESS*2+.3 -.5, 0])
            //groove(0, FLAP_LAYER_HEIGHT, FLAP_NB_LAYERS);

            translate([-WIDTH/4, WALL_THICKNESS*2+.3, 0])
            cube([WIDTH/2+extra_w, WALL_THICKNESS, h]);
        }
   }
}

module groove(extent, layer_height, nb_layers) {
    ztop = layer_height*2*nb_layers - THICKNESS/2;
    zside = extent+THICKNESS/2;
    up = ztop-THICKNESS/2*0 - ztop/3;
    down = THICKNESS/2 + ztop/3;
    hull() {
        translate([-zside -THICKNESS*.9, THICKNESS/2.5, up])
        sphere(d=THICKNESS*.7);

        translate([-zside -THICKNESS*.9, THICKNESS/2.5, down])
        sphere(d=THICKNESS*.7);


        translate([-zside -THICKNESS*1.5, THICKNESS/2.5, up])
        sphere(d=THICKNESS*.7);

        translate([-zside -THICKNESS*1.5, THICKNESS/2.5, down])
        sphere(d=THICKNESS*.7);
    }
}

module flap_cut() {
    y = THICKNESS/2*2 + get_hinge_thickness()/2;
    z = FLAP_POS_Z;
    extra_w = WALL_THICKNESS*3;

    translate([0, WALL_THICKNESS*4 +WALL_THICKNESS*2.25, z])
    flap_cut0();
}

module flap_cut_old() {
    y = THICKNESS/2*2 + get_hinge_thickness()/2;
    z = FLAP_POS_Z;
    extra_w = WALL_THICKNESS*3;

    /*
    if (0) %translate([WIDTH/2 + FLAP_X_ADJUST, y-.1, z])
    hinge2_cutout(extent=WIDTH/2 + FLAP_EXTEND_ADJUST,
                  layer_height=FLAP_LAYER_HEIGHT,
                  nb_layers=FLAP_NB_LAYERS);
    */

    h = FLAP_LAYER_HEIGHT*FLAP_NB_LAYERS*2;
    translate([FLAP_X_ADJUST*2, WALL_THICKNESS*4, z]) {
        difference() {
            cube([WIDTH/2+extra_w, WALL_THICKNESS*6, h]);
            w = WALL_THICKNESS*2;
            translate([-w*.03, w/2.6, -h])
            scale([.3, 1, 1])
            rotate([0, 0, 45])
            cube([w, w, h*3]);
        }

        translate([WALL_THICKNESS*3, WALL_THICKNESS*2+.3, 0])
        groove(0, FLAP_LAYER_HEIGHT, FLAP_NB_LAYERS);
   }
}


module flap_door() {
    intersection() {
        translate([SPACING, 0, 0]) flap_cut0(with_groove=false);

        union() {
            w = WIDTH/2 - WALL_THICKNESS*1.5 +.1;
            d = WALL_THICKNESS*2;

            translate([0, 0, d/2 + SPACING/2])
            rotate([0, 90, 0])
            cylinder(d=d, h= w);

            translate([0, -WALL_THICKNESS, SPACING + d/2])
            cube([w, d, FLAP_HEIGHT-SPACING*2 - d/2 - SPACING/2]);
        }
    }
}

//!flap_door();

/******************************************************************************/

module all_back() {
    intersection() {
        case();
        partitionner2();
    }
}

module all_back_flap() {
    difference() {
        union() {
            all_back();
            flap();
            camera_flap();
        }

        if (!$preview)
        texturer();
    }
}

module camera_flap_texture() {
    difference() {
        camera_flap();
        texturer();
    }
}

module all() {
        all_back_flap();
        lid();
        translate([0, 0, -THICKNESS/6 -.3]) support();
}

module all_cutoff() {
    intersection() {
        all();

        if ($preview && PREVIEW_CUTS)
            translate([LENGTH/4, -LENGTH, 4.75]) //LENGTH*1.25 - LENGTH*2 + 3])
            cube([LENGTH, LENGTH*2, LENGTH]);
    }
}

/******************************************************************************/

module upper_cut() {
    difference() {
        children();

        translate([0, 0, LENGTH*.7])
        cylinder(r=WIDTH*2, h=LENGTH);
    }
}


module upper_slice() {
    intersection() {
        children();

        translate([3, 5, LENGTH*.64])
        cube([WIDTH-6, WIDTH, LENGTH*.35]);
//        cylinder(r=WIDTH*2, h=LENGTH*.35);
    }
}

/******************************************************************************/

//%partitionner2();
//texturer();

//%translate([0, -THICKNESS/2, 0]) cam_cutoff();

//case_full(); // GOOD

intersection() {

//lid1();
//lid(); // GOOD
//lid_hinge_maybe_cached(true);  // GOOD
//lid_hinge(); // GOOD
//upper_slice() all_back();

//flap(); // GOOD
//%flap_cut0();
//camera_flap();

//all_back();  // GOOD
//all_back_flap(); // GOOD
//all_back_flap(); lid();

//camera_flap_texture();

    all();
    cylinder(r=1000, h=30);
}