use <hinge3.scad>

// general
STRAP_WIDTH                  =  38;
CHAIN_LENGTH                 =  70 -30  + 30;
CHAIN_PARTS                  =   4;
THICKNESS                    =   6 -1;

// buckle
BUCKLE_LENGTH                = THICKNESS*3.5;
BUCKLE_MARGIN                =   4;

SCREW_DIAMETER               =   3;
SCREW_HEAD_DIAMETER          =   7.5;
BUCKLE_BAR_THICKNESS         = THICKNESS * 2;

// ball joint
BALL_JOINT_DIAMETER          =  37;
BALL_JOINT_DIAMETER_PLAY     =   0.25;
BALL_JOINT_CYLINDER_DIAMETER =  24      -1;
BALL_JOINT_LIBERTY_ANGLE     =   6      *2;

BALL_JOINT_EXCESS            =   1;
BALL_JOINT_FRONT_THICKNESS   =   3;

LATERAL_TILT                 =  12;

// (virtual) plate
PLATE_WIDTH                  =  25;
PLATE_LENGTH                 =  23;

PLATE_SCREW_HOLES_LDIST      =  14/2;
PLATE_SCREW_HOLES_WDIST      =  15;
PLATE_SCREW_HOLES_DIAMETER   =   2.2      +.7;
PLATE_X_POS                  = -25  + 3;
PLATE_GAP                    =   1        + 3  +3 +1;

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
    thickness = THICKNESS * 2/3;
    length = BUCKLE_LENGTH;
 
    difference() {
        translate([0, -thickness/2, -margin])
        rounded_cube(thickness, length+thickness/2, thickness, STRAP_WIDTH+2*margin);

        // pin chamber
        translate([length - thickness, 0, 0]) {
            buckle_bar(for_diff=true);
            %buckle_bar();
        }
    }
}

module buckle_bar(with_center_part=true, for_diff=false) {
    thickness = BUCKLE_BAR_THICKNESS; //THICKNESS*.67 *3;
    h = STRAP_WIDTH - (for_diff ? 0 : PLAY*2);
    difference() {
        hull() {
            cylinder(d=thickness + (for_diff ? thickness*.25 : 0), h=h);
                
            // strap passage
            if (for_diff)
                translate([-thickness*.75, -thickness/2, 0])
                cube([ATOM, thickness, h]);
        }
        
        // wedges
        k = 1/6;
        for (z=[0, h])
            translate([0, 0, z])
            rotate([0, 45, 0])
            cube([thickness*k, thickness*2, thickness*k], center=true);
        
        // screw thread hole
        cylinder(d=SCREW_DIAMETER, h=h);
    }

    if (for_diff) {
        // screw hole
        translate([0, 0, -h/2])
        cylinder(d=SCREW_DIAMETER+.5, h=h*2);

        // screw head hole
        depth = thickness*.1;
        translate([0, 0, h+depth])
        cylinder(d=SCREW_HEAD_DIAMETER, h=thickness);
        translate([0, 0, -thickness-depth])
        cylinder(d=SCREW_HEAD_DIAMETER, h=thickness);

    }
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
                    // ball
                    union() {
                        translate([0, -BALL_JOINT_DIAMETER/2 + THICKNESS  +THICKNESS/4, 0])
                            sphere(d=BALL_JOINT_DIAMETER+xtra*2, $fn=fn);
                        
                        translate([0, THICKNESS/2 + PLATE_GAP, 0])
                        rotate([90, 0, 0]) {
                        cylinder(d=BALL_JOINT_CYLINDER_DIAMETER + xtra2*2, h=THICKNESS + PLATE_GAP, $fn=fn);
                        }
                    }
                    // shave curved side
                    d = BALL_JOINT_CYLINDER_DIAMETER*6;

                    rotate([0, 0, LATERAL_TILT]) // lateral tilt
                    translate([0, THICKNESS/2  + PLATE_GAP + d/2 -4 -1, BALL_JOINT_CYLINDER_DIAMETER/2])
                    rotate([0, 90, 0])
                    cylinder(d=d, h=BALL_JOINT_CYLINDER_DIAMETER*2, center=true, $fn=$preview?100:$fn);
                }

                // containing cylinder
                translate([0, THICKNESS/2 + PLATE_GAP, 0])
                rotate([90, 0, 0])
                cylinder(d=BALL_JOINT_DIAMETER + xtra*2, h=THICKNESS + PLATE_GAP + xtra + BALL_JOINT_EXCESS);

                // containing cylinder, larger
                translate([0, THICKNESS/2 + PLATE_GAP, 0])
                rotate([90, 0, 0])
                cylinder(d=BALL_JOINT_DIAMETER*.83 + xtra*2, h=THICKNESS + PLATE_GAP + xtra + BALL_JOINT_EXCESS, $fn=fn);

                // containing cube, shaving both sides
                cube([BALL_JOINT_CYLINDER_DIAMETER*.7 + xtra2*2, (THICKNESS+PLATE_GAP)*2, BALL_JOINT_DIAMETER], center=true);
            }

            // disc shield
            translate([0, -THICKNESS/2 -BALL_JOINT_EXCESS-BALL_JOINT_FRONT_THICKNESS*.5, 0]) {
                hull() {
                    rotate([90, 0, 0])
                    rotate_extrude(convexity=10)
                    translate([BALL_JOINT_DIAMETER/2*.83, 0, 0])
                        circle(d=BALL_JOINT_FRONT_THICKNESS);
/*
                    intersection() {
                        d = BALL_JOINT_DIAMETER*.92;
                        scale([1, .25, 1]) sphere(d=d);
                        rotate([90, 0, 0])
                       cylinder(d=d, h=d);
                    }
*/
                }
            }
            
            // crown to block brim
            if (with_brim_blocker)
                translate([0, -THICKNESS/2 -BALL_JOINT_EXCESS-BALL_JOINT_FRONT_THICKNESS, 0])
                rotate([-90, 0, 0])
                difference() {
                cylinder(d=BALL_JOINT_DIAMETER, h=.3);
                cylinder(d=BALL_JOINT_DIAMETER-1, h=1, center=true);
                }

        }
        
        // screw holes
        translate([0, 6, 0])
        rotate([0, 0, LATERAL_TILT]) // lateral tilt
        {
            if (!for_diff)
                plate_screws();

            %plate_screws();
        }
    }
}

module support_blockers() {
    gap = SUPPORT_BLOCKERS_GAP*0;
    dx = CHAIN_LENGTH/CHAIN_PARTS;
    thickness = .3 / 2;
    length = CHAIN_LENGTH * .95;
    width = SUPPORT_BLOCKERS_WIDTH*3;
    
    if(1)
        for (y=[THICKNESS/2 + gap, -THICKNESS/2 - SUPPORT_BLOCKERS_WIDTH - gap])
            translate([-THICKNESS*.5, y, -BUCKLE_MARGIN])
            cube([CHAIN_LENGTH, SUPPORT_BLOCKERS_WIDTH, thickness]);

    else {
        for (y=[-width : 3 : width])
            translate([0, y, -BUCKLE_MARGIN])
            cube([length, 0.3, thickness]);

        for (x=[0, length])
            translate([x, -width, -BUCKLE_MARGIN])
            cube([0.3, width*2 +.3, thickness]);
    }
        
}

module rest() {
    th = SUPPORT_THICKNESS;
    w = STRAP_WIDTH*.4;
    l2 = 6;

    for (sl=[[1, 3*3], [-1, 25]])
    for (x=[-THICKNESS/2 +2,
            //CHAIN_LENGTH+BUCKLE_LENGTH - THICKNESS
            CHAIN_LENGTH - THICKNESS+1 //+ THICKNESS/2
           ]) {
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

module __rest() {
    for (x=[-10, CHAIN_LENGTH + THICKNESS*2.5])
        translate([x, 0, 12])
        cube([15, 60, .2], center=true);
}


module ball_joint_laid_flat(with_brim_blocker=true) {
    translate([BALL_JOINT_DIAMETER*.58, -BALL_JOINT_DIAMETER*.65 - SUPPORT_BLOCKERS_WIDTH, -BUCKLE_MARGIN + BALL_JOINT_EXCESS+BALL_JOINT_FRONT_THICKNESS])
    rotate([90, 0, 90])
    translate([-(PLATE_X_POS + PLATE_LENGTH/2), THICKNESS/2, -STRAP_WIDTH/2]) {
        ball_joint(with_brim_blocker=with_brim_blocker);
    }
}

////////// Here we go

module all() {
    chain_and_buckle_and_joiner();

    // in-place and ghosted
    %plate_screws();

    // ball joint laid flat
%    ball_joint_laid_flat();

    // buckle bar laid flat
    translate([CHAIN_LENGTH * .80, -STRAP_WIDTH -SUPPORT_BLOCKERS_WIDTH - THICKNESS, 0])
    translate([0, 0, -BUCKLE_BAR_THICKNESS/2+THICKNESS*1.25 - .25])
    rotate([270, 0, 0])
    rotate([0, 0, 90])
    buckle_bar();

    // misc
    support_blockers();
    rest();
}

//all();
//buckle();
ball_joint();
