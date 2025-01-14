use <hinge3.scad>

// general
STRAP_WIDTH                  =  38;
CHAIN_LENGTH                 =  70 -30  + 30;
CHAIN_PARTS                  =   4;
THICKNESS                    =   6 -1;

// buckle
BUCKLE_LENGTH                = THICKNESS*3;
BUCKLE_MARGIN                =   4;
BUCKLE_PIN_DIAMETER          =   0.8;

// ball joint
BALL_JOINT_DIAMETER          =  37;
BALL_JOINT_DIAMETER_PLAY     =   0.25;
BALL_JOINT_CYLINDER_DIAMETER =  24      -1;
BALL_JOINT_LIBERTY_ANGLE     =   6      *2;

BALL_JOINT_EXCESS            =   1;
BALL_JOINT_FRONT_THICKNESS   =   3;

// (virtual) plate
PLATE_WIDTH                  =  25;
PLATE_LENGTH                 =  23;

PLATE_SCREW_HOLES_LDIST      =  14/2;
PLATE_SCREW_HOLES_WDIST      =  15;
PLATE_SCREW_HOLES_DIAMETER   =   2.2      +.7;
PLATE_X_POS                  = -25  + 3;
PLATE_GAP                    =   1        + 3  +3;

// joiner
JOINER_DIAMETER              =  37.96;

// Supports
SUPPORT_BLOCKERS_WIDTH       =   5;
SUPPORT_BLOCKERS_GAP         =   1;
SUPPORT_THICKNESS            =   0.3;

// computed
BUCKLE_PASSAGE_THICKNESS = STRAP_WIDTH-THICKNESS*1.9;

// misc
$fn  = $preview ? 12 : 100;
ATOM = .01;
PLAY = .15;

module chain0() {
    nb_layers = 3;
    nb_rings = CHAIN_PARTS;
    kx = 1.33;

    part_length = CHAIN_LENGTH/nb_rings;

    for (i=[0:nb_rings-1]) {
        translate([part_length/2 + part_length*i, 0, 0])
        rotate([0, 0, i%2==0 ? 0 : 180]) {
            scale([kx, 1, 1])
            hinge_new(nb_layers=nb_layers, layer_height=STRAP_WIDTH/nb_layers/2, thickness=THICKNESS,
                          width1=part_length/2/kx, width2=part_length/2/kx, angle2=0);
        }
    }
}

module chain() {
    intersection() {
        chain0();
        translate([-CHAIN_LENGTH/2, -THICKNESS/2, 0])
        rounded_cube(THICKNESS/2, CHAIN_LENGTH*2, THICKNESS, STRAP_WIDTH);
    }
}

module rounded_cube(r, l, w, h) {
    hull() {
        for (x = [r, l-r])
        for (y = [r, w-r])
        for (z = [r, h-r])
            translate([x, y, z])
            sphere(r=r);
    }
}

module buckle() {
    margin = BUCKLE_MARGIN;
    length = BUCKLE_LENGTH;
    passage_thickness = BUCKLE_PASSAGE_THICKNESS;

    difference() {
        union() {
            difference() {
                translate([0, -THICKNESS/2, -margin])
                rounded_cube(THICKNESS/2, length, THICKNESS, STRAP_WIDTH+2*margin);

                // slit
                pcent = .9;
                translate([length/2-THICKNESS*pcent +THICKNESS/2, -THICKNESS, 0])
                cube([THICKNESS*pcent, THICKNESS*2, STRAP_WIDTH]);
            }
        }

        // passage
        gap = .3;
        for (z=[-1, 1])
            translate([length/2-ATOM, -THICKNESS, STRAP_WIDTH/2-passage_thickness/2*z -gap/2])
            cube([length, THICKNESS*3, gap]);

        // pin chamber
        buckle_bar(with_center_part=false, for_diff=true);

    }
    //translate([-THICKNESS/2, THICKNESS/2, 0])
    %buckle_bar();
}

module buckle_bar(with_center_part=true, for_diff=false) {
    length = BUCKLE_LENGTH;
    passage_thickness = BUCKLE_PASSAGE_THICKNESS;

    // center piece
    if (with_center_part) difference() {
        hull() for (x=[length/2+THICKNESS/2, length- THICKNESS/2])
            translate([x, 0, STRAP_WIDTH/2-passage_thickness/2])
            cylinder(d=THICKNESS, h=passage_thickness);

        if (!for_diff)
            translate([length - THICKNESS/2, 0, -BUCKLE_MARGIN*2])
            cylinder(d=BUCKLE_PIN_DIAMETER, h=STRAP_WIDTH+BUCKLE_MARGIN*4);
    }

    // column
    translate([length/2+THICKNESS/2 + (for_diff ? PLAY : 0), 0, 0]) {
        intersection() {
            cylinder(d=THICKNESS, h=STRAP_WIDTH);
            translate([-THICKNESS, -THICKNESS/2, 0])
            cube([THICKNESS,THICKNESS, STRAP_WIDTH]);
        }
    }

    d = THICKNESS * .95;
    kx = for_diff ? (d + PLAY*2) / d : 1;
    for (z=[THICKNESS/2+PLAY - d*.2, STRAP_WIDTH-THICKNESS/2-PLAY + d*.2])
        translate([length/2+THICKNESS/2, 0, z])
        scale([kx, kx, 1])
        sphere(d=d, $fn=4);

    if (for_diff)
        translate([length - THICKNESS/2, 0, -BUCKLE_MARGIN*2])
        cylinder(d=BUCKLE_PIN_DIAMETER, h=STRAP_WIDTH+BUCKLE_MARGIN*4);
}

module chain_and_buckle() {
    chain();
    translate([CHAIN_LENGTH - THICKNESS/2, 0, 0]) buckle();
}

module plate_screws() {
    translate([PLATE_X_POS, -THICKNESS/2, STRAP_WIDTH/2 - PLATE_WIDTH/2]) {
        for (x=[PLATE_LENGTH/2-PLATE_SCREW_HOLES_LDIST/2, PLATE_LENGTH/2+PLATE_SCREW_HOLES_LDIST/2])
        for (y=[PLATE_WIDTH/2-PLATE_SCREW_HOLES_WDIST/2, PLATE_WIDTH/2+PLATE_SCREW_HOLES_WDIST/2])
             translate([x, 0, y])
        rotate([-90, 0, 0])
        cylinder(d=PLATE_SCREW_HOLES_DIAMETER, h=THICKNESS+PLATE_GAP*2, center=!true);
    }
}

module joiner() {
    hull() {
        // corners to chain
        for (z=[THICKNESS/2, STRAP_WIDTH-THICKNESS/2])
        translate([0, 0, z])
        sphere(d=THICKNESS);

        // torus
        translate([PLATE_X_POS+PLATE_LENGTH*.25, 0, STRAP_WIDTH/2])
        scale([.5, 1, 1])
        rotate([90, 0, 0])
        rotate_extrude(convexity=10, $fn=100)
        translate([JOINER_DIAMETER/2-THICKNESS/2, 0, 0])
            circle(d=THICKNESS, $fn=100);
    }
}

module chain_and_buckle_and_joiner() {
    difference() {
        union() {
            chain_and_buckle();
            joiner();
        }
        ball_joint(true);
    }
}

module ball_joint(for_diff=false, with_brim_blocker=false) {
    xtra = for_diff ? BALL_JOINT_DIAMETER_PLAY : 0;
    xtra2 = for_diff ? BALL_JOINT_DIAMETER/2 * sin(BALL_JOINT_LIBERTY_ANGLE/2) : 0;
    fn = $preview ? 50 : $fn;

    difference() {
        translate([PLATE_X_POS + PLATE_LENGTH/2, 0, STRAP_WIDTH/2]) {
            intersection() {
                difference() {
                    union() {
                        translate([0, -BALL_JOINT_DIAMETER/2 + THICKNESS  +THICKNESS/4, 0])
                            sphere(d=BALL_JOINT_DIAMETER+xtra*2, $fn=fn);
                        
                        translate([0, THICKNESS/2 + PLATE_GAP, 0])
                        rotate([90, 0, 0])
                        cylinder(d=BALL_JOINT_CYLINDER_DIAMETER + xtra2*2, h=THICKNESS + PLATE_GAP, $fn=fn);
                    }
                    // curved side
                    d = BALL_JOINT_CYLINDER_DIAMETER*6;
                    translate([0, THICKNESS/2  + PLATE_GAP + d/2 -4 , BALL_JOINT_CYLINDER_DIAMETER/2])
                    rotate([0, 90, 0])
                    cylinder(d=d, h=BALL_JOINT_CYLINDER_DIAMETER*2, center=true, $fn=$preview?100:$fn);
                }
                translate([0, THICKNESS/2 + PLATE_GAP, 0])
                rotate([90, 0, 0])
                cylinder(d=BALL_JOINT_DIAMETER + xtra*2, h=THICKNESS + PLATE_GAP + xtra + BALL_JOINT_EXCESS);

                translate([0, THICKNESS/2 + PLATE_GAP, 0])
                rotate([90, 0, 0])
                cylinder(d=BALL_JOINT_DIAMETER*.83 + xtra*2, h=THICKNESS + PLATE_GAP + xtra + BALL_JOINT_EXCESS, $fn=fn);

                cube([BALL_JOINT_CYLINDER_DIAMETER*.7 + xtra2*2, (THICKNESS+PLATE_GAP)*2, BALL_JOINT_DIAMETER], center=true);
            }

            translate([0, -THICKNESS/2 -BALL_JOINT_EXCESS-BALL_JOINT_FRONT_THICKNESS*.5, 0])
            hull()
            rotate([90, 0, 0])
            rotate_extrude(convexity=10)
            translate([BALL_JOINT_DIAMETER/2*.83, 0, 0])
                circle(d=BALL_JOINT_FRONT_THICKNESS);
            
            if (with_brim_blocker)
                translate([0, -THICKNESS/2 -BALL_JOINT_EXCESS-BALL_JOINT_FRONT_THICKNESS, 0])
                rotate([-90, 0, 0])
                difference() {
                cylinder(d=BALL_JOINT_DIAMETER, h=.3);
                cylinder(d=BALL_JOINT_DIAMETER-1, h=1, center=true);
                }

        }
        if (!for_diff)
            plate_screws();
        %plate_screws();
    }
}

module support_blockers() {
    gap = SUPPORT_BLOCKERS_GAP;
    for (y=[THICKNESS/2 + gap, -THICKNESS/2 - SUPPORT_BLOCKERS_WIDTH - gap])
        translate([PLATE_X_POS - THICKNESS*.6, y, -BUCKLE_MARGIN])
        cube([CHAIN_LENGTH + BUCKLE_LENGTH - PLATE_X_POS + THICKNESS*0, SUPPORT_BLOCKERS_WIDTH, .3]);
}

module rest() {
    th = SUPPORT_THICKNESS;
    w = STRAP_WIDTH*.4;
    l2 = 6;

    for (sl=[[1, 3], [-1, 25]])
    for (x=[-THICKNESS/2 +2, CHAIN_LENGTH+BUCKLE_LENGTH - THICKNESS]) {
        s = sl[0];
        l = sl[1];
        scale([1, s, 1])
        translate([x, 0, 0]) {
            difference() {
                hull() {
                    translate([0, THICKNESS, -BUCKLE_MARGIN])
                    cube([th, l, 1]);

                    translate([0, THICKNESS/2 - 1, 0])
                    cube([th, 2+2, w + w/2]);
                }
                
                translate([0, THICKNESS/2, -BUCKLE_MARGIN])
                scale([1, .2, 1])
                rotate([0, 90, 0])
                cylinder(r=STRAP_WIDTH*.255, h=4, center=true);

                translate([0, THICKNESS/2, STRAP_WIDTH*.48])
                scale([1, .5, 1])
                rotate([0, 90, 0])
                cylinder(r=STRAP_WIDTH*.09, h=4, center=true);

                translate([0, THICKNESS/2, STRAP_WIDTH*.28])
                scale([1, .5, 1])
                rotate([0, 90, 0])
                cylinder(r=STRAP_WIDTH*.09, h=4, center=true);
            }

            translate([-l2/2, THICKNESS, -BUCKLE_MARGIN])
            cube([l2, l, .3]);
        }
    }
}

module ball_joint_laid_flat() {
    translate([BALL_JOINT_DIAMETER*.58, -BALL_JOINT_DIAMETER*.65 - SUPPORT_BLOCKERS_WIDTH, -BUCKLE_MARGIN + BALL_JOINT_EXCESS+BALL_JOINT_FRONT_THICKNESS])
    rotate([90, 0, 90])
    translate([-(PLATE_X_POS + PLATE_LENGTH/2), THICKNESS/2, -STRAP_WIDTH/2]) {
        ball_joint(with_brim_blocker=true);
    }
}

////////// Here we go

module all() {
    chain_and_buckle_and_joiner();

    // in-place and ghosted
//    %ball_joint();
    %plate_screws();

    // ball joint laid flat
    ball_joint_laid_flat();

    // buckle bar laid flat
    translate([-THICKNESS*2.7, -SUPPORT_BLOCKERS_WIDTH, -BUCKLE_MARGIN])
    translate([CHAIN_LENGTH, -THICKNESS*2, 0])
    rotate([270, 0, 90])
    translate([-BUCKLE_LENGTH*.75, -THICKNESS/2, -STRAP_WIDTH/2])
    buckle_bar();

    // misc
    support_blockers();
    rest();
}

all();