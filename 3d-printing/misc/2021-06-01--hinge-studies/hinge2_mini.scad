$fn                    = 45;
ATOM                   =  0.001;

HINGE2M_TOLERANCE      =  0.42; //0.42;
HINGE2M_THICKNESS      =  3.2; //3.5; //3.975;
HINGE2M_LAYER_HEIGHT   =  4.5;
HINGE2M_NB_LAYERS      =  5*0 +3;
HINGE2M_LINE_THICKNESS =  0.84;
HINGE2M_WALL_THICKNESS =  0.75;
HINGE2M_SUPPORT_D      =  0.25;

module HINGE2M_p0(h=HINGE2M_LAYER_HEIGHT, is_top=false, is_bottom=false, is_left=false, is_right=false) {
    difference() {
        intersection() {
            union() {
                // column
                if (!is_left) cylinder(d=HINGE2M_THICKNESS, h=h);
                // block
                translate([0, -HINGE2M_THICKNESS/2, 0]) cube([HINGE2M_THICKNESS*1.5-HINGE2M_TOLERANCE, HINGE2M_THICKNESS, h]);
            }
            
            // sharpen column
            translate([0, 0, -HINGE2M_THICKNESS/4]){
                d2 = h*6;
                d1 = is_bottom || is_left ? d2 : 0;
                translate([0, 0, .2])  // <== FIXME: compute
                cylinder(d1=d1, d2=d2, h=h*2);
                translate([HINGE2M_THICKNESS/2+HINGE2M_TOLERANCE, -HINGE2M_THICKNESS/2, 0]) cube([HINGE2M_THICKNESS/2*2, HINGE2M_THICKNESS, h*2]);
            }
        }

        // pin hole
        if (!is_top &&!is_left) {
            d2 = HINGE2M_THICKNESS - HINGE2M_LINE_THICKNESS;
            d1 = d2;
            hh = d2*.7;
            translate([0, 0, h-hh+ATOM]) cylinder(d1=d1, d2=d2, h=hh);
            translate([0, -d2/2, h-hh+ATOM]) cube([d2/2, d2, hh]);
            // shave 1-2 layers 
            translate([-HINGE2M_THICKNESS*1.5+HINGE2M_TOLERANCE, -HINGE2M_THICKNESS, h-HINGE2M_TOLERANCE]) cube([HINGE2M_THICKNESS*2, HINGE2M_THICKNESS*2, HINGE2M_THICKNESS]);
        }
    }
    
    // pin
    if (!is_top && !is_left) {
        d = HINGE2M_THICKNESS - HINGE2M_LINE_THICKNESS;
        dd = d - HINGE2M_TOLERANCE*3;
        hh = dd/2.5; // dd*.7 - HINGE2M_TOLERANCE -.5;

        dd2 = d - HINGE2M_TOLERANCE*1;
        hh2 = d - HINGE2M_TOLERANCE*2;

        z_adjust = .4 +.2;
        translate([0, 0, h+z_adjust-d]) cylinder(d1=0, d2=dd, h=hh);       // cone
        translate([0, 0, h+z_adjust-d + hh]) cylinder(d1=dd, d2=dd2, h=hh2);         // pillar
        //translate([0, 0, h+z_adjust-d + hh]) cylinder(d=dd, h=hh2);         // pillar
        translate([0, 0, h+z_adjust-d]) cylinder(d=HINGE2M_SUPPORT_D, h=dd/2); // support pin
    }
}

module HINGE2M_p1(h=HINGE2M_LAYER_HEIGHT, is_bottom=false, is_top=false, is_left=false, is_right=false) {
    HINGE2M_p0(h=h, is_bottom=is_bottom, is_left=is_left, is_right=is_right);
    
    if (!is_right)
        translate([HINGE2M_THICKNESS*2, 0, h]) rotate([0, 0, 180]) HINGE2M_p0(h=h, is_top=is_top);
    else 
        translate([HINGE2M_THICKNESS/2+HINGE2M_TOLERANCE, -HINGE2M_THICKNESS/2, h])
        cube([HINGE2M_THICKNESS-HINGE2M_TOLERANCE*2, HINGE2M_THICKNESS, h]);
}

module HINGE2M_p2(h=HINGE2M_LAYER_HEIGHT, extent=0,
          is_bottom=false, is_top=false, is_left=false, is_right=false) {
    difference() {
        HINGE2M_p1(h=h, is_bottom=is_bottom, is_top=is_top, is_left=is_left, is_right=is_right);
        if (is_left)
            translate([-ATOM, -HINGE2M_THICKNESS/2-ATOM, -ATOM]) cube([HINGE2M_THICKNESS/2+ATOM, HINGE2M_THICKNESS+ATOM*2, h*2+ATOM*2]);
        if (is_left)
            translate([HINGE2M_THICKNESS/2, -HINGE2M_THICKNESS, -ATOM]) cube([HINGE2M_THICKNESS/2, HINGE2M_THICKNESS*2, h*2+ATOM*2]);
        if (is_right)
            translate([HINGE2M_THICKNESS, -HINGE2M_THICKNESS, -ATOM]) cube([HINGE2M_THICKNESS/2, HINGE2M_THICKNESS*2, h*2+ATOM*2]);
    }

    if (is_left)
        translate([HINGE2M_THICKNESS-extent, -HINGE2M_THICKNESS/2, -ATOM]) cube([extent, HINGE2M_THICKNESS, h*2]);

    if (is_right)
        translate([HINGE2M_THICKNESS, -HINGE2M_THICKNESS/2, -ATOM]) cube([extent, HINGE2M_THICKNESS, h*2]);

}

module HINGE2M_cut() {
    if ($preview && false) {
        intersection() {
            d = 100;
            translate([-d/2, 0, 0]) cube(d);
            children();
        }
    }
    else children();
}

module sample(extent=0) {
    HINGE2M_cut() {
        translate([HINGE2M_THICKNESS*0, 0, 0])              HINGE2M_p2(extent=extent, is_bottom=true, is_left=true);
        translate([HINGE2M_THICKNESS*0, 0, HINGE2M_LAYER_HEIGHT*2]) HINGE2M_p2(extent=extent, is_left=true);
        translate([HINGE2M_THICKNESS*0, 0, HINGE2M_LAYER_HEIGHT*4]) HINGE2M_p2(extent=extent, is_top=true, is_left=true);

        translate([HINGE2M_THICKNESS*2, 0, 0])              HINGE2M_p2(extent=extent, is_bottom=true);
        translate([HINGE2M_THICKNESS*2, 0, HINGE2M_LAYER_HEIGHT*2]) HINGE2M_p2(extent=extent);
        translate([HINGE2M_THICKNESS*2, 0, HINGE2M_LAYER_HEIGHT*4]) HINGE2M_p2(extent=extent, is_top=true);

        translate([HINGE2M_THICKNESS*4, 0, 0])              HINGE2M_p2(extent=extent, is_bottom=true, is_right=true);
        translate([HINGE2M_THICKNESS*4, 0, HINGE2M_LAYER_HEIGHT*2]) HINGE2M_p2(extent=extent, is_right=true);
        translate([HINGE2M_THICKNESS*4, 0, HINGE2M_LAYER_HEIGHT*4]) HINGE2M_p2(extent=extent, is_top=true, is_right=true);
    }

    L = 10;
    translate([-L+HINGE2M_THICKNESS, HINGE2M_THICKNESS/2-HINGE2M_WALL_THICKNESS, 0])
    cube([L, HINGE2M_WALL_THICKNESS, HINGE2M_LAYER_HEIGHT*6]);

    translate([HINGE2M_THICKNESS*5, HINGE2M_THICKNESS/2-HINGE2M_WALL_THICKNESS, 0])
    cube([L, HINGE2M_WALL_THICKNESS, HINGE2M_LAYER_HEIGHT*6]);
}

module hinge_mini(extent=0, x_shift=0, nb_layers=HINGE2M_NB_LAYERS) {
    for (i=[0:nb_layers-1]) {
        translate([x_shift, -HINGE2M_THICKNESS/2, 0])
        rotate([0, 0, 180])
        translate([-HINGE2M_THICKNESS*2, 0, 0]) {
            translate([0, 0, HINGE2M_LAYER_HEIGHT*2*i]) HINGE2M_p2(extent=extent, is_left=true,
                                                   is_bottom=i==0, is_top=i==nb_layers-1);
        }

        translate([x_shift, -HINGE2M_THICKNESS/2, 0])
        rotate([0, 0, 180]) {
            translate([0, 0, HINGE2M_LAYER_HEIGHT*2*i]) HINGE2M_p2(extent=extent, is_right=true,
                                                   is_bottom=i==0, is_top=i==nb_layers-1);
        }
    }
}

function HINGE2M_get_hinge_thickness() = HINGE2M_THICKNESS;
function HINGE2M_get_hinge_height() = HINGE2M_NB_LAYERS * HINGE2M_LAYER_HEIGHT * 2;
echo(HINGE2M_get_hinge_height())

//scale([1.333, 1, 1])
difference() {
    hinge_mini(extent=5 *2);
    //translate([-20, -HINGE2M_THICKNESS/2, 0]) cube(40);
}

//sample(extent=5);