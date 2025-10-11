use <../screw-hole.scad>

GRIP_THICKNESS =  30;
GRIP_LENGTH    = 110;
GRIP_WIDTH     =  40;
GRIP_DIAMETER  =  30;

THICKNESS      =  12;
BORDER_X       =  30;
BORDER_Y       =  15;

SCREW_DIAMETER =   4.2;
GAP            =   0.1;

ATOM = 0.01;
$fn = 50;

/*
%translate([0, -BORDER_Y, -GRIP_DIAMETER/2 -5])
cube([GRIP_DIAMETER*2 + GRIP_WIDTH, BORDER_Y*2+GRIP_LENGTH, GRIP_DIAMETER]);
%translate([0, -BORDER_Y, -10])
cube([GRIP_DIAMETER*2 + GRIP_WIDTH, BORDER_Y*2+GRIP_LENGTH, 10]);
*/

module half_egg() {
    intersection() {
        hull() {
            translate([0, 0, GRIP_DIAMETER/16])
            resize([GRIP_DIAMETER, BORDER_Y, GRIP_DIAMETER/2.5])
            sphere();
            
            resize([GRIP_DIAMETER, BORDER_Y, ATOM])
            cylinder();
        }
        cylinder(r=GRIP_LENGTH, h= GRIP_DIAMETER*.253);    
    }
}

module screw_holes() {
    px = GRIP_DIAMETER/2;
    for (y=[0, GRIP_LENGTH/2, GRIP_LENGTH])
        translate([px, y, 0])
        screw_hole(4.2, 8.2, 4, GRIP_DIAMETER/2);
}

module handle() {
    difference() {
        union() {
            // gripper bar
            hull()
            for (y=[-BORDER_Y/2, GRIP_LENGTH+BORDER_Y/2]) 
                translate([GRIP_DIAMETER/2, y, 0])
                half_egg();

            // sides
            for (y=[-BORDER_Y/2, GRIP_LENGTH+BORDER_Y/2])
            hull() {
                translate([GRIP_DIAMETER+GRIP_WIDTH/2-ATOM -GAP/2, y-BORDER_Y/2, 0])
                cube([ATOM, BORDER_Y, 1]);

                translate([GRIP_DIAMETER/2, y, 0])
                half_egg();
            }
        }
        
        // screw holes
        screw_holes();
    }
}

module stencile() {
    difference() {
        translate([0, -BORDER_Y, 0])
        cube([GRIP_DIAMETER*2 + GRIP_WIDTH, BORDER_Y*2+GRIP_LENGTH, 4]);

        // hollowing
        translate([GRIP_DIAMETER, 0, -5])
        cube([GRIP_WIDTH, GRIP_LENGTH, 15]);

        // screw holes
        screw_holes();
    }
}

module handles(just_stencile) {
    handle();

    translate([GRIP_DIAMETER*2 + GRIP_WIDTH, 0, 0])
    scale([-1, 1, 1])
    handle();
}

%translate([0, 0, -4]) stencile();

handles();
