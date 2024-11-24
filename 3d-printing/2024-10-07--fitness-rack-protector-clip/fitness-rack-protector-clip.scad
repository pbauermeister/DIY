TOLERANCE            = 1.3;
POLE_SIDE            = 60 + TOLERANCE;
POLE_CORDNER_RADIUS  =  2;

PLANK_WIDTH          = 80;
SPACING              = 12;
BLOCK_CORDNER_RADIUS = 3;

HEIGHT               = 60*0 + 40;
WIDTH                = PLANK_WIDTH - 6;
HOOK                 = 10;
HOOK_RATCHET         =  4;
X                    = (POLE_SIDE-WIDTH) / 2;

$fn = $preview ? 8 : 16/2;
ATOM = 0.01;


module rounded_cube(x, y, z, r, extra_r=0) {
hull()
for (x=[r, x-r])
    for (y=[r, y-r])
        for (z=[r, z-r])
        translate([x, y, z])
            sphere(r=r+extra_r);
}

module pole_section(r=POLE_CORDNER_RADIUS, extra_r=0) {
    translate([0, 0, -POLE_SIDE])
    rounded_cube(POLE_SIDE, POLE_SIDE, POLE_SIDE*3, r, extra_r);
}

module block() {
    r = BLOCK_CORDNER_RADIUS;
    minkowski() {
        difference() {
            r2 = r*2;
            translate([X+r, -SPACING+r, r])
            cube([WIDTH-r2, POLE_SIDE+SPACING+HOOK -r2, HEIGHT-r2]);

            // back opening, forming hook
            translate([POLE_SIDE/2, POLE_SIDE/2 + POLE_SIDE*sqrt(2)/2 + HOOK_RATCHET, 0])
            rotate([0, 0, 45])
            cube([POLE_SIDE, POLE_SIDE, POLE_SIDE*3], center=true);
  
            pole_section(POLE_CORDNER_RADIUS, POLE_CORDNER_RADIUS);

            }
        sphere(r=r);
    }
}

module screw_hole(diameter, head) {
    fn = 90;
    length = 50;
    rotate([90, 0, 0]) {
        translate([0, 0, ATOM -length]) cylinder(d=diameter, h=length, $fn=fn);
        cylinder(d=head, h=length, $fn=fn);

        th = .1;
        for (a=[0:10:360]) {
            rotate([0, 0, a])
            translate([0, -th/2, ATOM -length])
            cube([diameter*1, th, length]);
        }
    }
}

module clip() {
    difference() {
        block();

        // screws
        for (i=[-1, 1]) {
            x = POLE_SIDE/2 + i*POLE_SIDE*.25;
            z = HEIGHT/2 + i*HEIGHT*.25;
            translate([x, -SPACING+6, z])
            rotate([0, 0, 180])
            screw_hole(4, 9);
        }
        
        // central hole
        translate([POLE_SIDE/2, 0, HEIGHT/2])
        rotate([90, 0, 0])
        cylinder(d=14.5, h=SPACING*3, $fn=100, center=true);

        // re-remove pole
        pole_section();
    }
}

intersection() {
    clip();
    %pole_section();

//    cylinder(r=500, h=5);
}