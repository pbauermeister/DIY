use <../chamferer.scad>

W_IN =  85;
WALL =   5;
H_IN =  50;

H    = H_IN*2 + WALL*3;
L    = WALL+W_IN+WALL+W_IN+WALL;

$fn  = 200;
ATOM = 0.02;

/*
%translate([WALL + W_IN/2, W_IN/2 + WALL, 0])
%cylinder(d=W_IN, h=H+1);

%translate([WALL + W_IN + WALL + W_IN/2,  W_IN/2 + WALL, 0])
cylinder(d=W_IN, h=H+1);
*/

module holder() {
    difference() {
        chamferer($preview?0:1.5)
        difference() {
            // body
            hull() {
                d = W_IN+WALL*2;
                translate([d/2, d/2, 0])
                cylinder(d=d, h=H);
                
                translate([d*1.5 - WALL, d/2, 0])
                cylinder(d=d, h=H);

                translate([W_IN*.15, 0, 0])
                cube([L-W_IN*.30, WALL, H]);
            }
            
            // cavities
            for (x=[-ATOM, WALL+W_IN+WALL])
                for (z=[WALL, WALL + H_IN + WALL])
                    translate([x, WALL, z])
                    cube([W_IN+WALL+ATOM, W_IN + ATOM + WALL, H_IN]);

            // top holes
            for (x=[0, WALL+W_IN])
                translate([x+W_IN/2+WALL, WALL+W_IN/2, H-WALL*1.5])
                cylinder(d=W_IN-WALL, h=WALL*3);

        }

        // embossing
        th = 1;
        for (x=[0, WALL+W_IN])
            for (z=[WALL-th, WALL+H_IN+WALL-th])
                translate([x+W_IN/2+WALL, WALL+W_IN/2, z+ATOM])
                cylinder(d1=W_IN-WALL, d2=W_IN-WALL+(th+ATOM)*2, h=th+ATOM);
    }
}

rotate([90, 0, 0])
holder();