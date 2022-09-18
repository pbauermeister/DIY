CLOSED = 22.5 + 3 -1;

OPENED = 30 -3+2;
OPENED_MARGIN = 5 +3-2;

THICKNESS_H = 6;
THICKNESS_Z = 10;

EXTRUDER_WIDTH = 13.2 -2 +2.5;
EXTRUDER_HANDLE_THICKNESS = 7 + 1.5;
EXTRUDER_HANDLE_THICKNESS_MIN = 5.2;

TRAVEL = EXTRUDER_WIDTH * 1 +2;
WIDTH = EXTRUDER_WIDTH + TRAVEL + THICKNESS_H*2;

HEIGHT = OPENED + OPENED_MARGIN + THICKNESS_Z * 2;
PLAY = .17*2;
ATOM = 0.01;

%cube([1, THICKNESS_H*2, OPENED+OPENED_MARGIN]);
%cube([2, THICKNESS_H*2, OPENED]);
%cube([3, THICKNESS_H*2, CLOSED]);
%translate([THICKNESS_H, -ATOM/2-2, -THICKNESS_Z])
    cube([WIDTH-THICKNESS_H*2, THICKNESS_H+ATOM, THICKNESS_Z]);
%translate([THICKNESS_H, -ATOM/2-2, HEIGHT-THICKNESS_Z*2])
    cube([WIDTH-THICKNESS_H*2, THICKNESS_H+ATOM, THICKNESS_Z]);

module lock() {
    hull() {
        w = WIDTH-THICKNESS_H*2-EXTRUDER_WIDTH-PLAY;
        h = EXTRUDER_HANDLE_THICKNESS - EXTRUDER_HANDLE_THICKNESS_MIN;

        translate([w*.3+THICKNESS_H+EXTRUDER_WIDTH+PLAY, -ATOM, EXTRUDER_HANDLE_THICKNESS-h/2])
        cube([w*.7+ATOM, THICKNESS_H+ATOM*2, h/2+ATOM]);

        translate([THICKNESS_H+EXTRUDER_WIDTH+PLAY, -ATOM, EXTRUDER_HANDLE_THICKNESS])
        cube([w+ATOM, THICKNESS_H+ATOM*2, ATOM]);
    }
}

module hollowing(for_hull=false) {
    difference() {
        union() {
            translate([THICKNESS_H, -ATOM/2, 0])
            cube([WIDTH-THICKNESS_H*2, THICKNESS_H+ATOM, EXTRUDER_HANDLE_THICKNESS]);

            translate([THICKNESS_H, -ATOM/2, 0])
            cube([EXTRUDER_WIDTH+PLAY, THICKNESS_H+ATOM, CLOSED]);

            translate([WIDTH-THICKNESS_H-EXTRUDER_WIDTH-PLAY, -ATOM/2, 0])
            cube([EXTRUDER_WIDTH+PLAY, THICKNESS_H+ATOM, OPENED+OPENED_MARGIN]);

            if (for_hull)
                translate([THICKNESS_H, -ATOM/2, 0])
                cube([EXTRUDER_WIDTH+PLAY, THICKNESS_H+ATOM, OPENED+OPENED_MARGIN]);
                
            hull() {
                translate([THICKNESS_H+EXTRUDER_WIDTH-3, -ATOM/2, 0])
                cube([EXTRUDER_WIDTH, THICKNESS_H+ATOM, CLOSED]);

                translate([WIDTH-THICKNESS_H-EXTRUDER_WIDTH-PLAY, -ATOM/2, 0])
                cube([EXTRUDER_WIDTH+PLAY, THICKNESS_H+ATOM, OPENED]);
            }
        }
    }
}

module body() {
    difference() {
        minkowski() {
            hull() hollowing(for_hull=true);
            cube([THICKNESS_Z, ATOM, THICKNESS_Z], center=true);
        }
        
        translate([0, -THICKNESS_H/2, 0])
        scale([1, 2, 1]) hollowing();
    }
    translate([THICKNESS_H, 0, EXTRUDER_HANDLE_THICKNESS])
    cube([WIDTH-THICKNESS_H*2, THICKNESS_H, THICKNESS_Z]);
    lock();
}

rotate([$preview ? 0 : 90, 0, 0])
body();
