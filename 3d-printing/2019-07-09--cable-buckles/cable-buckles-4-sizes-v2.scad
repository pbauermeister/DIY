/* OpenSCAD project.
 * Buckles to hold cables together. 4 different sizes.
 *
 * (C) 2019 by P. Bauermeister
 *
 * See https://github.com/pbauermeister/DIY/tree/master/3d-printing/2019-07-09--earphone-buckles
*/

// Object sizes
B25_HEIGHT        =  8.4;
B25_WALL_THICKNESS=  1.4;
B25_LENGTH        = 25.0;
B25_WIDTH         = 14.0;
B25_PRONG_SIZE    =  6.0;

B26_HEIGHT        =  8.4;
B26_WALL_THICKNESS=  1.4;
B26_LENGTH        = 26.0;
B26_WIDTH         = 14.0;
B26_PRONG_SIZE    =  6.0;

B29_HEIGHT          =  8.4;
B29_WALL_THICKNESS  =  1.7;
B29_LENGTH          = 29.0;
B29_WIDTH           = 15.5;
B29_PRONG_SIZE      =  6.0;

B31_HEIGHT          =  8.4;
B31_WALL_THICKNESS  =  1.7;
B31_LENGTH          = 31.0;
B31_WIDTH           = 16.0;
B31_PRONG_SIZE      =  6.0;

B32_HEIGHT          =  8.4;
B32_WALL_THICKNESS  =  1.8;
B32_LENGTH          = 32.0;
B32_WIDTH           = 14.0;
B32_PRONG_SIZE      =  6.0;

B38_HEIGHT         =  8.4;
B38_WALL_THICKNESS =  2.1;
B38_LENGTH         = 38.0;
B38_WIDTH          = 17.0;
B38_PRONG_SIZE     =  7.0;

B48_HEIGHT            =  8.4;
B48_WALL_THICKNESS    =  2.1;
B48_LENGTH            = 48.0;
B48_WIDTH             = 20.0;
B48_PRONG_SIZE        =  8.0;

B75_HEIGHT         =  8.4;
B75_WALL_THICKNESS =  2.8;
B75_LENGTH         = 75.0;
B75_WIDTH          = 32.0;
B75_PRONG_SIZE     = 12.0;

// Rendering
DRAFT = $preview; // false: final rendering, true: disable Minkowski
$fn   = $preview ? 12 : 90;

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

        // faster
        d = PLAY / 2;
        for (x=[-d, d])
            for (y=[-d, d])
                for (z=[-d, d])
                    translate([x, y, z])
                    children();

        // slower
        if (0) minkowski() {
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
        text(str(length), font="FreeSans:style=Bold", size=3.5, spacing=1.15);
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
    difference() {
        union() {
            buckle(height, wall_thickness, length, width, prong_size);
            prong(wall_thickness, height, length, width, prong_size);
        }
        
        // cross-cut
//        translate([0, -500, -500]) cube(1000);
    }
}

// Copies params
PARAMS = [
/*
    [3, B32_HEIGHT, B32_WALL_THICKNESS, B32_LENGTH, B32_WIDTH, B32_PRONG_SIZE],
//    [3, B38_HEIGHT, B38_WALL_THICKNESS, B38_LENGTH, B38_WIDTH, B38_PRONG_SIZE],
    [3, B48_HEIGHT, B48_WALL_THICKNESS, B48_LENGTH, B48_WIDTH, B48_PRONG_SIZE],
    [6, B25_HEIGHT, B25_WALL_THICKNESS, B25_LENGTH, B25_WIDTH, B25_PRONG_SIZE],
//    [2, B48_HEIGHT, B48_WALL_THICKNESS, B48_LENGTH, B48_WIDTH, B48_PRONG_SIZE],
    [2, B75_HEIGHT, B75_WALL_THICKNESS, B75_LENGTH, B75_WIDTH, B75_PRONG_SIZE],
    [1, B75_HEIGHT, B75_WALL_THICKNESS, B75_LENGTH, B75_WIDTH, B75_PRONG_SIZE],

*/
/*
    [3, B26_HEIGHT, B26_WALL_THICKNESS, B26_LENGTH, B26_WIDTH, B26_PRONG_SIZE],
    [2, B31_HEIGHT, B31_WALL_THICKNESS, B31_LENGTH, B31_WIDTH, B31_PRONG_SIZE],
    [3, B31_HEIGHT, B31_WALL_THICKNESS, B31_LENGTH, B31_WIDTH, B31_PRONG_SIZE],
    [2, B26_HEIGHT, B26_WALL_THICKNESS, B26_LENGTH, B26_WIDTH, B26_PRONG_SIZE],
*/
/*
    [1, B26_HEIGHT, B26_WALL_THICKNESS, B26_LENGTH, B26_WIDTH, B26_PRONG_SIZE],
    [2, B31_HEIGHT, B31_WALL_THICKNESS, B31_LENGTH, B31_WIDTH, B31_PRONG_SIZE],
*/
    [2, B29_HEIGHT, B29_WALL_THICKNESS, B29_LENGTH, B29_WIDTH, B29_PRONG_SIZE],
    [3, B29_HEIGHT, B29_WALL_THICKNESS, B29_LENGTH, B29_WIDTH, B29_PRONG_SIZE],
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
