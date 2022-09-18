$fn            = 45;
TOLERANCE      =  0.42;
THICKNESS      =  3.975;
LAYER_HEIGHT   =  9.9;
LINE_THICKNESS =  0.84; // <== TUNE for a 1-line wall
WALL_THICKNESS =  0.75;
SUPPORT_D      =  0.50;

ATOM           =  0.001;
TOLERANCE2     = TOLERANCE +.5 /5;

module p0(h=LAYER_HEIGHT, is_top=false, is_bottom=false, is_left=false, is_right=false) {
    difference() {
        intersection() {
            union() {
                // column
                if (!is_left) cylinder(d=THICKNESS, h=h);
                // block
                translate([0, -THICKNESS/2, 0]) cube([THICKNESS*1.5-TOLERANCE2, THICKNESS, h]);
            }
            
            // sharpen column
            translate([0, 0, -THICKNESS/4]){
                d2 = h*6;
                d1 = is_bottom || is_left ? d2 : 0;
                translate([0, 0, .2])  // <== FIXME: compute
                cylinder(d1=d1, d2=d2, h=h*2);
                translate([THICKNESS/2+TOLERANCE2, -THICKNESS/2, 0]) cube([THICKNESS/2*2, THICKNESS, h*2]);
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
            translate([-THICKNESS*1.5+TOLERANCE2, -THICKNESS, h-TOLERANCE]) cube([THICKNESS*2, THICKNESS*2, THICKNESS]);
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
        translate([THICKNESS/2+TOLERANCE2, -THICKNESS/2, h])
        cube([THICKNESS-TOLERANCE2*2, THICKNESS, h]);
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

module hinge(extent=0, x_shift=0, nb_layers=4, layer_height=LAYER_HEIGHT, flat=false) {
    for (i=[0:nb_layers-1]) {
        translate([x_shift, -THICKNESS, 0])
        rotate([0, 0, 180])
        translate([-THICKNESS*2, 0, 0]) {
            translate([0, 0, layer_height*2*i]) p2(h=layer_height, extent=extent, is_left=true,
                                                   is_bottom=i==0, is_top=i==nb_layers-1);
        }

        translate([x_shift, -THICKNESS, 0])
        rotate([0, 0, flat ? 180 : 90]) {
            translate([0, 0, layer_height*2*i]) p2(h=layer_height, extent=extent, is_right=true,
                                                   is_bottom=i==0, is_top=i==nb_layers-1);
        }
    }
}


module hinge2(extent=0, x_shift=0, nb_layers=4, layer_height=LAYER_HEIGHT) {
    for (i=[0:nb_layers-1]) {
        translate([x_shift, -THICKNESS, 0])
        rotate([0, 0, 180])
        translate([-THICKNESS*2, 0, 0]) {
            translate([0, 0, layer_height*2*i]) p2(h=layer_height, extent=extent, is_left=true,
                                                   is_bottom=i==0, is_top=i==nb_layers-1);
        }

        translate([x_shift, -THICKNESS, 0])
        rotate([0, 0, 90]) {
            translate([0, 0, layer_height*2*i]) p2(h=layer_height, extent=extent,
                                                   is_bottom=i==0, is_top=i==nb_layers-1);
        }

        translate([x_shift, THICKNESS, 0]) {
            translate([0, 0, layer_height*2*i]) p2(h=layer_height, extent=extent, is_right=true,
                                                   is_bottom=i==0, is_top=i==nb_layers-1);
        }
    }
}


function get_hinge_thickness() = THICKNESS;
function get_hinge_height(nb_layers=3, layer_height=LAYER_HEIGHT) = layer_height*2*nb_layers;

hinge(extent=1);
//sample();