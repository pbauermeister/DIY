$fn = 360;

L = 150                + 6;
W = 55-3;
H = 30                 + 6;
T = .1;
R = .6;

LID_T = 4.75;

module importer(file_name) {
    k = 3.55;
    translate([-74.93 +.3, 0, 0])
    scale([k, k, 1])
    difference() {
        translate([-5, -5, 0]) cube([50, 23, 1]);
        translate([0, 0, -.5]) linear_extrude(height=2)
        import(file=file_name);
    }
}

module plate() {
    importer("sunglasses-case-pixellated-full-2.dxf");
}

module curvacy(anti=false, z_offset=0) {
    r = 213*2; //213 * 1.75;
    h = anti ? -r : r;
    translate([0, 0, h+z_offset])
    rotate([90, 0, 0])
    cylinder(r=r, h=200, center=true);
}

module curvate(nose=true, shift=0) {
    intersection() {
        children();
        union() {
            translate([0, 0, 1])
            curvacy(z_offset=shift);

            difference() {
                intersection() {
                    curvacy(z_offset=shift);
                    w = 62;
                    if(nose)
                        translate([-w, 0, 0])
                        cube([w*2, 100, 100]);
                }
                if(nose)
                    translate([0, W/2, 0])
                    cube([14, W, 8], center=true);
            }
        }
    }
}

module anti_curvate(thickness, height, nose=true, shift=0) {
    intersection() {
        children();        
        union() {
            translate([0, 0, -1])
            curvacy(true, height-shift);
            
            difference() {
                intersection() {
                    curvacy(true, height-shift);
                    w = 62;
                    if(nose)
                        translate([-w, 0, 0])
                        cube([w*2, 100, 100]);
                }
                if(nose)
                    translate([0, W/2, height])
                    cube([14, W, 8], center=true);
            }
        }
    }
}

module shape(nose, shift=0) {
    h = 35-4;
    curvate(nose, shift)
    anti_curvate(1, h, nose, shift) {
        scale([1, 1, h*2])
        plate();
    }
}

module case0() {
    difference() {
        shape(false);
        translate([0, .25, T])
        scale([L/(L+T*2), W/(W+T), H/(H+T*2)])
        shape(true);
    }
}

module case(play=.0001) {
    rotate([90, 0, 0]) {
        minkowski() {
            case0();
            sphere(r=R+play, $fn=6);
        }
        D = 3 + play*2;
        translate([0, W-1.2, .5])
        difference() {
            sphere(d=D, $fn=12);
            translate([0, 0, -1.5]) cube(D, center=true);
        }
        translate([0, W-1.2, H + .15])
        difference() {
            sphere(d=D, $fn=12);
            translate([0, 0, 1.5]) cube(D, center=true);
        }
    }
}

//case();

module lid0() {
    h = 35-4;
    curvate(false)
    anti_curvate(1, h, false) {
        scale([1, 1, h*2])
        plate();
    }
}

module lid1() {
    minkowski() {
        intersection() {
            rotate([90, 0, 0])
            lid0();
            translate([0, 0, W-LID_T])
            cylinder(r=L, h=W);
        }
        //sphere(r=R*1.5 + 1.2, $fn=6*2);
        r = R*1.5 + 1.2;
        cylinder(r=r*1.5, h=r*2, center=true);
    }
}

module lid() {
    rotate([180, 0, 0]) {
        difference() {
            translate([0, 0, 1.1 +1])
            lid1();

            w = 14;
            intersection() {
                rotate([90, 0, 0]) shape(nose=true, shift=2.7*3);
                translate([-w/2, -H*1.5, W/2])
                cube([w, H*2, W]);
            }

            difference() {
                rotate([90, 0, 0]) shape(nose=true, shift=2*0);
                translate([-w/2, -H*1.5, W/2])
                cube([w, H*2, W]);
            }

            translate([0, 0, 0])
            case(.25);
            k = .6;
            d = -.5;
            translate([H/1.5, -H/2 + d, 0]) cylinder(d=H*k, h= W*2);
            translate([-H/1.5, -H/2 + d, 0]) cylinder(d=H*k, h= W*2);

//        translate([0, -95, 0]) cube([100, 100, 100]);

        }
    }
}

lid();
case();