use <hinge.scad>; 

LENGTH       = 175 - 15;
HEIGHT       = 160;
THICKNESS    = 1.25;
FLAP_LENGTH  = LENGTH/2; //70;
LAYER_HEIGHT =  7; //9.9;

HINGE_THICKNESS = get_hinge_thickness();

h = get_hinge_height(nb_layers=1, layer_height=LAYER_HEIGHT);
N = floor(HEIGHT/h) + 1;

module cache_hinge() {
    intersection() {
        translate([HINGE_THICKNESS/2, 0, 0])
        hinge(nb_layers=N, extent=1, layer_height=LAYER_HEIGHT);
        cube(HEIGHT*2, center=true);
    }
}

module cache_hinge2() {
    intersection() {
        translate([HINGE_THICKNESS/2, 0, 0])
        hinge2(nb_layers=N, extent=1, layer_height=LAYER_HEIGHT);
        cube(HEIGHT*2, center=true);
    }
}

module flap() {
    dy = 1 + HINGE_THICKNESS;
    
    difference() {
        cube([THICKNESS, FLAP_LENGTH+dy, HEIGHT]);

        translate([-1, -1, HEIGHT])
        rotate([-37, 0, 0])
        cube(FLAP_LENGTH*2);
    }
}

module cache_v1() {
    dy = 2 + HINGE_THICKNESS;

    cube([THICKNESS, LENGTH/2, HEIGHT]);
    cache_hinge();
    translate([HINGE_THICKNESS+THICKNESS, -dy, 0]) flap();
    translate([-2, LENGTH/2 + HINGE_THICKNESS+.5, 0]) rotate([0, 0, -90]) cache_hinge2();
    translate([-HINGE_THICKNESS-THICKNESS, 0, 0]) cube([THICKNESS, LENGTH/2, HEIGHT]);
    translate([-HINGE_THICKNESS, 0, 0]) scale([-1, 1, 1]) cache_hinge();
    translate([-HINGE_THICKNESS*2 - THICKNESS*2, -dy, 0]) flap();
}

module cache_v2() {
    dy = 2 + HINGE_THICKNESS;

    cube([THICKNESS, LENGTH, HEIGHT]);
    cache_hinge();
    translate([HINGE_THICKNESS+THICKNESS + THICKNESS/2, -dy, 0]) flap();

    translate([0, HEIGHT, 0]) scale([1, -1, 1]) cache_hinge();

    translate([HINGE_THICKNESS+THICKNESS + THICKNESS/2, HEIGHT + HINGE_THICKNESS+2, 0])
    scale([1, -1, 1]) flap();


/*
    translate([-2, LENGTH/2 + HINGE_THICKNESS+.5, 0]) rotate([0, 0, -90]) cache_hinge2();
    translate([-HINGE_THICKNESS-THICKNESS, 0, 0]) cube([THICKNESS, LENGTH/2, HEIGHT]);
    translate([-HINGE_THICKNESS, 0, 0]) scale([-1, 1, 1]) cache_hinge();
    translate([-HINGE_THICKNESS*2 - THICKNESS*2, -dy, 0]) flap();
*/
}

intersection() {
    cache_v2();
    //cylinder(r=LENGTH, h=13.5);
}
