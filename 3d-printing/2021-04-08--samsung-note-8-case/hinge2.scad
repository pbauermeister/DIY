$fn            = 45;
TOLERANCE      =  0.15       + 0.07;
ATOM           =  0.001;
THICKNESS      =  2.00       + 1.25 +.1       +0.7    -.3                 +0.15;
LAYER_HEIGHT   =               4.55 *0 + 11                        +1.1   -2.2;
LINE_THICKNESS =  0.80       + 0.04; // <== TUNE for a 1-line wall
WALL_THICKNESS =  0.75;
SUPPORT_D      =  0.50;


module p0(h=LAYER_HEIGHT, is_top=false, is_bottom=false, is_left=false, is_right=false) {
    difference() {
        intersection() {
            union() {
                // column
                if (!is_left) cylinder(d=THICKNESS, h=h);
                // block
                translate([0, -THICKNESS/2, 0]) cube([THICKNESS*1.5-TOLERANCE, THICKNESS, h]);
            }
            
            // sharpen column
            translate([0, 0, -THICKNESS/4]){
                d2 = h*6;
                d1 = is_bottom || is_left ? d2 : 0;
                translate([0, 0, .2])  // <== FIXME: compute
                cylinder(d1=d1, d2=d2, h=h*2);
                translate([THICKNESS/2+TOLERANCE, -THICKNESS/2, 0]) cube([THICKNESS/2*2, THICKNESS, h*2]);
            }
        }

        // pin hole
        if (!is_top &&!is_left) {
            d2 = THICKNESS - LINE_THICKNESS;
            d1 = d2;
            hh = d2*.7;
            translate([0, 0, h-hh+ATOM]) cylinder(d1=d1, d2=d2, h=hh);
            translate([0, -d2/2, h-hh+ATOM]) cube([d2/2, d2, hh]);
            // shave 1-2 layers 
            translate([-THICKNESS*1.5+TOLERANCE, -THICKNESS, h-TOLERANCE]) cube([THICKNESS*2, THICKNESS*2, THICKNESS]);
        }
    }
    
    // pin
    if (!is_top && !is_left) {
        d = THICKNESS - LINE_THICKNESS;
        dd = d - TOLERANCE*2;
        hh = dd*.7 - TOLERANCE -.5;
        z_adjust = .4 +.2; //+.3  -.1;
        translate([0, 0, h+z_adjust-d]) cylinder(d1=0, d2=dd, h=hh);
        translate([0, 0, h+z_adjust-d +hh]) cylinder(d=dd, h=dd);
        translate([0, 0, h+z_adjust-d]) cylinder(d=SUPPORT_D, h=dd/2); // support pin
    }
}

module p1(h=LAYER_HEIGHT, is_bottom=false, is_top=false, is_left=false, is_right=false) {
    p0(h=h, is_bottom=is_bottom, is_left=is_left, is_right=is_right);
    
    if (!is_right)
        translate([THICKNESS*2, 0, h]) rotate([0, 0, 180]) p0(h=h, is_top=is_top);
    else 
        translate([THICKNESS/2+TOLERANCE, -THICKNESS/2, h])
        cube([THICKNESS-TOLERANCE*2, THICKNESS, h]);
}

module p2(h=LAYER_HEIGHT, extent=0,
          is_bottom=false, is_top=false, is_left=false, is_right=false) {
    difference() {
        p1(h=h, is_bottom=is_bottom, is_top=is_top, is_left=is_left, is_right=is_right);
        if (is_left)
            translate([-ATOM, -THICKNESS/2-ATOM, -ATOM]) cube([THICKNESS/2+ATOM, THICKNESS+ATOM*2, h*2+ATOM*2]);
        if (is_left)
            translate([THICKNESS/2, -THICKNESS, -ATOM]) cube([THICKNESS/2, THICKNESS*2, h*2+ATOM*2]);
        if (is_right)
            translate([THICKNESS, -THICKNESS, -ATOM]) cube([THICKNESS/2, THICKNESS*2, h*2+ATOM*2]);
    }

    if (is_left)
        translate([THICKNESS-extent, -THICKNESS/2, -ATOM]) cube([extent, THICKNESS, h*2]);

    if (is_right)
        translate([THICKNESS, -THICKNESS/2, -ATOM]) cube([extent, THICKNESS, h*2]);

}

module cut() {
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
    cut() {
        translate([THICKNESS*0, 0, 0])              p2(extent=extent, is_bottom=true, is_left=true);
        translate([THICKNESS*0, 0, LAYER_HEIGHT*2]) p2(extent=extent, is_left=true);
        translate([THICKNESS*0, 0, LAYER_HEIGHT*4]) p2(extent=extent, is_top=true, is_left=true);

        translate([THICKNESS*2, 0, 0])              p2(extent=extent, is_bottom=true);
        translate([THICKNESS*2, 0, LAYER_HEIGHT*2]) p2(extent=extent);
        translate([THICKNESS*2, 0, LAYER_HEIGHT*4]) p2(extent=extent, is_top=true);

        translate([THICKNESS*4, 0, 0])              p2(extent=extent, is_bottom=true, is_right=true);
        translate([THICKNESS*4, 0, LAYER_HEIGHT*2]) p2(extent=extent, is_right=true);
        translate([THICKNESS*4, 0, LAYER_HEIGHT*4]) p2(extent=extent, is_top=true, is_right=true);
    }

    L = 10;
    translate([-L+THICKNESS, THICKNESS/2-WALL_THICKNESS, 0])
    cube([L, WALL_THICKNESS, LAYER_HEIGHT*6]);

    translate([THICKNESS*5, THICKNESS/2-WALL_THICKNESS, 0])
    cube([L, WALL_THICKNESS, LAYER_HEIGHT*6]);
}

module hinge(extent=0, x_shift=0, nb_layers=4) {
    for (i=[0:nb_layers-1]) {
        translate([x_shift, -THICKNESS, 0])
        rotate([0, 0, 180])
        translate([-THICKNESS*2, 0, 0]) {
//            translate([0, 0, 0])              p2(extent=extent, is_bottom=true, is_left=true);
//            translate([0, 0, LAYER_HEIGHT*2]) p2(extent=extent, is_left=true);
//            translate([0, 0, LAYER_HEIGHT*4]) p2(extent=extent, is_top=true, is_left=true);
            translate([0, 0, LAYER_HEIGHT*2*i]) p2(extent=extent, is_left=true,
                                                   is_bottom=i==0, is_top=i==nb_layers-1);
        }

        translate([x_shift, -THICKNESS, 0])
        rotate([0, 0, 90]) {
//            translate([0, 0, 0])              p2(extent=extent, is_bottom=true);
//            translate([0, 0, LAYER_HEIGHT*2]) p2(extent=extent);
//            translate([0, 0, LAYER_HEIGHT*4]) p2(extent=extent, is_top=true);
            translate([0, 0, LAYER_HEIGHT*2*i]) p2(extent=extent,
                                                   is_bottom=i==0, is_top=i==nb_layers-1);
        }

        translate([x_shift, THICKNESS, 0]) {
//            translate([0, 0, 0])              p2(extent=extent, is_bottom=true, is_right=true);
//            translate([0, 0, LAYER_HEIGHT*2]) p2(extent=extent, is_right=true);
//            translate([0, 0, LAYER_HEIGHT*4]) p2(extent=extent, is_top=true, is_right=true);
            translate([0, 0, LAYER_HEIGHT*2*i]) p2(extent=extent, is_right=true,
                                                   is_bottom=i==0, is_top=i==nb_layers-1);
        }
    }
}

function get_hinge_thickness() = THICKNESS;

hinge(extent=5);
//sample(extent=5);