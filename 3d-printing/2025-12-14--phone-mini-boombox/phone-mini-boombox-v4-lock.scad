use <phone-mini-boombox-v4.scad>
use <../chamferer.scad>

KNOB_H = get_knob_h();
KNOB_D = get_knob_d();
KNOB_SCREW_D = get_knob_screw_d();
KNOB_SCREW_HEAD_D = get_knob_screw_head_d();
ATOM = 0.01;

module knob() {
    h   = KNOB_H - .1;
    xh  = 2.5; //5;
    d   = KNOB_D;
    th  = 2;
    hub = 10.2 - .4;
    shift = 5.3;
    fn = $preview ? 20 : 200;

    difference() {
        union() {
            chamferer($preview ? 0 : .4) {
                difference() {
                    // basis disc
                    cylinder(d=d, h=h + xh, $fn=fn);
                    
                    // shave sides
                    translate([hub/2, -d, -d]) cube(d*2);
                }
                // lever
                hull() {
                    translate([0, -d/2, h])
                    cube([ATOM, shift*2, xh]);

                    translate([-d, -d/2+shift, h])
                    cylinder(r=shift, h= xh, $fn=fn);
                }    
            }
            
            // lever ratchets
            for (ky=[-1, 1]) {
                translate([-d+3, -d/2+shift, h]) hull() {
                    for (kx=[-1, 1]) {
                        x = kx * 3;
                        translate([x, ky * 2, .25])
                        scale([1, 1.5, 2])
                        sphere(d=1.4, $fn=fn);

                        translate([x, ky * 4.5, .2])
                        scale([1, 2, 1])
                        sphere(d=.4, $fn=fn);
                    }
                }
            }
        }

        // screw head
        hull() {
            translate([0, 0, th+h*2]) cylinder(d=KNOB_SCREW_HEAD_D, h=ATOM, $fn=fn);
            translate([0, 0, th+KNOB_SCREW_HEAD_D/2]) sphere(d=KNOB_SCREW_HEAD_D, $fn=fn);
        }

        // screw axis
        cylinder(d=KNOB_SCREW_D+.2, h=h*3, center=true, $fn=fn/2);        

        // cracks
        gap = .03;
        fil = .36;
        for (r=[KNOB_SCREW_D/2-.2 : fil*2 + gap : KNOB_SCREW_HEAD_D/2]) difference() {
            cylinder(r=r + gap, h=h*2, $fn=fn/2);
            cylinder(r=r, h=h*2, $fn=fn/2);
        }
    }
}

rotate([0, 180, 0])
knob();
