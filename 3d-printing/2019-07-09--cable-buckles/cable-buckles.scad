/* OpenSCAD project.
 * Buckles to hold cables together. 4 different sizes.
 *
 * (C) 2019-2022 by P. Bauermeister
 *
 * See https://github.com/pbauermeister/DIY/tree/master/3d-printing/2019-07-09--earphone-buckles
*/

PRONG_TAB_THICKNESS = 1.7;

// Rendering
$fn = 90;

// Globals
PLAY  = 0.7  + .2  *0;
SPACE = PLAY/2 /2;
ATOM  = 0.01;

// Transform: Grow object, useful to carve another object with a play margin
module grow_object() {
    // grow size in each dimension (by a cube)
    minkowski() {
        children();
        cube([PLAY, PLAY, PLAY], true);
    }
}

// Helper object: 2D section of the buckle
module section(height, wall_thickness) {
    if ($preview) {
        square([wall_thickness, height], center=true);
    }
    else intersection() {
        if (0) intersection() {
            k = 1.08;
            scale([wall_thickness * k, height * k, 1]) circle(d=1);
        }
        else {
            k1 = .8;
            k2 = 1.05;
            r = wall_thickness * k1/2;
            hull() for (i=[-1,1])
                for (j=[-1,1])
                    translate([(wall_thickness/2 - r)*i, (height/2*k2 - r)*j])
                    circle(r=r);
        }
        square([wall_thickness, height], center=true);
    }
}

// Helper object: A hollow raw buckle
module hollow_buckle(height, wall_thickness, length, width) {
    translate([0, 0, height/2]) {
        // two half flattened rings
        for (i=[-1, 1]) {
            translate([-(length/2-width/2)*i, 0, 0])
            rotate([0, 0, 90*i])
            rotate_extrude(angle=180)
            translate([width/2 - wall_thickness/2*0, 0, 0]) section(height, wall_thickness);

            // flank
            hull()
            for (j=[-1, 1]) {
                translate([-(length/2-width/2)*j, -width/2+wall_thickness/2*0 + i*(width/2-wall_thickness/2*0), 0])
                rotate([90, 0, 90])
                //rotate_extrude(angle=.001)
                linear_extrude(0.001)
                translate([width/2 - wall_thickness/2*0, 0, 0])  section(height, wall_thickness);
            }
        }
    }
}

// Object: The prong
module prong(wall_thickness, height, length, width, prong_size, shave_arm=true, draft=false) {
    prong_width = prong_size;
    prong_width2 = prong_size * .8;
    hinge_radius = height/2;

    difference() {
        union() {
            // arm bottom (thick)
            translate([-prong_width/2, -width/2 + wall_thickness/2 + PLAY/2, 0])
            cube([prong_width, width + PLAY, PRONG_TAB_THICKNESS]);

            // arm upper (tall)
            difference() {
                translate([-prong_width2/2, -width/2 + wall_thickness/2, 0])
                cube([prong_width2, width -wall_thickness - (shave_arm?PLAY:SPACE*2) -ATOM, height*.9]);

                translate([-prong_size/2, width/2-wall_thickness/2 -SPACE*2, height*.9 - PLAY*2])
                rotate([20, 0, 0])
                cube(prong_size);
            }

            // hinge
            translate([-prong_width/2, -width/2 - hinge_radius, 0])
            cube([prong_width, hinge_radius*2, hinge_radius]);

            if (!draft)
                translate([-prong_width/2, -width/2, hinge_radius])
                rotate([0, 90, 0])
                cylinder(r=hinge_radius, h=prong_width);
            else
                translate([-prong_width/2, -width/2 - hinge_radius, 0])
                cube([prong_width, hinge_radius*2, hinge_radius*2]);
        }

        // hinge hole
        if (!draft)
            translate([-prong_width/2-1, -width/2, hinge_radius])
            rotate([0, 90, 0])
            cylinder(r=hinge_radius/1.75, h=prong_width + 2);

        // text
        th = .5;
        if (!draft)
            translate([1.62, -3, height*.9 -th + ATOM])
            scale([1, 1.2, 1])
            rotate([0, 0, 90])
            linear_extrude(th)
            text(str(length), font="FreeSans:style=Bold", size=3.5);
    }
}

// Object: Buckle, carved to make room for the prong
module buckle(height, wall_thickness, length, width, prong_size) {
    difference() {
        hollow_buckle(height, wall_thickness, length, width);
        grow_object() prong(wall_thickness, height, length, width, prong_size, draft=true);
    }
    
    // axis reinforcement
    translate([0, 0, height/2]) hull() {
        translate([ prong_size, -width/2, 0]) sphere(d=height/2 - PLAY/2.3);
        translate([-prong_size, -width/2, 0]) sphere(d=height/2 - PLAY/2.3);
    }

    // friction lock
    r = height/4;
    translate([0, width/2 - wall_thickness/2 + r/2 - PLAY*1, height*.45]) hull() {
        translate([ height/2, 0, 0]) sphere(d=r);
        translate([-height/2, 0, 0]) sphere(d=r);
    }
}

// Object: One whole finished object (buckle and prong)
module unit(height, wall_thickness, length, width, prong_size) {

    translate([0, -width/2, height/2]) rotate([180, 0, 0]) translate([0, width/2, -height/2])
    buckle(height, wall_thickness, length, width, prong_size);
    
    prong(wall_thickness, height, length, width, prong_size, shave_arm=false);
}

// Here it goes: make several copies of various sizes
// Object sizes
SMALL_HEIGHT          =  8.4;
SMALL_WALL_THICKNESS  =  2.5;
SMALL_LENGTH          = 34.0;
SMALL_WIDTH           = 16.0;
SMALL_PRONG_SIZE      =  6.0;
difference() {
    unit(SMALL_HEIGHT, SMALL_WALL_THICKNESS, SMALL_LENGTH, SMALL_WIDTH, SMALL_PRONG_SIZE);
    translate([-100, -50, -.1]) cube(100);
}