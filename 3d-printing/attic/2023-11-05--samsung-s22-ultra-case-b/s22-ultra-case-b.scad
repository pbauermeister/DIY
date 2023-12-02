// TODO: 
// - cam sliding shutter
// - shift hinges

// DONE:
// - strut: half cylinder
// - back: anti-slip pattern (X diagonals)
// - inner tubes to reinforce sides


use <hinge2.scad>
//use <hinge2_mini.scad>

WALL_THICKNESS      =   2.0;
CUTS_D              =   5.0;

S22_WIDTH           =  75.4  + 2.5      +0.15;
S22_LENGTH          = 164.45 + 1.2  -.4 -0.7;
S22_THICKNESS       =  10.0  + 0.5;

S22_CAM_POS_Z       = 107  +3           +1.5;
S22_CAM_HEIGHT      =  48  -2;
S22_CAM_WIDTH       =  28  -2           -1.0;
S22_CAM_OFFSET_X    =   9               +0.5;

S22_TOP_HOLE_POS    =  48;

WIDTH               = S22_WIDTH;
LENGTH              = S22_LENGTH;
THICKNESS           = S22_THICKNESS;

USB_PLUG_WIDTH      =  15.0;

POWER_BUTTON_POS    = 107.0    -5.5 - 1.5;
POWER_BUTTON_HEIGHT =  46           + 1;
POWER_BUTTON_OFFSET =  -1.0         ;

SUPPORT_THICKNESS   =   0.45;
LID_SPACING         =   0.15;

PREVIEW_CUTS               = false;

PARTITIONER_Y_TWEAK        = 1.7  -.5;

HINGE_Z_SHIFT_TWEAK        = -1.2;
HINGE_NB_LAYERS            = 9+4;
HINGE_LAYER_HEIGHT         = 9.9 *.8  *1.34  -1.52  +.036;

HINGE_THICKNESS_ORIG       = get_hinge_thickness();  // 3.975
HINGE_THICKNESS            =  4.5;
HINGE_K = HINGE_THICKNESS / HINGE_THICKNESS_ORIG;


CAM_SHUTTER_MARGIN         = 2;
CAM_SHUTTER_THICKNESS      = 0.4;
CAM_SHUTTER_EXTRA_WIDTH    = 2;
CAM_SHUTTER_POS_Y          = 1;

CAM_SHUTTER_WIDTH          = S22_CAM_WIDTH + CAM_SHUTTER_EXTRA_WIDTH;
CAM_SHUTTER_WIDTH_EXT      = CAM_SHUTTER_WIDTH + CAM_SHUTTER_MARGIN*2;
CAM_SHUTTER_HANDLE_D       = 3;

TEXTURE_STEP               = 10;
TEXTURE_ANGLE              = 70;
TEXTURE_DEPTH              = .85  -.2 -.2;
TEXTURE_WIDTH              = 1.5;

PLYER_THICKNESS            = 0.065;


FLAP_NB_LAYERS             = 8;
FLAP_Z_POS                 = 10;
FLAP_X_ADJUST              = 1;
FLAP_EXTEND_ADJUST         = -7;
FLAP_LAYER_HEIGHT          = 7.25*6/8;

TOOL_WIDTH                 = 24.5;
TOOL_LENGTH                = 79.5 +1  + FLAP_LAYER_HEIGHT*0;
TOOL_THICKNESS             =  2.0;
TOOL_RECESS                =  0.35;
TOOL_LOCK                  =  0.2;

SPACING                    = 0.3;

FLAP_HEIGHT = FLAP_LAYER_HEIGHT * FLAP_NB_LAYERS * 2;

$fn  = 40;
ATOM =  0.01;

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
                sphere(d=chamfer);
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

module cam_cutoff() {
    hull()
    for (z=[0, S22_CAM_HEIGHT]) {
        for (x=[0, S22_CAM_WIDTH+CAM_SHUTTER_EXTRA_WIDTH]) {
            translate([WIDTH-S22_CAM_OFFSET_X-x, THICKNESS, z + S22_CAM_POS_Z])
            rotate([-90, 0, 0]) cylinder(d=CUTS_D, h=THICKNESS*2, center=true);
        }

        x = S22_CAM_WIDTH+CAM_SHUTTER_EXTRA_WIDTH;
        translate([WIDTH-S22_CAM_OFFSET_X-x, THICKNESS, z + S22_CAM_POS_Z])
        cube(CUTS_D, center=true);
    }
}

module camera_flap() {
    x = S22_CAM_WIDTH+CAM_SHUTTER_EXTRA_WIDTH;
    z = S22_CAM_POS_Z-CUTS_D/2;

    nb_layers = 5;
    extent = 5;
    layer_height = (S22_CAM_HEIGHT + CUTS_D - SPACING*2) / (nb_layers*2);

    translate([WIDTH-S22_CAM_OFFSET_X-x, THICKNESS/2+WALL_THICKNESS, z+SPACING])
    union(){
        hinge2(extent=extent, x_shift=0,
               nb_layers=nb_layers, layer_height=layer_height,
               flat_bottom=true, slim=true, z_extent=SPACING);

        dx = get_hinge_thickness() * 2 + 1;
        translate([dx, 0, 0])
        rotate([0, 0, 180])
        hinge2(extent=extent, x_shift=0,
               nb_layers=nb_layers, layer_height=layer_height,
               flat_bottom=false, slim=true);
    }
}

//!camera_flap();


/******************************************************************************/

module texturer() {    
    intersection() {
        difference() {
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
            translate([-WIDTH/2, WALL_THICKNESS*2 - TEXTURE_DEPTH, -LENGTH/2])
            cube([WIDTH*2, THICKNESS, LENGTH*2]);
        }
        case_full(thickness=WALL_THICKNESS+1);

    }
}

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
        
        // top hole
        hull() {
            translate([S22_TOP_HOLE_POS-1, THICKNESS/2, LENGTH/2])
            cylinder(d=1.5, h=LENGTH);
            translate([S22_TOP_HOLE_POS+1, THICKNESS/2, LENGTH/2])
            cylinder(d=1.5, h=LENGTH);
        }

        // texture
        if (!$preview) {
            texturer();
        }
    }
}


module case() {
    difference() {
        case1();
 
        translate([0, -THICKNESS/2, 0])
        if (!$preview)
            texturer();
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
            h = get_hinge_height(nb_layers=FLAP_NB_LAYERS,
                                 layer_height=FLAP_LAYER_HEIGHT) + h_marg*2;
            d = 3;
            depth = 1.7;
            for (x=[10 + d*2 : d*2: WIDTH-10 -d*2])
                translate([-d/2+x,
                           -THICKNESS/2 +d/2 - WALL_THICKNESS + depth,
                            FLAP_Z_POS - h_marg])
                cube([d*1.25, d, h]);
        }
    }
}

module lid_hinge0(dx=HINGE_DX) {
    k = HINGE_K;
    hth = get_hinge_thickness();
    x_shift = -hth*.8 -.3;
    xtd = THICKNESS/2*-1;
    intersection() {
        difference() {
            scale([k, k, 1])
            translate([dx, .1, HINGE_Z_SHIFT_TWEAK]) // TWEAK
            translate([0, -LID_SPACING, -WALL_THICKNESS -10])
            hinge(x_shift=x_shift, extent=xtd,
                  nb_layers=HINGE_NB_LAYERS, layer_height=HINGE_LAYER_HEIGHT);

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
    }
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

force_render=true;

module lid_hinge_maybe_cached(no_cache=false) {
    difference() {
        if (no_cache || !$preview || force_render) {
            lid_hinge();
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

module lid() {
    intersection() {
        union() {
            translate([0, -LID_SPACING, 0]) lid0();
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

module flap_cavity(width) {
    hull() {
        d = TOOL_THICKNESS / sqrt(2);

        translate([d/2, -TOOL_RECESS, -1])
        rotate([0, 0, 45]) cube([d, d, TOOL_LENGTH+1]);

        translate([-d/4, TOOL_THICKNESS/2, -1])
        cube([TOOL_THICKNESS, TOOL_THICKNESS/2, TOOL_LENGTH+1]);

        translate([width - d/2, -TOOL_RECESS, -1])
        rotate([0, 0, 45]) cube([d, d, TOOL_LENGTH+1]);
        translate([width-TOOL_THICKNESS + d/4, TOOL_THICKNESS/2, -1])
        cube([TOOL_THICKNESS, TOOL_THICKNESS/2, TOOL_LENGTH+1]);
    }
}

CARD_HEIGHT = 87;
CARD_WIDTH  = 55;
CARD_THICKNESS  = 0.4;

module card_cavity() {
    w = CARD_WIDTH + 5*0;
    translate([WIDTH - w - THICKNESS/2, CARD_THICKNESS, FLAP_Z_POS])
    cube([w, THICKNESS/2, CARD_HEIGHT]);
}

module flap0() {
    y = THICKNESS/2 + get_hinge_thickness()/2;
    z = FLAP_Z_POS;
    dx = WIDTH/2 + FLAP_X_ADJUST;
    translate([dx, y, z]) {
        translate([-TOOL_WIDTH-6.5, -2 + TOOL_RECESS, 3.5])
        intersection() {
            flap_cavity(TOOL_WIDTH);
            //%translate([0, 0, -1]) cube([TOOL_WIDTH, TOOL_THICKNESS, TOOL_LENGTH]);
            
            l = TOOL_WIDTH/3.5;
            l2 = TOOL_WIDTH/1.5;
            l3 = TOOL_WIDTH/3;

            union() {
                translate([TOOL_WIDTH/2, 0, TOOL_LENGTH-sqrt(2)*.2])
                difference() {
                    rotate([-45, 0, 0]) cube([l2, TOOL_THICKNESS*4, 0.5], center=true);
                    cube([l3, TOOL_THICKNESS*4, TOOL_THICKNESS*3], center=true);
                }
                translate([TOOL_WIDTH/2, 0, TOOL_LENGTH -.1])
                difference() {
                    cube([l2, TOOL_THICKNESS*4, 0.2], center=true);
                    cube([l3, TOOL_THICKNESS*4, TOOL_THICKNESS*3], center=true);
                }
            }
        }
        difference() {
            hinge2(extent=WIDTH/2 + FLAP_EXTEND_ADJUST,
                   layer_height=FLAP_LAYER_HEIGHT,
                   nb_layers=FLAP_NB_LAYERS,
                   z_extent_2=1
            );

            translate([-TOOL_WIDTH-6.5, -2 + TOOL_RECESS, 3.5]) {
                flap_cavity(TOOL_WIDTH);
            }
 
            translate([5, -THICKNESS/2, -LENGTH/4])
            cube([WIDTH/2, THICKNESS, LENGTH]);

            // apply texture to flap door
            if(!$preview)
            intersection() {
                translate([-dx, -THICKNESS -get_hinge_thickness()/2, 0])
                texturer();
                
                translate([-WIDTH-WALL_THICKNESS*2, -THICKNESS/2, -z])
                cube([WIDTH, THICKNESS, LENGTH]);
            }
        }

        translate([0, 0, -1]) cylinder(d=1.5, h=TOOL_LENGTH); // pin, for adhesion
    }
}

//!flap0();

module flap() {
    difference() {
        flap0();
        card_cavity();
    }
}

module flap_cut() {
    y = THICKNESS/2*2 + get_hinge_thickness()/2;
    z = FLAP_Z_POS;

    translate([WIDTH/2 + FLAP_X_ADJUST, y-.1, z])
    hinge2_cutout(extent=WIDTH/2 + FLAP_EXTEND_ADJUST,
                  layer_height=FLAP_LAYER_HEIGHT,
                  nb_layers=FLAP_NB_LAYERS);
}

/******************************************************************************/

module all_back() {
    intersection() {
        case();
        partitionner2();
    }
}

module all_back_flap() {
    all_back();
    flap();
    
    camera_flap();
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

//upper_slice() all_back();

//flap(); // GOOD
//lid(); // GOOD
//case_full(); // GOOD
//lid_hinge_maybe_cached(true);  // GOOD
//all_back();  // GOOD
//all_back_flap(); // GOOD
//camera_flap();

//lid_hinge(); // GOOD

all_back_flap(); lid();
//all();
