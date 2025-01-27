HEIGHT    = 70;
_HEIGHT    = 8;

WALL      =  3;
PLAY      =  0.5;
DZ        =  2;
_LIP_H     =  6;
LIP_H     =  3;

BEND_H    =  4;

CLIP_H    = 12;
_CLIP_H    = 0;

FLY       =  3;

TOLERANCE = .17;
ATOM      =  0.007;

/*
LIP_H  =  3;
HEIGHT =  6;
CLIP_H =  3;
*/

module shape_outer() {
    translate([-160.7, -65, 0])
    import("coffee-container-extension-outer.dxf");
}

module shape_inner() {
    translate([-160.7, -65, 0])
    import("coffee-container-extension-inner.dxf");
}

module bending() {
    r = 1400;
    translate([0, 0, -r + BEND_H])
    rotate([90, 0, 0])
    cylinder(r=r, h=300, center=true, $fn=200);
}

module wall_outer(outer, inner, h, z) {
    assert(h>=BEND_H);
    translate([0, 0, z])
    intersection() {
        difference() {
            linear_extrude(h)
            difference() {
                offset(r=outer/2) shape_outer();
                offset(r=-inner/2) shape_outer();
            }
           bending();
        }
        translate([0, 0, h-BEND_H])
        bending();
    }
}

module wall_inner(outer, inner, h, z, bending=true, hollowing=true) {
    if (bending)
        assert(h>=BEND_H);
    translate([0, 0, z])
    intersection() {
        difference() {
            linear_extrude(h)
            difference() {
                offset(r=outer/2) shape_inner();
                if (hollowing)
                    offset(r=-inner/2) shape_inner();
            }
            if (bending)
                bending();
        }
        if (bending)
            translate([0, 0, h-BEND_H])
            bending();
    }
}
//!wall(WALL/2, WALL/2, 8, 0);

module clip(is_bottom=true, shrink=false) {
    h = CLIP_H;
    d = WALL*1.125 -.5/4;
    w = WALL*.75 - (shrink ? TOLERANCE*2 : 0);
    r = WALL*.5 - (shrink? TOLERANCE*2 : 0);
    
    scale([1, 1.85, 1]) {
        difference() {
            for (i=[-1, 1]) {
                hull() {
                    translate([i*d, 0, 0])
                    cylinder(r=r, h=h, $fn=50);

                    translate([i*d*2.5, 0, 0])
                    cylinder(r=r, h=h, $fn=50);
                }
            }
            translate([0, 0, is_bottom ? h : 0])
            rotate([0, 45, 0])
            cube(d*1.5, center=true);
        }

        translate([-WALL, -w/2, is_bottom ? 0 : h*.3+1])
        cube([WALL*2, w, h*.7-1]);
    }
}

module all_clips() {
    // all clips
    translate([0, 0, -FLY])
    for (k=[-1, 1])
    for (i=[-1:1])
        translate([i*WALL*(3.05 + 3.23), k*4, 0])
        clip(shrink=true);
}
//!all_clips();

module container0() {
    // Body

    wall_outer(WALL*3 - PLAY +1, -WALL*1.5, HEIGHT + DZ*2 + LIP_H + BEND_H, 0);
    wall_outer(WALL*3 - PLAY +1, -WALL*.5 ,          DZ*2 + LIP_H + BEND_H, 0);

    d = 4;
    translate([0, -2, 0])
    wall_inner(WALL*3 - PLAY +1 - d, -WALL*1.5 + d, HEIGHT + DZ*1.5, 0);

    // extra walls

    h = HEIGHT + DZ*1.5 - BEND_H - DZ;
    translate([-WALL, -37.65 - 1 -2, BEND_H])
    cube([WALL*2, 5.3+3, h]);

    w = 13.5;
    translate([-WALL, 21.38 +5 -3, BEND_H])
    cube([WALL*2, w, h]);

    translate([-WALL, 81.25 -.7+2.5, BEND_H])
    cube([WALL*2, w, h]);

    translate([-WALL, 39-2.5, BEND_H])
    cube([WALL*2, 44.5+2.5, min(HEIGHT-DZ, WALL*4)]);

    // diagonals

    for(k=[-1, 1])
        translate([-16.8*k, -3, BEND_H])
        rotate([0, 0, 40.5*k])
        translate([-WALL/2, 29+6-3, 0])
        cube([WALL, 92-5+3, WALL*2]);
}

module container() {
    difference() {
        container0();
 
        // hollowings for clips
        if (CLIP_H) {
            bot_z = - ATOM + BEND_H;
            top_z = bot_z + HEIGHT - DZ - CLIP_H + ATOM*2;
            for (zb=[[bot_z, true], [top_z, false]]) {
                z = zb[0]; b = zb[1];
                for (y=[-35.5-1, 27+.5 + 5-2, 87+2.5]) {
                    translate([0, y, z]) {
                        clip(b);
                        translate([0, 0, b ? 1 : -1]) clip(b);

                        translate([0, 0, b ? CLIP_H + 7 : -7])
                        rotate([0, 90, 0])
                        cylinder(r=2.5, h= WALL*3, center=true, $fn=50);
                        %clip();
                    }
                }
            }
        }
    }
    
    // elevate
    if (1)
        translate([0, 0, -FLY])
        cylinder(d=.5*10, h=.3, $fn=50);
}


// %linear_extrude(4.5) shape();

%intersection() {
    container();
    //translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(r=10.000, h=5.0000, center=!true);
}

%//color("lightblue")
translate([0, 27.75, 8]) {
    difference() {
        translate([0, 0, -8.5])
        cube([1, 160, 17], center=true);

        translate([0, 0, -8])
        cube([2, 133.5, 16], center=true);

        translate([0, 0, 0])
        cube([2, 138.5, 16], center=true);
    }
    
    translate([500, 0, HEIGHT+6])
    difference() {
        union() {
            cube([1, 141.5, 10], center=true);

            translate([0, 0, -6])
            cube([1, 135, 12], center=true);
        }
        translate([0, 0, -10])
        cube([2, 129.5, 10], center=true);
    }
}

all_clips();

module inner_lid() {
    translate([0, -1, 0])
    wall_inner(4, 0, 1.5, 0, bending=false, hollowing=false);

    translate([0, -1.8, 0])
    wall_inner(-.3, 8, 15, 0, bending=false, hollowing=true);
}

