use <../hinge4.scad>
use <../chamferer.scad>

W_INNER = 60                                 -0.8;
H_INNER =  9.2  + 1                                           +.1;
L_INNER = 70    + 1        + 0.5;
WALL_TH =  2    -0.5              +0.15;

L1 = 20                    +4                -3.75*3;
L2 = 20         +0.75*3           -1.5       +3.75*3 +2;
L3 = 45         -3                                   -2;

HINGE_N  =                                    6;
HINGE_TH = 3               -0.2   *0;
HINGE_L  = 3.75                   -0.35       -.05;
MARGIN   =                                    4.5;

CH = WALL_TH;
ATOM = 0.01;

module flap_hinge() {
    th = HINGE_TH;
    l = HINGE_L;
    h = W_INNER + WALL_TH*2;
    y = th - WALL_TH + .1;
    difference() {
        intersection() {
            // hinges
            translate([0, y, 0]) {
                for (i=[0:HINGE_N-1]) {
                    odd = false; //(i%2);
                    z = odd ? h : 0;
                    translate([i*(l*2) + l + L1, -th/2, z-WALL_TH])
                    scale([1, 1, odd ? -1 : 1])
                    hinge4(thickness=th,
                           arm_length=l+ATOM,
                           total_height=h,
                           nb_layers=20 - 7,
                           angle=180, extra_angle=0);
                }
                
                // hinge l-extension
                translate([L1+L2-.5, -th, -WALL_TH])
                cube([4+4-2, th, h]);
            }

            // chamfer
            difference() {
                chamferer(CH, shrink=false, grow=true)
                cube([L_INNER*3, th*.1, W_INNER]);

                // shaving for rails
                y = th/8 + .5;
                echo(th/4-th/8);
                // - bottom
                chamferer(th)
                translate([0, y, -WALL_TH - MARGIN])
                cube([L_INNER*3, th*4, MARGIN*2]);
                // - top
                chamferer(th)
                translate([0, y, W_INNER + WALL_TH - MARGIN])
                cube([L_INNER*3, th*4, MARGIN*2]);
            }
        }

        // cut for carriage plate
        translate([L1+L2 + HINGE_L-2, 0, -h/2])
        cube([10, th, h*2]);
    }
    
    if (0) %
    translate([L1+L2-HINGE_L*2+1, -y, -WALL_TH+1])
    cube([7, th, h]);
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

        // start chamfer
        l = CH*5;
        translate([L1-l + CH*1.4, 0, -W_INNER/2])
        chamferer(CH*2, fn=3)
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

                // chamber
                cube([L_INNER + CH, H_INNER, W_INNER]);
                cube([L_INNER, H_INNER, W_INNER]);
                translate([L_INNER, -H_INNER/2, -W_INNER/2])
                cube([CH*4, H_INNER*2, W_INNER*2]);
            }
        }

        // box cavity
        translate([-L_INNER, 0, 0])
        cube([L_INNER*3, H_INNER, W_INNER]);
    }

    // flap
    flap();

    //% cube([L1, 6, 6]);
    //% cube([L1+L2, 5, 5]);
    //% cube([L1+L2+L3, 4, 4]);
}

rotate([0, 0, -90])
{
    case();

    // lateral support
    translate([L1+L2+L3 - CH - L3/4, 0, -WALL_TH])
    cube([.45, 30, W_INNER*.77]);
}