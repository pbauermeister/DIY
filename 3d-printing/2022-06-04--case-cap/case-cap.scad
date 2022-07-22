

WIDTH  = 20.6;
LENGTH = 28.2;
HEIGHT = 30;

R = 7;
THICKNESS= 3;
ATOM = 0.001;

$fn = 90;

module pillar(shorten=0) {
    hull() {
        translate([ WIDTH/2-R,  LENGTH/2-R]) cylinder(r=R, h=HEIGHT-shorten);
        translate([-WIDTH/2+R,  LENGTH/2-R]) cylinder(r=R, h=HEIGHT-shorten);
        translate([-WIDTH/2+R, -LENGTH/2+R]) cylinder(r=R, h=HEIGHT-shorten);
        translate([ WIDTH/2-R, -LENGTH/2+R]) cylinder(r=R, h=HEIGHT-shorten);
    }
}

module body() {
    minkowski() {
        pillar();
        cylinder(r=THICKNESS, h=THICKNESS);
    }
}
module chamferer() {
    minkowski() {
        pillar();
        cylinder(h=THICKNESS*2, r2=THICKNESS, r1=0);
    }    
}

module shaver() {
    minkowski() {
        translate([0, 0, THICKNESS])
        pillar(shorten=THICKNESS +1);
        sphere(r=.15);
    }
}

difference() {
    body();
    
    translate([0, 0, THICKNESS+ATOM]) pillar();
    translate([0, 0, HEIGHT+THICKNESS*.15]) chamferer();

    cube([THICKNESS, LENGTH-WIDTH + THICKNESS, THICKNESS*4], center=true);
    shaver();
    
    //cube(1000);
    //translate([0, 0, -THICKNESS]) cube(HEIGHT*2, center=true);
}

