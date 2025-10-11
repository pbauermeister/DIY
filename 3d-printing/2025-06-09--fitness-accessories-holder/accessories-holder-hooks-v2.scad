D  =  12;
L  = 110 + 20;
H  =  30 + 10;
W  = 6 + 30+.15+.5;


DX = D*16/12 * .85;
K  = .8;

ATOM = 0.01;

$fn = $preview? 10 : 160;

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

module hook(h=H) {
    d = D; //12;
    th = 2;
    w = d/4;
    
    // pillar
    scale([K, 1, 1])
    cylinder(d=d, h=H);

    // finger
    scale([K, 1, 1])
    hull() {
        translate([0, 0, H])
        sphere(d=d);

        translate([0, w, H+w])
        rotate([-45, 0, 0])
        translate([0, 0, d/4/4*0 -d/8])
        //cylinder(d=d, h=.01, center=!true);
        sphere(d=d);
    }
    
    // reinforcement
    y = W-D/2;
    hull() {
        scale([K, 1, 1]) {
            translate([0, 0, H]) sphere(d=d);
            cylinder(d=d, h=H);
        }

        intersection() {
            translate([0, 0, -D/4])
            translate([-th/2, 0, H+D/2*1.38])
            rotate([-45*3, 0, 0])
            cube([th, H*2, H*2]);
     
            translate([-th, -y, 0])
            cube([th*2, y, H*2]);
        }
    }
}

module gripper() {
    intersection() {
        plate(h1=1, h2=1, recess=2);
        for (y=[-D/2:-5:-30])
            translate([0, y+1, 0])
            rotate([45, 0, 0])
            cube([L*3, 2, 2], center=true);
    }
}

module _plate(h1=D/2, h2=2, recess=0) {
    d = .5;
    y = -W+D-d;
    difference() {
        hull() {
            translate([-DX, 0, 0])
            scale([K, 1, 1])
            cylinder(d=D-recess*2, h=h1);

            translate([-DX-d, y, 0])
            scale([K, 1, 1])
            cylinder(d=D-recess*2 -d*2, h=h2);

            translate([L+DX, 0, 0])
            scale([K, 1, 1])
            cylinder(d=D-recess*2, h=h1);

            translate([L+DX+d, y, 0])
            scale([K, 1, 1])
            cylinder(d=D-recess*2 -d*2, h=h2);
        }
        // screw holes
        for (x=[0, L])
            translate([x, 0, 0])
            screw(head_d=10, z=5.5);
    }
}

module hooks() {
    n = 3;
    dx = L/(n-1);

    // hooks
    for (x=[0:dx:L])
        translate([x-DX, 0, 0])
        hook();
    for (x=[0:dx:L])
        translate([x+DX, 0, 0])
        hook();
}

module plate() {
    hull()
    intersection() {
        hooks();

        translate([-L/2, D/1.7, 0])
        rotate([5, 0, 0])
        translate([-L/2, -W*2, 0])
        cube([L*3, W*2, D/2]);
    }
}


module all() {
    difference() {
        n = 3;
        dx = L/(n-1);

        union() {
            // plate
            plate();

            // hooks
            hooks();
        }
        if(0)translate([0, 0, -ATOM])
        gripper();
    }
}

//rotate([90, 0, 0])
all();
//plate2();