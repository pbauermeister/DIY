D  =  12 *0 +9;
L  = 110 + 20;
H  =  30 + 10;
W  = 6 + 30+.15+.5;


DX = D*16/12 * .85 *12/9;
K  = .8+.2;

ATOM = 0.01;

$fn = $preview? 12 : 160;

module screw(d=5.5, head_d=16, z=10) {
    translate([0, 0, -1])
    cylinder(d=d, h=100);

    translate([0, 0, z])
    cylinder(d=head_d, h=100);

    for (d=[d:1.25:head_d]) {
        difference() {
            translate([0, 0, -1+.5])
            cylinder(d=d, h=z+1);

            translate([0, 0, -2+.5])
            cylinder(d=d-.1, h=z+2);
        }
    }
}

module hook() {
    d = D; //12;
    th = 2;
    w = d/4;
    h = (H-W+D) * 1.5;
    y = -W+D/2 + th/2;
    
    hull() {
        cylinder(d=d, h=H);
        translate([-th/2, y-th/2, 0]) cube([th, th, h]);
    }

    hull() {
        translate([0, 0, H]) cylinder(d=d, h=ATOM);    
        translate([0, d/4, H+d/4]) sphere(d=d);
        translate([-th/2, y-th/2, 0]) cube([th, th, h]);
    }

}

module hooks() {
    n = 3;
    dx = L/(n-1);

    // hooks
    for (x=[0:dx:L]) {
        translate([x-DX, 0, 0])
        hook();
    }
    for (x=[0:dx:L]) {
        translate([x+DX, 0, 0])
        hook();
    }
}

module plate() {
    difference() {
        hull()
        intersection() {
            hooks();

            translate([-L/2, D/1.7, 0])
            rotate([8, 0, 0])
            translate([-L/2, -W*2, 0])
            cube([L*3, W*2, D*.85]);
        }
   
        translate([0, 0, 5.5])
        cylinder(r=1000, h=H);
    }
}


module all() {
    // hooks
    hooks();

    difference() {
        // plate
        plate();

        // screw holes
        for (x=[0, L])
            translate([x, 0 -D/4, 0])
            screw(head_d=10, z=4.5);
    }
}

rotate([90, 0, 0])
all();

translate([-18.5, 0, 0])
%cube([167, 20, 5]);