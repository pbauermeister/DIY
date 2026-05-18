$fn            = $preview ? 8 : 45;
TOLERANCE      =  0.42;
THICKNESS      =  3.975;
LAYER_HEIGHT   =  10;
LINE_THICKNESS =  0.84 +0.26; // <== TUNE for a 1-line wall
WALL_THICKNESS =  0.75;
SUPPORT_D      =  0.50;

//                   V2.0   V2.1
HINGE_EXTRA_LENGTH = 1.2  - 1.2;

// Hole in hinge for steel pin:
PIN_D          =  1.75;
PIN_HEIGHT_K   =  4.65;

ATOM           =  0.001;
TOLERANCE2     = TOLERANCE +.5 /5;

module p0_new(h=LAYER_HEIGHT,
              is_top=false, is_bottom=false,
              is_left=false, is_right=false,
              extra_length=0) {
    k = 1.25;
    tk = .25 + .3 +.2;

    difference() {
        intersection() {
            union() {
                // column
                if (!is_left)
                    //cylinder(d=THICKNESS, h=h);
                    //scale([1, sqrt(2), 1])
                    cylinder(d=THICKNESS, h=h); //, $fn=6);

                // block
                translate([0, -THICKNESS/2, 0])
                cube([THICKNESS*1.5-TOLERANCE2+extra_length, THICKNESS, h]);
            }
        }

        // shave 1-2 layers
        if (!is_top && !is_left) {
            translate([-THICKNESS*1.5+TOLERANCE2, -THICKNESS, h-TOLERANCE])
            cube([THICKNESS*2, THICKNESS*2, THICKNESS]);
        }

        // spike, inward
        if (!is_right) {
            translate([0, 0, -TOLERANCE*(1-tk)])
            cylinder(d1=THICKNESS, d2=0, h=THICKNESS/2 * k);

            if (!is_top)
                translate([0, 0, h-THICKNESS/2*k - TOLERANCE*tk])
                cylinder(d2=THICKNESS, d1=0, h=THICKNESS/2*k);
        }
    }

    // spike, outward
    if (is_right) {
        translate([0, 0, h - TOLERANCE - TOLERANCE*tk])
        cylinder(d1=THICKNESS, d2=0, h=THICKNESS/2*k);

        if (!is_bottom)
            translate([0, 0, -THICKNESS/2*k + TOLERANCE*tk])
            cylinder(d2=THICKNESS, d1=0, h=THICKNESS/2*k);
    }

}

module p1_new(h=LAYER_HEIGHT,
              is_bottom=false, is_top=false,
              is_left=false, is_right=false,
              extra_length=0) {
    translate([-extra_length, 0, 0])
    p0_new(h=h, is_bottom=is_bottom, is_left=is_left, is_right=is_right, extra_length=extra_length);

    if (!is_right) {
        translate([THICKNESS*2, 0, h]) rotate([0, 0, 180])
        p0_new(h=h, is_top=is_top, extra_length=extra_length);
    }
    else {
        translate([THICKNESS/2+TOLERANCE2, -THICKNESS/2, h])
        cube([THICKNESS-TOLERANCE2*2, THICKNESS, h]);
    }
}

module p2_new(h=LAYER_HEIGHT, extent=0, thickness=THICKNESS,
              is_bottom=false, is_top=false,
              is_left=false, is_right=false) {
    k = thickness / THICKNESS;

    difference() {
        scale([k, k, 1])
        p1_new(h=h, is_bottom=is_bottom, is_top=is_top, is_left=is_left, is_right=is_right);

        if (is_left)
            translate([-ATOM, -thickness/2-ATOM, -ATOM])
            cube([thickness/2+ATOM, thickness+ATOM*2, h*2+ATOM*2]);

        if (is_left)
            translate([thickness/2, -thickness, -ATOM])
            cube([thickness/2, thickness*2, h*2+ATOM*2]);

        if (is_right)
            translate([thickness, -thickness, -ATOM])
            cube([thickness/2, thickness*2, h*2+ATOM*2]);
    }

    if (is_left)
        translate([thickness-extent, -thickness/2, -ATOM])
        cube([extent, thickness, h*2]);

    if (is_right)
        translate([thickness, -thickness/2, -ATOM])
        cube([extent, thickness, h*2]);
}

////////////////////////////////////////////////////////////////////////////////

module hinge_new(nb_layers=4, layer_height=LAYER_HEIGHT,
             layer_imbalance=0,
             thickness=THICKNESS,
             width1=THICKNESS, shave_bottom1=0, shave_top1=0,
             width2=THICKNESS, shave_bottom2=0, shave_top2=0, angle2=0,
             only_axis=false,
             part1=true, part2=true
             ) {

    height = nb_layers * layer_height *2;

    if (only_axis) {
        cylinder(d=thickness+thickness/2, h=height);
    }
    else {
        // left half-side
        if (part1)
        intersection() {
            for (i=[0:nb_layers-1]) {
                rotate([0, 0, -180])
                translate([0, 0, layer_height*2*i]) {
                    p2_new(h=layer_height-layer_imbalance, thickness=thickness,
                           extent=width1-thickness,
                           is_right=true, is_bottom=i==0, is_top=i==nb_layers-1);
                    translate([thickness/2+TOLERANCE2, -thickness/2, 0])
                    cube([width1-thickness/2-TOLERANCE2, thickness,
                          layer_height*2]);
                }
            }
            // bounding box
            if (shave_bottom1==0) {
                translate([-width1, -thickness/2, 0])
                cube([width1+thickness/2, thickness, height-shave_top1]);
            }
            else hull() {
                dz = thickness+shave_bottom1;
                translate([-width1, -thickness/2, dz])
                cube([width1+thickness/2, thickness, height-dz-shave_top1]);

                translate([0, 0, thickness/2+shave_bottom1])
                sphere(d=thickness);

                translate([-width1, 0, thickness/2 + shave_bottom1])
                rotate([0, 90, 0])
                cylinder(d=thickness, h=ATOM);
            }
        }

        // right half-side
        if (part2)
        rotate([0, 0, angle2])
        intersection() {
            for (i=[0:nb_layers-1]) {
                rotate([0, 0, 180])
                translate([-thickness*2, 0, 0])
                translate([0, 0, layer_height*2*i - layer_imbalance*2]) {
                    p2_new(h=layer_height+layer_imbalance, thickness=thickness,
                           extent=width2-thickness,
                       is_left=true, is_bottom=i==0, is_top=i==nb_layers-1);
                    translate([-thickness, -thickness/2, layer_imbalance*2])
                    cube([width2-thickness/2-TOLERANCE2, thickness,
                          layer_height*2]);
                }
            }

            // bounding box
            if (shave_bottom2==0) {
                translate([-thickness/2, -thickness/2, 0])
                cube([width2+thickness/2, thickness, height-shave_top2]);
            } else union(){
                dz = thickness/2+shave_bottom2;
                translate([-thickness/2, -thickness/2, dz])
                cube([width2+thickness/2, thickness, height-dz-shave_top2]);
                translate([0, 0, thickness/2+shave_bottom2])
                rotate([0, 90, 0])
                cylinder(d=thickness, h=width2);
            }
        }
    }
}

module __hinge_new(nb_layers=4, layer_height=LAYER_HEIGHT,
             layer_imbalance=0,
             thickness=THICKNESS,
             width1=THICKNESS, shave_bottom1=0, shave_top1=0,
             width2=THICKNESS, shave_bottom2=0, shave_top2=0, angle2=0,
             only_axis=false,
             part1=true, part2=true) {
    difference() {
        hinge_new0(
            nb_layers, layer_height,
            layer_imbalance,
            thickness,
            width1, shave_bottom1, shave_top1,
            width2, shave_bottom2, shave_top2, angle2,
            only_axis);
    }
}


//!hinge_new();
//!hinge_new(shave_bottom1=1);
//!hinge_new(shave_bottom2=1);
//!hinge_new(layer_imbalance=3);
//!hinge_new(shave_top1=1);
//!hinge_new(shave_bottom1=1, shave_top1=1);

////////////////////////////////////////////////////////////////////////////////

function get_hinge_thickness() = THICKNESS;

function get_hinge_height(nb_layers=3,
                          layer_height=LAYER_HEIGHT) = layer_height*2*nb_layers;

////////////////////////////////////////////////////////////////////////////////
// Main hinge

module main_hinge0(open=false, th=4.5, right=true, mid=true, left=true) {
    z = -14.25  + .9;
    n =   9     + 1;
    w1 =  5;
    w2 = 10;
    h =  8.86;;
    ph = h*5.5;

    translate([0, th, z])
    rotate([0, 0, open ? -90 : 180]) difference(){
        hinge_new(nb_layers=n, layer_height=h, thickness=th,
                  width1=w2, width2=w1, angle2=open ? 0: 90,
                  part1=right, part2=mid);
    }

    translate([0, -th, z])
    rotate([0, 0,  open ? 90 : 180]) difference() {
        hinge_new(nb_layers=n, layer_height=h, thickness=th,
                  width1=w2, width2=w1, angle2=open ? 0 : -90,
                  part2=mid, part1=left);
    }
}


module main_hinge(open=false, th=4.5, right=true, mid=true, left=true) {
    rotate([0, 0, open ? -90 : 0])
    translate([0, -th, 0])
    main_hinge0(open, th=th, right=right, mid=mid, left=left);
}

////////////////////////////////////////////////////////////////////////////////
// Flap hinge

LID_SPACING                =  0.15;
SPACING                    =  0.3;

FLAP_NB_LAYERS             =  8;
FLAP_Z_POS                 = 10;
FLAP_X_ADJUST              =  0;
FLAP_EXTEND_ADJUST         = -7;
FLAP_HEIGHT                =  7.25*6 + LID_SPACING*1.5;
FLAP_LAYER_HEIGHT          = FLAP_HEIGHT/FLAP_NB_LAYERS;

module flap_hinge0(flap_height=FLAP_HEIGHT, nb_layers=FLAP_NB_LAYERS,
                   thickness=THICKNESS, only_axis=false) {
    layer_height = flap_height/nb_layers/2;

    translate([0, 0, -LID_SPACING])
    hinge_new(nb_layers=nb_layers, layer_height=layer_height,
              shave_bottom1 = SPACING,
              shave_top1 = SPACING,
              thickness=thickness,
              only_axis=only_axis);
}

////////////////////////////////////////////////////////////////////////////////

CAM_LAYER_HEIGHT = 5.04;
CAM_NB_LAYERS = 5 * 2;
CAM_HEIGHT = CAM_NB_LAYERS * CAM_LAYER_HEIGHT * 2;

module maybe_hull(use_hull=false) {
    if (use_hull) hull() children();
    else children();
}

module camera_hinge(nb_layers=CAM_NB_LAYERS, height=CAM_HEIGHT, thickness=4,
                    extra_spacing=1, only_axis=false)
{
    maybe_hull(only_axis) {
        hinge_new(nb_layers=nb_layers, layer_height=height/2/nb_layers,
                  //shave_bottom2=SPACING, shave_top2=SPACING,
                  width1=thickness*1.5 +5,
                  width2=thickness*.75 + extra_spacing,
                  thickness=thickness,
                  only_axis=only_axis);


        translate([thickness*1.5 + extra_spacing, 0, 0])
        rotate([0, 0, 180])
        hinge_new(nb_layers=nb_layers, layer_height=height/2/nb_layers,
                  //shave_bottom1=SPACING, shave_top1=SPACING,
                  width1=thickness*1.5 +5,
                  //shave_bottom2 = SPACING, shave_top2 = SPACING,
                  width2=thickness*.75 + extra_spacing,
                  thickness=thickness,
                  only_axis=only_axis);
    }
}

////////////////////////////////////////////////////////////////////////////////

module basic_test() {
    difference() {
        hinge_new(nb_layers=2, layer_height=9.1, thickness=4,
              width1=5, width2=5, angle2=-90);
        cube(50);
    }
}

module test_hinge() {
    z = -14.25  + .9;
    n =   2;
    w1 =  5;
    w2 = 10;
    th =  4.5;
    h =  10     - .9;
    translate([-4.0, th, z])
    rotate([0, 0, -90])
    hinge_new(nb_layers=n, layer_height=h, thickness=th,
              width1=w2, width2=w1, angle2=90*0);

    translate([-4.0, -th, z])
    rotate([0, 0,  90])
    hinge_new(nb_layers=n, layer_height=h, thickness=th,
              width1=w2, width2=w1, angle2=-90*0);
}

////////////////////////////////////////////////////////////////////////////////

!basic_test();
//!rotate([0, 90, 0]) test_hinge();

//translate([4.0, 4.5, 0])
main_hinge();
//flap_hinge0(only_axis=true);

//camera_hinge();
//%camera_hinge(only_axis=true);
