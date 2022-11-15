/*
 * TODO:
 * DONE:
 * - phone: thicker
 * - bottom-border: clearance for USB plug
 * - closed top border
 * - power button hole:
 *   - top ok, bottom higher
 *   - touch border
 * - shell: thicker
 * - camera hole: .5mm more vertical, 1mm less horiz
 * - hole supports
 */


use <hinge2.scad>
//use <hinge2_mini.scad>

//                              v2      v3
WALL_THICKNESS =   1.5  +.6 +   1       -1.5 +.4;
WIDTH          =  74.8  +.5             +.1;
LENGTH         = 163.0  +.5             +.5 -.25;
THICKNESS      =   8.7  +.5 +   .6      +.2;
CUTS_D         = 4+1;

USB_PLUG_WIDTH = 15;

POWER_BUTTON_POS = 107;
POWER_BUTTON_HEIGHT = 16;
POWER_BUTTON_OFFSET = -1;

SUPPORT_THICKNESS = 0.45;
LID_SPACING = .15;

PREVIEW_FORCE_RENDER_HINGE = !true;
SUPPRESS_HINGE = false;
PREVIEW_CUTS = false;

$fn = 40;

/******************************************************************************/

module partitionner(extra=0) {
    x_tweak = .6 + .2; //.4; //.5; //.6; //.8; //.75;
    y_tweak = .7 +1;    
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
            //cube(extra);
    }
}

module partitionner2() {
    // rounded boxing, to shave the hinge angles
    translate([0, -THICKNESS/2, 0])
    hull()
    for (i=[0,1]) {
        translate([i ? WIDTH*2 : -THICKNESS/2+2,0, 0])
        for (j=[0,1]) {
            translate([0, 0, j ? LENGTH-THICKNESS/2+.3 : 0])
            translate([THICKNESS/2 - 1.4 -2, 0, THICKNESS/2-WALL_THICKNESS -.6]) {
                translate([0, THICKNESS/2 -2, 0]) sphere(d=THICKNESS);
                translate([0, THICKNESS/2 + WALL_THICKNESS*2, 0]) sphere(d=THICKNESS);
                //rotate([90, 0, 0]) cylinder(d= THICKNESS, h=WIDTH*3, center=true);
            }
        }
    }
}

/******************************************************************************/

module phone() {
    minkowski() {
        translate([THICKNESS/2, THICKNESS/2, THICKNESS/2])
        cube([WIDTH-THICKNESS, 0.00001, LENGTH-THICKNESS]);

        sphere(d=THICKNESS);
    }
}

/******************************************************************************/

module case_full_0() {
    minkowski() {
        phone();

//        translate([0.4, 0, 0])
//        scale([1.5, 1, 2])
//        sphere(d=WALL_THICKNESS); 
        translate([0.4, 1.25, 0])
        scale([1.5, 2.75, 2.5])
        sphere(d=WALL_THICKNESS);        

    }
}

module case_full() {
    case_full_0();
    
    intersection() {
        translate ([-WALL_THICKNESS/2 - .4 +.2, -WALL_THICKNESS, -WALL_THICKNESS])
        cube([THICKNESS + WALL_THICKNESS*2,
              THICKNESS + WALL_THICKNESS*2,
              LENGTH + WALL_THICKNESS*2]);
        
        translate ([-WIDTH/2, 0, 0])
        case_full_0();
    }
}

module camera_hollowing() {
    minkowski() {
        CAMERA_WIDTH = 43;
        w = CAMERA_WIDTH - CUTS_D;
        h = 13.5 + 1.5;
        pos = 139.5;
        echo(CUTS_D/2);
        translate([WIDTH/2 - w/2, 0, pos -h/2])
        cube([w, THICKNESS*2, h - CUTS_D]);

        sphere(d=CUTS_D, $fn=60);
    }
}

module camera_hollowing2() {
    CAMERA_WIDTH = 43;
    w = CAMERA_WIDTH - CUTS_D;
    h = 13.5 + 1.5;
    pos = 139.5;
    /* This leads to error and is replaced by hull of 4 spheres
    minkowski() {
        echo(CUTS_D/2);
        translate([WIDTH/2 - w/2,
                   THICKNESS + CUTS_D*2.5/2 + 1, pos -h/2])
        cube([w, THICKNESS*2, h - CUTS_D]);

        sphere(d=CUTS_D*2.5, $fn=60);
    } */
    
    hull() {
        d = CUTS_D*2.5;
        translate([WIDTH/2 - w/2, THICKNESS + CUTS_D*2.5/2 + 1, pos -h/2]) sphere(d=d, $fn=60);
        translate([WIDTH/2 + w/2, THICKNESS + CUTS_D*2.5/2 + 1, pos -h/2]) sphere(d=d, $fn=60);
        translate([WIDTH/2 - w/2, THICKNESS + CUTS_D*2.5/2 + 1, pos +h-d]) sphere(d=d, $fn=60);
        translate([WIDTH/2 + w/2, THICKNESS + CUTS_D*2.5/2 + 1, pos +h-d]) sphere(d=d, $fn=60);
    }
}

module left_buttons_hollowing() {
    // new ones
    minkowski() {
        translate([CUTS_D*0-WALL_THICKNESS,
                  WALL_THICKNESS + .75,
                  91 + 3])
        cube([WIDTH/2, .00001, 45-6 + 22]);
        rotate([0, 90, 0]) cylinder(d=CUTS_D*2, h=1, $fn=60);
    }
}

module case() {
    translate([0, -THICKNESS/2, 0])
    difference() {

        // case without lid
        intersection() {
            case_full();
            partitionner();
        }

        // hollow hull by phone
        phone();

        // bottom  hollowings
        minkowski() {
            extra = 8;
            translate([THICKNESS*.75+extra, -WALL_THICKNESS*2, -LENGTH/2])
            cube([WIDTH-THICKNESS*1.5 -extra, THICKNESS, LENGTH]);
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

        // left buttons
        left_buttons_hollowing();

        // right buttons
        minkowski() {
            translate([WIDTH-WIDTH/4,
                       THICKNESS/2 + POWER_BUTTON_OFFSET + WALL_THICKNESS/2,
                       POWER_BUTTON_POS-CUTS_D])
            cube([WIDTH/2, .00001, POWER_BUTTON_HEIGHT - CUTS_D]);
            sphere(d=CUTS_D/2, $fn=60);
        }
        minkowski() {
            translate([WIDTH+CUTS_D*1.5,
                       THICKNESS/2 + POWER_BUTTON_OFFSET + WALL_THICKNESS/2,
                       POWER_BUTTON_POS-CUTS_D])
            cube([WIDTH/2, .00001, POWER_BUTTON_HEIGHT - CUTS_D]);
            sphere(d=CUTS_D*3, $fn=60);
        }

        // camera
        difference() {
            minkowski() {
                camera_hollowing();
                scale([1.9, 1, 1.5])
                cube(0.3, center=true);
            }
            camera_hollowing();
        }
        camera_hollowing2();
    }
}

/******************************************************************************/

module lid() {
    translate([0, -THICKNESS/2, 0]) {
        difference() {
            translate([0, -.07, 0])  // TWEAK
            translate([0, -LID_SPACING/2, 0])
            case_full();

            // hollow hull by phone
            phone();

            // keep face
            partitionner(LID_SPACING);

            // speaker
            w = 10;
            translate([WIDTH/2 - w/2, -THICKNESS/2, 156])
            cube([w, THICKNESS, 2.5]);
            
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
    
    {   // pillar to support case top edge overhang
        speaker_pos = 156;
        speaker_height = 2.5;
        pillar_width = 1.5;
        translate([WIDTH/2 - pillar_width/2, -WALL_THICKNESS -3.5-.58, speaker_pos])
        cube([pillar_width, WALL_THICKNESS/2, speaker_height]);
    }

}

HINGE_NB_LAYERS = 9+4;
HINGE_LAYER_HEIGHT = 9.9 *.8  *1.34;

module lid_hinge0() {
    hth = get_hinge_thickness();
    shift = -hth*.8 -.3;
    xtd = 3*3;
    intersection() {
        difference() {
            translate([0, .1, 0]) // TWEAK
            translate([0, -LID_SPACING, -WALL_THICKNESS -10])
            hinge(x_shift=shift, extent=xtd,
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

module lid_hinge() {
    intersection() {
        union() {
            translate([0, -THICKNESS/2, 0])
            translate([-WIDTH/2, 0, 0]) case_full();

            translate([0, -THICKNESS/2 - LID_SPACING*2, 0])
            translate([-WIDTH/2, 0, 0]) case_full();
        }

        lid_hinge0();
    }
}

module lid_hinge_maybe_cached() {
    if ($preview && !PREVIEW_FORCE_RENDER_HINGE) {
        // to re-generate this stl, go to lid-hinge-exported.scad, render and export
        import("lid-hinge-exported.stl");
    }
    else {
        lid_hinge();
    }
}

/******************************************************************************/

module support() {
    // anti-supports
    thickness = .15;
    translate([0, 0, -WALL_THICKNESS/2]) {

        // hinge
        translate([-5 -5.0 -1, -THICKNESS, 0])
        cube([5, THICKNESS*2, thickness]);
        
        translate([-10, -THICKNESS*.75 -.3, 0])
        translate([0, -1, 0])
        cube([10, 2, thickness]);

        translate([-10, +THICKNESS*.75 +.3, 0])
        translate([0, -1, 0])
        cube([10, 2, thickness]);

        // center
        translate([THICKNESS/2 *1.2, -THICKNESS/2*.5, 0])
        cube([WIDTH-THICKNESS*1.2, THICKNESS*.5, thickness]);

        // sides
        translate([THICKNESS/2 *1.2, -THICKNESS/2 -1 -2 -1, 0])
        cube([WIDTH-THICKNESS*1.2, 3, thickness]);

        translate([THICKNESS/2 *1.2, +THICKNESS*.8  , 0])
        cube([WIDTH-THICKNESS*1.2, 3, thickness]);
    }
    
    // camera
    {
        l = 30;
        w = .5;
        h = 143.34 -11.9 +.15;
        w2 = 3+9;
    }

    // power button
    translate([WIDTH-.4,
               -THICKNESS*.25-SUPPORT_THICKNESS*2+1.2-.6,
               POWER_BUTTON_POS+POWER_BUTTON_HEIGHT/2-CUTS_D*1.5])
    scale([.5, 1, 1])
    difference() {
        rotate([90, 0, 0])
        cylinder(d=POWER_BUTTON_HEIGHT, h=SUPPORT_THICKNESS);
        translate([0, -SUPPORT_THICKNESS*1.5, -POWER_BUTTON_HEIGHT/2])
        cube([POWER_BUTTON_HEIGHT, SUPPORT_THICKNESS*2, POWER_BUTTON_HEIGHT]);
    }

    // speaker
    if (0) {
        speaker_pos = 156;
        speaker_height = 2.5;
        pillar_width = 1.5;
        translate([WIDTH/2 - pillar_width/2, -WALL_THICKNESS -3.5, speaker_pos])
        cube([pillar_width, WALL_THICKNESS/2, speaker_height]);
    }
    
    // top edge
    if (1) {
        tw = WIDTH *.55;
        tw2 = WIDTH *.81;
        th = 29;
        offy = 9.7;
        offz = -.83 +.40;
        translate([WIDTH/2-tw/2, -THICKNESS/2 + offy, LENGTH - th + offz])
        rotate([18, 0, 0]) {

            for (x=[0:5:tw2])
                translate([-(tw2-tw)/2 + x, 0, th-1])
                cube([.6, 1, 1]);
            
            hull() {
                cube([tw, 1, th-.5]);
                translate([-(tw2-tw)/2, 0, th-.5])
                cube([tw2, 1, .01]);
            }
        }
    }
  
    // side fins
    thickness2 = .7;
    translate([0, 0, -WALL_THICKNESS/2]) {
        for (x=[16, 58]) {
            difference() {
                translate([x, -THICKNESS*.6, 0]) hull() {
                    translate([0, -WIDTH*.7, 0])
                    cube([thickness2, WIDTH*.7, thickness2]);
                    cube([thickness2, thickness2, WIDTH*1.25]);
                }

                rotate([0, 90, 0]) cylinder(r=THICKNESS*2, h=WIDTH);
                translate([0, 0, WIDTH*.7]) rotate([0, 90, 0]) cylinder(r=THICKNESS*1.7, h=WIDTH);
            }
        }
    }
}

/******************************************************************************/

FLAP_NB_LAYERS = PREVIEW_CUTS ? 2 : 6; //4;  //@@@
FLAP_Z_POS     = 10;
FLAP_X_ADJUST  = 1;
FLAP_EXTEND_ADJUST  = -7;
FLAP_LAYER_HEIGHT = PREVIEW_CUTS ? 3.5 : 7; //@@@

TOOL_WIDTH     = 24.5;
TOOL_WIDTH2    = 23.9;
TOOL_LENGTH    = 79.5 +1;
TOOL_THICKNESS =  2.0;
TOOL_RECESS    =  0.35;
TOOL_LOCK      =  0.2;

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

module flap() {
    y = THICKNESS/2 + get_hinge_thickness()/2;
    z = FLAP_Z_POS;

    translate([WIDTH/2 + FLAP_X_ADJUST, y, z]) {
        translate([-TOOL_WIDTH-6.5, -2 + TOOL_RECESS, 3.5])
        intersection() {
            flap_cavity(TOOL_WIDTH);

            %translate([0, 0, -1]) cube([TOOL_WIDTH, TOOL_THICKNESS, TOOL_LENGTH]);
            
            l = TOOL_WIDTH/3.5;
            l2 = TOOL_WIDTH/1.5;
            l3 = TOOL_WIDTH/3;

            union() {
                translate([TOOL_WIDTH/2-l/2,
                           TOOL_THICKNESS+1 - TOOL_LOCK,
                           TOOL_LENGTH-TOOL_LOCK*2])
                rotate([0, 90, 0])
                cylinder(r=1, h=l);
                
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
                   nb_layers=FLAP_NB_LAYERS);

            translate([-TOOL_WIDTH-6.5, -2 + TOOL_RECESS, 3.5]) {
                translate([0, 0, 10]) flap_cavity(TOOL_WIDTH);
                flap_cavity(TOOL_WIDTH2);
            }
        }
    }
}

module flap_cut() {
    y = THICKNESS/2 + get_hinge_thickness()/2;
    z = FLAP_Z_POS;
    translate([WIDTH/2 + FLAP_X_ADJUST, y-.1, z])
    hinge2_cutout(extent=WIDTH/2 + FLAP_EXTEND_ADJUST,
                  layer_height=FLAP_LAYER_HEIGHT,
                  nb_layers=FLAP_NB_LAYERS);
}

/******************************************************************************/

module all() {
    difference() {
        intersection() {
            union() {
                case();
                if (1) translate([0, -LID_SPACING, 0]) lid();
                if (!SUPPRESS_HINGE) lid_hinge_maybe_cached();
            }
            partitionner2();
        }
        flap_cut();
    }
    flap();

    translate([0, 0, -THICKNESS/6 -.3])
    support();
}

intersection() {
    %partitionner2();
    all();

    //cylinder(r=WIDTH*2, h=35);
    
    if ($preview && PREVIEW_CUTS)
        translate([LENGTH/4, -LENGTH, 4.75]) //LENGTH*1.25 - LENGTH*2 + 3])
        cube([LENGTH, LENGTH*2, LENGTH]);
}
