/* OpenSCAD project.
 * Buckles to hold cables together. 4 different sizes.
 *
 * (C) 2019 by P. Bauermeister
 *
 * See https://github.com/pbauermeister/DIY/tree/master/3d-printing/2019-07-09--earphone-buckles
*/

// Object sizes
SMALL_HEIGHT          =  8.4;
SMALL_WALL_THICKNESS  =  2.0;
SMALL_LENGTH          = 34.0;
SMALL_WIDTH           = 16.0;
SMALL_PRONG_SIZE      =  6.0;

MEDIUM_HEIGHT         =  8.4;
MEDIUM_WALL_THICKNESS =  2.1;
MEDIUM_LENGTH         = 38.0;
MEDIUM_WIDTH          = 17.0;
MEDIUM_PRONG_SIZE     =  7.0;

BIG_HEIGHT            =  8.4;
BIG_WALL_THICKNESS    =  2.1;
BIG_LENGTH            = 48.0;
BIG_WIDTH             = 20.0;
BIG_PRONG_SIZE        =  8.0;

BIGGER_HEIGHT         =  8.4;
BIGGER_WALL_THICKNESS =  2.4;
BIGGER_LENGTH         = 75.0;
BIGGER_WIDTH          = 32.0;
BIGGER_PRONG_SIZE     = 12.0;

// Rendering
DRAFT = false; // false: final rendering, true: disable Minkowski
$fn = 90;

// Globals
PLAY  = 1.0;
SPACE =  .2;
ATOM  = 0.01;

// Transform: Grow object, useful to carve another object with a play margin
module grow_object() {
    if (DRAFT) {
        // do not grow, much faster
        children();
    } else {
        // grow size in each dimension (by a cube)
        minkowski() {
            children();
            cube([PLAY, PLAY, PLAY], true);
        }
    }
}

// Helper object: 2D section of the buckle
module section(height, wall_thickness) {
    intersection() {
        if (0) intersection() {
            k = 1.08;
            scale([wall_thickness*2 * k, height * k, 1]) circle(d=1);
        }
        else {
            k1 = .9;
            k2 = 1.05;
            r = wall_thickness * k1;
            hull() for (i=[-1,1])
                for (j=[-1,1])
                    translate([(wall_thickness - r)*i, (height/2*k2 - r)*j])
                    circle(r=r);
        }
        square([wall_thickness*2, height], center=true);
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
            translate([width/2 - wall_thickness/2, 0, 0]) section(height, wall_thickness);

            // flank
            hull() for (j=[-1, 1]) {
                translate([-(length/2-width/2)*j, -width/2+wall_thickness/2 + i*(width/2-wall_thickness/2), 0])
                rotate([0, 0, 90])
                rotate_extrude(angle=.001)
                translate([width/2 - wall_thickness/2, 0, 0])  section(height, wall_thickness);
            }
        }
    }
}

// Object: The prong
module prong(wall_thickness, height, length, width, prong_size) {
    prong_width = prong_size;
    prong_width2 = prong_size * .8;
    hinge_radius = height/2;

    difference() {
        union() {
            // arm

            translate([-prong_width/2, -width/2 + wall_thickness/2 + PLAY, 0])
            cube([prong_width, width, wall_thickness]);

            difference() {
                translate([-prong_width2/2, -width/2 + wall_thickness/2, 0])
                cube([prong_width2, width -wall_thickness*2 - SPACE, height*.9]);
//                grow_object() hollow_buckle(height, wall_thickness, length, width);
            }

            // hinge

            translate([-prong_width/2, -width/2 + hinge_radius/4.5 - hinge_radius, 0])
            cube([prong_width, hinge_radius*2, hinge_radius]);

            translate([-prong_width/2, -width/2 + hinge_radius/4.5, hinge_radius])
            rotate([0, 90, 0])
            cylinder(r=hinge_radius, h=prong_width);
        }
        // hinge hole
        translate([-prong_width/2-1, -width/2 + hinge_radius/4.5, hinge_radius])
        rotate([0, 90, 0])
        cylinder(r=hinge_radius/1.75, h=prong_width + 2);

        // text
        th = .5;
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
        grow_object() prong(wall_thickness, height, length, width, prong_size);
    }
}

// Object: One whole finished object (buckle and prong)
module unit(height, wall_thickness, length, width, prong_size) {
    buckle(height, wall_thickness, length, width, prong_size);
    prong(wall_thickness, height, length, width, prong_size);
}

// Copies params
PARAMS = [
    [3, SMALL_HEIGHT, SMALL_WALL_THICKNESS, SMALL_LENGTH, SMALL_WIDTH, SMALL_PRONG_SIZE],
//    [3, MEDIUM_HEIGHT, MEDIUM_WALL_THICKNESS, MEDIUM_LENGTH, MEDIUM_WIDTH, MEDIUM_PRONG_SIZE],
    [2, BIG_HEIGHT, BIG_WALL_THICKNESS, BIG_LENGTH, BIG_WIDTH, BIG_PRONG_SIZE],
    [2, BIG_HEIGHT, BIG_WALL_THICKNESS, BIG_LENGTH, BIG_WIDTH, BIG_PRONG_SIZE],
    [1, BIGGER_HEIGHT, BIGGER_WALL_THICKNESS, BIGGER_LENGTH, BIGGER_WIDTH, BIGGER_PRONG_SIZE],
];

// Render one copy, then recurse
module render(i=0, y=0) {
    n              = PARAMS[i][0];
    height         = PARAMS[i][1];
    wall_thickness = PARAMS[i][2];
    length         = PARAMS[i][3];
    width          = PARAMS[i][4];
    prong_size     = PARAMS[i][5];

    for (j=[0:n-1])
        translate([(j-(n-1)/2)*(length+wall_thickness*1.5), y, 0])
        unit(height, wall_thickness, length, width, prong_size);

    if (i<len(PARAMS)-1) {
        next_width = PARAMS[i+1][4];
        render(i+1, y + width/2 + next_width/2 + wall_thickness*3);
    }
}

// Here it goes: make several copies of various sizes
render();
