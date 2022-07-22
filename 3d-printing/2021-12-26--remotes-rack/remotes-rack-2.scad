
WIDTH     = 54;
LENGTH    = 200;
THICKNESS = 1.5;
H         = 32;
R         = WIDTH * 1;
NB        = 5;
BASE      = 12;

h = R - sqrt(R*R - WIDTH*WIDTH/4);

ATOM = 0.01;
ATOM2 = ATOM*2;

$fn = 360/2;

module bed() {
    thickness = THICKNESS;
    intersection() {
        translate([WIDTH/2, -ATOM, R])
        rotate([270, 0, 0])
        difference() {
            cylinder(r=R, h=LENGTH + ATOM2);
            cylinder(r=R-thickness, h=LENGTH+ATOM2);
        }
        
        cube([WIDTH, LENGTH, 9]);
    }
}

module cut(r) {
    f = .50; //.66;
    scale([1, 1, 0.667])
    hull(){
        s = r*(1-f);
        translate([ 0,  0,  s]) sphere(r=r*f, $fn=36);
        translate([ 0,  0, -s]) sphere(r=r*f, $fn=36);
        translate([ s,  0,  0]) sphere(r=r*f, $fn=36);
        translate([-s,  0,  0]) sphere(r=r*f, $fn=36);
        translate([ 0,  s,  0]) sphere(r=r*f, $fn=36);
        translate([ 0, -s,  0]) sphere(r=r*f, $fn=36);
    }
}

module beds() {
    for (i=[0:NB-1]) {
        translate([0, 0, H*i])
        bed();
    }
}

module cuts0() {
    nb = 5;
    step = WIDTH/2;
    k = 0.6;
    for (i=[0: nb -1]) {
        translate([step, i*LENGTH/(nb) + LENGTH/nb/2, THICKNESS ])
        cut(r=step * k);
    }
    if(0)
    for (i=[0: nb -1]) {
        translate([0, i*LENGTH/(nb) + LENGTH/nb/2, THICKNESS + dh + H/2])
        cut(r=step * k);
    }
    if (0)
    translate([step, (nb-.5)*LENGTH/(nb) + LENGTH/nb/2, THICKNESS + dh + H/2])
    cut(r=step * k);

    dh = h; // H/2 - h;
    k2 = 0.67;
    dx = THICKNESS * 4;
    for (i=[-1: nb -1]) {
        translate([step *2 + dx, step + i*LENGTH/(nb) + LENGTH/nb/4 +THICKNESS*2, THICKNESS + dh])
        cut(r=step * k2);
    }
    if (0)
    for (i=[-1: nb -1]) {
        translate([step *0 - dx, step + i*LENGTH/(nb) + LENGTH/nb/4 +THICKNESS*2, THICKNESS + dh])
        cut(r=step * k2);
    }
}

module cuts() {
    for (i=[1:NB-1]) {
        translate([0, 0, H*i])
        cuts0();
    }
}

module backside() {
    translate([0, LENGTH-THICKNESS, 0]) {
        cube([WIDTH, THICKNESS, NB*H - H + h]);

        if (1)
        translate([0, 0, NB*H-H + h])
        intersection() {
            cube([WIDTH, THICKNESS, H]);
            translate([WIDTH/2, -THICKNESS, -R+h + THICKNESS])
            rotate([270, 0, 0])
            cylinder(r=R, h=THICKNESS*3);

        }
    }
}

module leftside() {
    cube([THICKNESS, LENGTH, NB*H - H + h]);
}

module base() {
    translate([0, 0, -BASE])
    difference() {
        cube([WIDTH, LENGTH, BASE+h]);
        
        translate([WIDTH/2, -THICKNESS, +R + THICKNESS+BASE - THICKNESS])
        rotate([270, 0, 0])
        cylinder(r=R, h=LENGTH+THICKNESS*3);

        if (1)
        hull() {
            translate([WIDTH/2, WIDTH/2, -BASE])
            cylinder(d=WIDTH-THICKNESS*2, h=BASE*3);
            translate([WIDTH/2, LENGTH-WIDTH/2, -BASE])
            cylinder(d=WIDTH-THICKNESS*2, h=BASE*3);
        }
    }
}

module all() {
    difference() {
        union() {
            beds();
//            backside();
//            leftside();
            base();
        }
        cuts();
    }
    leftside();
    backside();
}

translate([0, 0, LENGTH])
rotate([270, 0, 0])
all();