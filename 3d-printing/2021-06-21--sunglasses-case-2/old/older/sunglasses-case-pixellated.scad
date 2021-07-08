$fn = 360;

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
    importer("sunglasses-case-pixellated-full.dxf");
}

module curvacy(anti=false, z_offset=0) {
    r = 213 * 1.75;
    h = anti ? -r : r;
    translate([0, 0, h+z_offset])
    rotate([90, 0, 0])
    cylinder(r=r, h=200, center=true);
}

module curvate(nose=true) {
    intersection() {
        children();

        union() {
            translate([0, 0, 3])
            curvacy();

            difference() {
                intersection() {
                    curvacy();
                    w = 62;
                    if(nose)
                        translate([-w, 0, 0])
                        cube([w*2, 100, 100]);
                }
                if(nose)
                    cube([14, 1200, 8], center=true);
            }
        }
    }
}

module anti_curvate(thickness, height, nose=true) {
    intersection() {
        children();
        
        union() {
            translate([0, 0, -3])
            curvacy(true, height);

            difference() {
                intersection() {
                    curvacy(true, height);
                    w = 62;
                    if(nose)
                        translate([-w, 0, 0])
                        cube([w*2, 100, 100]);
                }
                if(nose)
                    translate([0, 0, height])
                    cube([14, 1200, 8], center=true);
            }
        }
    }
}

module shape(nose) {
    h = 35;
    curvate(nose)
    anti_curvate(1, h, nose) {
        scale([1, 1, h*2])
        plate();
    }
}

L = 144;
W = 50;
H = 30;
T = .1; //.5;
module case() {
    difference() {
        shape(false);
        translate([0, T*1.75, T])
        scale([L/(L+T*2), W/(W+T), H/(H+T*2)])
        shape(true);
    }
}

module all() {
    rotate([90, 0, 0])
    minkowski() {
        case();
        r = 1; //.6;
        sphere(r=r, $fn=6);
    }
}

all();

//translate([0, 0, -57.54]) cube([2, 35, 1]);