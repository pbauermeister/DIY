use <../chamferer.scad>

//L = 110         -10;
//W = 163         + 0;
MARG = 17;

L = 150 - MARG*2    +15;
W = 200 - MARG*2;

H =   4.2           +0.5;
R =  30 +10         +5;
TH = 2;

ATOM = 0.01;

module rcube(w, l, h, r) {
    d = r*sqrt(2);
 
    hull()
    for (x=[d/2, l-d/2])
    for (y=[d/2, w-d/2])
        translate([x, y, h/2])
        rotate([0, 0, 45])
        cube([r, r, h], center=true);
}

module base(d=0, dh=0) {
    rcube(L-d*2, W-d*2, H+dh, R);
}

module frame(th=TH, ch=H-ATOM, d=0) {
    difference() {
        chamferer(ch, "cone-down")
        base(d);

    translate([th, th, -ATOM])
        chamferer(ch, "cone-down")
        base(d+th, ATOM*2);
    }
}

module all() {
    difference() {
        frame();
        
        d = 57;
        h =  3.6;
        w = 65 -10;
        th = 3;
        for (x=[-d/2, d/2])
            translate([x+W/2, 0, 0])
            cube([th, W*2, h*2], center=true);

        translate([W/2, L/2, 0])
        cube([W*2, th, h*2], center=true);

        for(sx_dx=[[1, 0], [-1, W]]) {
            sx = sx_dx[0];
            dx = sx_dx[1];            
            for(sy_dy=[[1, 0], [-1, L]]) {
                sy = sy_dy[0];
                dy = sy_dy[1];
                translate([dx, dy, 0])
                scale([sx, sy, 1])
                hull() {
                    translate([W/2 - w/2 - W/2, L/2 -W/2, 0])
                    cylinder(d=th, h=h);
                    translate([W/2 - w/2, L/2, 0])
                    cylinder(d=th, h=h);
                }
            }
        }

    }
}


scale([1, 1, -1])
all();