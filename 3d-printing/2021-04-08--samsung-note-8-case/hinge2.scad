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

module hinge(extent=0, x_shift=0, nb_layers=4, layer_height=LAYER_HEIGHT) {
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

module hinge2_half1(extent=0, x_shift=0, nb_layers=3, layer_height=LAYER_HEIGHT) {
    intersection() {
        for (i=[0:nb_layers-1]) {
            translate([x_shift, 0, 0])
            rotate([0, 0, 180])
            translate([-THICKNESS*2, 0, 0]) {
                translate([0, 0, layer_height*2*i]) p2(extent=extent, is_left=true,
                                                       h=layer_height,
                                                       is_bottom=i==0, is_top=i==nb_layers-1);
            }
        }
        translate([-extent - THICKNESS/2, -THICKNESS/2, THICKNESS/2])
        cube([extent*2+THICKNESS, THICKNESS, layer_height*2*nb_layers-THICKNESS]);
    }

    // rounded frame
    zbot = THICKNESS/2;
    ztop = layer_height*2*nb_layers - THICKNESS/2;
    zside = extent+THICKNESS/2;
    hull() {
        translate([0, 0, ztop])
        sphere(d=THICKNESS);

        translate([zside, 0, ztop])
        sphere(d=THICKNESS);
    }
    hull() {
        translate([zside, 0, ztop])
        sphere(d=THICKNESS);

        translate([zside, 0, zbot])
        sphere(d=THICKNESS);
    }
    difference() {
        hull() {
            translate([zside, 0, zbot])
            sphere(d=THICKNESS);
            
            translate([0, 0, zbot])
            sphere(d=THICKNESS);
        }
        translate([-THICKNESS*1.5 + TOLERANCE2, -THICKNESS, -THICKNESS/2+zbot])
        cube([THICKNESS*2, THICKNESS*2, THICKNESS]);
    }

}

module maybe_hull(doit) {
    if (doit) hull() children();
    else children();
}

module hinge2_half2(extent=0, x_shift=0, nb_layers=3, layer_height=LAYER_HEIGHT,
                    frame_only=false) {
    zbot = THICKNESS/2;
    ztop = layer_height*2*nb_layers - THICKNESS/2;
    zside = extent+THICKNESS/2;
    difference() {
        maybe_hull(frame_only) union() {
            if (!frame_only)
            intersection() {
                for (i=[0:nb_layers-1]) {
                    translate([x_shift, 0, 0])
                    rotate([0, 0, 180]) {
                        translate([0, 0, layer_height*2*i]) p2(extent=extent, is_right=true,
                                                               h=layer_height,
                                                               is_bottom=i==0, is_top=i==nb_layers-1);
                    }
                }
                translate([-extent - THICKNESS/2, -THICKNESS/2, THICKNESS/2])
                cube([extent*2+THICKNESS, THICKNESS, layer_height*2*nb_layers-THICKNESS]);
            }

            // rounded frame
            difference() {
                hull() {
                    translate([0, 0, zbot])
                    sphere(d=THICKNESS);

                    translate([-zside, 0, zbot])
                    sphere(d=THICKNESS);
                }
                translate([-THICKNESS/2, -THICKNESS/2, THICKNESS/2])
                cube([THICKNESS, THICKNESS, THICKNESS]);
            }
            hull() {
                translate([-zside, 0, zbot])
                sphere(d=THICKNESS);

                translate([-zside, 0, ztop])
                sphere(d=THICKNESS);
            }
            difference() {
                hull() {
                    translate([-zside, 0, ztop])
                    sphere(d=THICKNESS);
                    
                    translate([0, 0, ztop])
                    sphere(d=THICKNESS);
                }
                if (!frame_only) translate([-THICKNESS*.5 - TOLERANCE2, -THICKNESS, layer_height*2*nb_layers-THICKNESS])
                cube([THICKNESS*2, THICKNESS*2, THICKNESS]);
            }

            hull() {
                // enlarge laterally
                translate([frame_only ? THICKNESS/4 -.5: -THICKNESS*2, 0, zbot]) sphere(d=THICKNESS);
                translate([frame_only ? THICKNESS/4 -.5: -THICKNESS*2, 0, ztop]) sphere(d=THICKNESS);

                translate([-zside-THICKNESS/2, 0, zbot]) sphere(d=THICKNESS);
                translate([-zside-THICKNESS/2, 0, ztop]) sphere(d=THICKNESS);

                translate([-zside - THICKNESS/2, 0, ztop - THICKNESS/2])
                cylinder(d=THICKNESS, h=THICKNESS);

                if (frame_only) {
                    translate([THICKNESS/4 -.5, 0, ztop - THICKNESS/2])
                    cylinder(d=THICKNESS, h=THICKNESS);
                }
                else {
                    translate([-THICKNESS - TOLERANCE2, 0, ztop + THICKNESS/4])
                    cube([THICKNESS, THICKNESS, THICKNESS/2], center=true);
                }
            }
            if (0 && frame_only) {
                w = THICKNESS *2.25 + extent -1;
                translate([-w + THICKNESS*.75 -.5, THICKNESS * .5, 0])
                cube([w, THICKNESS, ztop + THICKNESS/2]);
            }
        }
        // chamfer
        chamfer(zside, layer_height, nb_layers);
        //groove(extent, layer_height, nb_layers);
    }
}

module chamfer(zside, layer_height, nb_layers) {
    ztop = layer_height*2*nb_layers - THICKNESS/2;
    intersection() {
        translate([-zside -THICKNESS*.95, 0, 0])
        scale([.3, 1, 1])
        rotate([0, 0, -45])
        translate([-THICKNESS/2, -THICKNESS/2, -ztop/2])        
        cube([THICKNESS, THICKNESS, ztop*2]);
    }
}

module groove(extent, layer_height, nb_layers) {
    ztop = layer_height*2*nb_layers - THICKNESS/2;
    zside = extent+THICKNESS/2;
    up = ztop-THICKNESS/2*0 - ztop/3;
    down = THICKNESS/2 + ztop/3;
    hull() {
        translate([-zside -THICKNESS*.9, THICKNESS/2.5, up])
        sphere(d=THICKNESS*.7);
        
        translate([-zside -THICKNESS*.9, THICKNESS/2.5, down])
        sphere(d=THICKNESS*.7);


        translate([-zside -THICKNESS*1.5, THICKNESS/2.5, up])
        sphere(d=THICKNESS*.7);
        
        translate([-zside -THICKNESS*1.5, THICKNESS/2.5, down])
        sphere(d=THICKNESS*.7);

    }
}

module hinge2_half2_cutout(extent=0, x_shift=0, nb_layers=3, layer_height=LAYER_HEIGHT, frame_only=false) {
    zbot = THICKNESS/2;
    ztop = layer_height*2*nb_layers;
    zside = extent+THICKNESS/2;
    w = extent + THICKNESS*2 + TOLERANCE;
    t = THICKNESS * 1.5;

    difference() {
        union() {
            translate([-w + THICKNESS/2 + TOLERANCE*2, 0, 0])
            cube([w, THICKNESS, ztop]);

            hull() {
                translate([-extent-THICKNESS, 0, 0])
                cylinder(d=THICKNESS, h=ztop);
                translate([-THICKNESS/2+TOLERANCE*2, -THICKNESS/2, 0])
                cube([THICKNESS, THICKNESS, ztop]);
            }
        }

        // chamfer
        chamfer(zside, layer_height, nb_layers);
    }
}

module hinge2(extent=0, x_shift=0, nb_layers=3, layer_height=LAYER_HEIGHT) {
    hinge2_half1(extent/2, x_shift, nb_layers, layer_height);
    hinge2_half2(extent, x_shift, nb_layers, layer_height);
}

module hinge2_cutout(extent=0, x_shift=0, nb_layers=3, layer_height=LAYER_HEIGHT, extra=.3) {
    minkowski() {
        hinge2_half2_cutout(extent, x_shift, nb_layers, layer_height, frame_only=true);
        translate([-.1, 0, .05])
        scale([1.25, 1, 1.4]) cube(extra, center=true);
    }
    groove(extent, layer_height, nb_layers);
}

function get_hinge_thickness() = THICKNESS;

function get_hinge_height(nb_layers=3, layer_height=LAYER_HEIGHT) = layer_height*2*nb_layers;
//sample(extent=5);

if(0) hinge(extent=10);

%hinge2_cutout(extent=10, layer_height=6);

//translate([0, -THICKNESS*3, 0])
hinge2(extent=10, layer_height=6);
