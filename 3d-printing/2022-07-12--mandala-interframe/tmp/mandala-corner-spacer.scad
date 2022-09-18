FRAME_THICKNESS    = 4 + .25; // 8 to 9
FRAME_HEIGHT       = 15;
TOP_HEIGHT         = 1;

PLATE_THICKNESS    = 4;
PIN_HEAD_THICKNESS = 1.5;
PIN_DIAMETER       = FRAME_THICKNESS;
PIN_SLIT           = .45;
PIN_HEAD_DIAMETER  = 5-.2; //PIN_DIAMETER+PIN_HEAD_THICKNESS*.67;
echo(PIN_HEAD_DIAMETER);

TENON_SHIFT        = FRAME_THICKNESS * 1.5 *.93 +.1;
NEEDLE_DIAMETER    = .5;

TOLERANCE = 0.15 ;
ATOM      = 0.01;
$fn       = 60;



module tenon() {
    translate([TENON_SHIFT, TENON_SHIFT, 0]) {
        difference() {
            translate([0, 0, -PLATE_THICKNESS])
            union() {
                // shaft
                cylinder(d=PIN_DIAMETER, h=PLATE_THICKNESS);    

                // head
                intersection() {
                    translate([0, 0, +PIN_HEAD_THICKNESS/2 * .5])
                    {
                        translate([0, 0, -PIN_HEAD_THICKNESS/2])
                        cylinder(d1=PIN_DIAMETER+PIN_HEAD_THICKNESS, d2=PIN_DIAMETER, h=PIN_HEAD_THICKNESS/2);

                        k = .75;
                        translate([0, 0, -PIN_HEAD_THICKNESS/2 - PIN_HEAD_THICKNESS/2/k])
                        cylinder(d2=PIN_DIAMETER+PIN_HEAD_THICKNESS, d1=PIN_DIAMETER*k, h=PIN_HEAD_THICKNESS/2/k);
                    }
                    
                    // shave head diameter
                    translate([0, 0, -PIN_HEAD_THICKNESS])
                    cylinder(d=PIN_HEAD_DIAMETER, h=PLATE_THICKNESS+PIN_HEAD_THICKNESS);
                }
            }
            // slits
            h = PLATE_THICKNESS + PIN_HEAD_THICKNESS;
            rotate([0, 0, -45])
            translate([-PIN_DIAMETER, -PIN_SLIT/2, -h+ATOM])
            cube([PIN_DIAMETER*2, PIN_SLIT, h]);

            rotate([0, 0, 45])
            translate([-PIN_DIAMETER, -PIN_SLIT/2, -h+ATOM ])
            cube([PIN_DIAMETER*2, PIN_SLIT, h]);
        }
    }
}

module piece() {
    difference() {
        d = FRAME_THICKNESS*2;
        cube([d, d, FRAME_HEIGHT+TOP_HEIGHT]);

        chamfer = 5;
        hull()
        translate([-FRAME_THICKNESS, -FRAME_THICKNESS, 0]) {
            intersection() {
                union() {
                    rotate([15, 0, 0])
                    translate([0, 0, -chamfer])
                    cube([d, d, chamfer]);

                    rotate([0, -15, 0])
                    translate([0, 0, -chamfer])
                    cube([d, d, chamfer]);
                }
            translate([d/2-ATOM, d/2-ATOM, -ATOM]) cube([d, d, 1.15]);//FRAME_HEIGHT+ATOM]);
            }
        }

        // hollowing
        translate([-FRAME_THICKNESS, -FRAME_THICKNESS, -ATOM])
        cube([d, d, FRAME_HEIGHT+ATOM]);

        // needle hole
        translate([TENON_SHIFT, TENON_SHIFT, -ATOM])
        cylinder(d=NEEDLE_DIAMETER, h=FRAME_HEIGHT*.75);
    }
    
    tenon();
}

spacing = 8;
for (x=[0, 1]) for (y=[0, 1]) {
    u = x * (FRAME_THICKNESS*2 + spacing);
    v = y * (FRAME_THICKNESS*2 + spacing);
    translate([u, v, 0])
    rotate([180, 0, 0]) piece();
}
