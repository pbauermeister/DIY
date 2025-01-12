use <hinge3.scad>

STRAP_WIDTH = 38;
CHAIN_LENGTH = 70;
THICKNESS = 6;

ATOM = .01;
PLAY = .15;

$fn = $preview ? 12 : 100;

module chain() {
    nb_layers = 3;
    nb_rings = 4;
    kx = 1.5;

    part_length = CHAIN_LENGTH/nb_rings;

    for (i=[0:nb_rings-1]) {
        translate([part_length/2 + part_length*i, 0, 0])
        rotate([0, 0, i%2==0 ? 0 : 180]) {
            scale([kx, 1, 1])
            hinge_new(nb_layers=nb_layers, layer_height=STRAP_WIDTH/nb_layers/2, thickness=THICKNESS,
                          width1=part_length/2/kx, width2=part_length/2/kx, angle2=0);
        }
    }
}

module rounded_cube(r, l, w, h) {
    hull() {
        for (x = [r, l-r])
        for (y = [r, w-r])
        for (z = [r, h-r])
            translate([x, y, z])
            sphere(r=r);
    }
}

BUCKLE_LENGTH = THICKNESS*3;
BUCKLE_MARGIN = 4;
BUCKLE_PASSAGE_THICKNESS = STRAP_WIDTH/3;

module buckle() {
    margin = BUCKLE_MARGIN;
    length = BUCKLE_LENGTH;
    passage_thickness = BUCKLE_PASSAGE_THICKNESS;

    difference() {
        union() {
            difference() {
                translate([0, -THICKNESS/2, -margin])
                rounded_cube(THICKNESS/2, length, THICKNESS, STRAP_WIDTH+2*margin);

                // slit
                translate([length/2-THICKNESS*.25, -THICKNESS, 0])
                cube([THICKNESS*.75, THICKNESS*2, STRAP_WIDTH]);
            }
            // rounding the slit
            translate([length/2+THICKNESS/2, 0, 0])
            cylinder(d=THICKNESS, h=STRAP_WIDTH);
        }

        // passage
        gap = .3;
        for (z=[-1, 1])
            translate([length/2-ATOM, -THICKNESS, STRAP_WIDTH/2-passage_thickness/2*z -gap/2])
            cube([length, THICKNESS*3, gap]);

        // cap chamber
        if(0)
        translate([length- THICKNESS*1.5, 0, 0])
        cube([THICKNESS, THICKNESS/2, STRAP_WIDTH]);
    }
    %cap();
}

module cap() {
    length = BUCKLE_LENGTH;
    passage_thickness = BUCKLE_PASSAGE_THICKNESS;

    translate([length- THICKNESS*1.5 + PLAY, PLAY, PLAY])
    cube([THICKNESS-PLAY*2, THICKNESS/2-PLAY, STRAP_WIDTH - PLAY*2]);

    hull() {
        for (x=[length- THICKNESS*1.5, length- THICKNESS/2])
            translate([x, 0, STRAP_WIDTH/2-passage_thickness/2])
            cylinder(d=THICKNESS, h=passage_thickness);
    }
}


chain();

translate([CHAIN_LENGTH - THICKNESS/2, 0, 0])
buckle();

translate([0, 0, -BUCKLE_MARGIN])
translate([CHAIN_LENGTH, THICKNESS*2, 0])
rotate([270, 0, 90])
translate([-BUCKLE_LENGTH*.75, -THICKNESS/2, -STRAP_WIDTH/2])
cap();

translate([CHAIN_LENGTH+THICKNESS*.75, THICKNESS*1.5, 0])
%cube([10, 10, 10]);