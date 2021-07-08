$fn = 30;

HEIGHT = 40;
DIAMETER = 6;
WALL_THICKNESS = .8;
TOLERANCE = .3;

INNER_DIAMETER = DIAMETER - WALL_THICKNESS * 2;

module body_ext() {
    color("grey") {

        cylinder(d=DIAMETER, h=HEIGHT*.85);

        translate([0, 0, HEIGHT*.85])
        cylinder(d1=DIAMETER*.6, d2=DIAMETER*.25, h=HEIGHT*.15);

        hull() {
            translate([-DIAMETER*.3, 0, 0]) cylinder(d=DIAMETER+.2, h=1);
            translate([ DIAMETER*.3, 0, 0]) cylinder(d=DIAMETER+.2, h=1);
        }
    }
}

module body() {
    difference() {
        difference() {
            body_ext();

            hull() {
                cylinder(d=INNER_DIAMETER, h=1);
                translate([0, 0, HEIGHT*.8 - DIAMETER/2 ])
                sphere(d=INNER_DIAMETER);
            }
                
            cylinder(d=.6, h=HEIGHT);
        }
    }
}

module piston() {
    d = INNER_DIAMETER - TOLERANCE*2;
    d2 = d -.4;
    d3 = d+.5;

    cylinder(d=d2, h=HEIGHT);

    h = HEIGHT;
    translate([0, 0, h-2]) cylinder(d=d, h=2);
    translate([0, 0, h-1 ]) resize([d3, d3, d/3]) sphere();
    translate([0, 0, h-2-DIAMETER/2]) cylinder(d1=0, d2=d, h=DIAMETER/2);

    h2 = HEIGHT *.5;
    translate([0, 0, h2-2]) cylinder(d=d, h=2);
    translate([0, 0, h2-1 ]) resize([d3, d3, d/3]) sphere();
    translate([0, 0, h2-2-DIAMETER/2]) cylinder(d1=0, d2=d, h=DIAMETER/2);


    cylinder(d=DIAMETER*1.3, h=1);
}

difference() {
    body();
    //cube(HEIGHT*2);
}

translate([DIAMETER*3, 0, 0])
piston();