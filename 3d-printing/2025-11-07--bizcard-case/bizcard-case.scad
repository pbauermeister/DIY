use <../hinge4.scad>
use <../chamferer.scad>

W_INNER = 60;
H_INNER =  9.2  + 1;
L_INNER = 70    + 1;
WALL_TH =  2    - 0.5;

L1 = 20;
L2 = 20         + 0.75*3;
L3 = 45         - 3;

HINGE_TH = 3;
HINGE_L  = 3.75;

CH = WALL_TH;
ATOM = 0.01;

module flap_hinge() {
    th = HINGE_TH;
    l = HINGE_L;
    h = W_INNER + WALL_TH*2;
    y = th - WALL_TH + .1;
    intersection() {
        // hinges
        translate([0, y, 0])
        for (i=[0:2]) {
            odd = (i%2);
            z = odd ? h : 0;
            translate([i*(l*2) + l + L1, -th/2, z-WALL_TH])
            scale([1, 1, odd ? -1 : 1])
            hinge4(thickness=th,
                   arm_length=l+ATOM,
                   total_height=h,
                   nb_layers=20,
                   angle=180, extra_angle=0);
        }

        // chamfer
        chamferer(CH, shrink=false, grow=true)
        cube([L_INNER*3, th*.1, W_INNER]);
    }
    
    if (0) %
    translate([L1, -y, -WALL_TH])
    cube([L2, th, h]);
}

module flap() {
    difference() {
        intersection() {
            chamferer(CH, shrink=false, grow=true)
            cube([L_INNER*3, ATOM, W_INNER]);

            union() {
                // flap start
                translate([0, -WALL_TH/2*0, 0])
                chamferer(CH, shrink=false, grow=true)
                cube([L1, ATOM, W_INNER]);

                // flap end
                chamferer(CH, shrink=false, grow=true)
                intersection() {
                    translate([L1+L2, -WALL_TH/2*0, 0])
                    cube([L3, ATOM, W_INNER]);
                    
                    r = W_INNER;
                    translate([L1 + L2 + L3 -r,
                               -WALL_TH*2,
                               W_INNER/2])
                    rotate([-90, 0, 0])
                    cylinder(r=r, h=WALL_TH*10, $fn=100);
                }
            }
        }
        
        // shave flap inner side
        translate([0, 0, -W_INNER/2])
        cube([L_INNER*3, H_INNER, W_INNER*2]);
        translate([-L_INNER, 0, 0])
        cube([L_INNER*3, H_INNER, W_INNER]);

        // grip
        translate([L1+L2+L3, -WALL_TH/8, 0])
        rotate([0, 0, -9])
        translate([-W_INNER/2, 0, W_INNER/4])
        chamferer(CH/2)
        cube([W_INNER, WALL_TH, W_INNER/2]);
    }

    // flap hinge
    difference() {
        flap_hinge();

        l = CH*5;
        translate([L1-l + CH*2, 0, -W_INNER/2])
        chamferer(CH*2)
        cube([l, CH*5, W_INNER*2]);
    }
}

module case() {
    difference() {
        union() {
            // case
            translate([-L_INNER*1, 0, 0])
            difference() {
                chamferer(CH, shrink=false, grow=true)
                cube([L_INNER + CH, H_INNER, W_INNER]);


                translate([L_INNER, -H_INNER/2, -W_INNER/2])
                cube([CH*4, H_INNER*2, W_INNER*2]);

                cube([L_INNER, H_INNER, W_INNER]);
            }
        }

        // box cavity
        translate([-L_INNER, 0, 0])
        cube([L_INNER*3, H_INNER, W_INNER]);
    }

    // flap
    flap();
}

case();