use <../chamferer.scad>

L    = 200;
W    =  40;
CH   =   3;
H    =  40;
WALL = 4;

PLUG_USB_D1 = 33;
PLUG_USB_H1 =  1;
PLUG_USB_CX  = 15 + 25/2 + 10;

PLUG_USB_D2 = 28;
PLUG_USB_D3 = 32;

PLUG_JACK_W = 28;
PLUG_JACK_X = PLUG_USB_CX - PLUG_JACK_W/2 + 45;

BT_AP_L = 70;
BT_AP_W = 61.5;
BT_AP_H = 18;
BT_AP_X = 160;
BT_AP_Z = WALL*2;

$fn = $preview ? 8 : 120;
ATOM = 0.02;

module base(inner=false) {
    chamferer(CH, "cone-up", fn=$preview?16:32)
    hull() {
        dx = 3;
        translate([W/2+dx, 0, 0])
        cylinder(d=W, h=H);

        translate([L-W, -W/2, 0])
        cube([W, W, H]);

        if (!inner) {
            h = CH+1;
            dx2 = -11;
            translate([L-W + H - h + dx2, -W/2, 0])
            cube([W, W, h]);
        }
    }
}

module box() {
    difference() {
        base();
        
        difference() {
            chamferer(WALL, "cube", grow=false)
            base(inner=true);
            cylinder(d=L*3, h=WALL*2);
        }
    }
}

module plugs_opening() {
    translate([0, 0, -ATOM]) {
        hull() {
            translate([PLUG_USB_CX, 0, 0])
            cylinder(d=PLUG_USB_D2, h=H - WALL);

            dx = 2.5;
            translate([PLUG_JACK_X + dx, -PLUG_JACK_W/2, 0])
            cube([PLUG_JACK_W, PLUG_JACK_W, H - WALL]);
        }

        // KFZ, bottom
        translate([PLUG_USB_CX, 0, 0]) 
        cylinder(d1=PLUG_USB_D1, d2=0, h=PLUG_USB_D1);

        hull() {
            translate([PLUG_USB_CX, 0, 0])
            cylinder(d=PLUG_USB_D2, h=H+ATOM*2);

            dx = -2.5;
            translate([PLUG_USB_CX, -PLUG_JACK_W/2, 0])
            cube([PLUG_JACK_W, PLUG_JACK_W, H+ATOM*2]);

            translate([PLUG_USB_CX, -PLUG_JACK_W/2, 0])
            cube([PLUG_JACK_W, PLUG_JACK_W, H+ATOM*2]);
        }
    }
    
    
    translate([0, 0, WALL*2]) {
        hull() {
            translate([PLUG_USB_CX, 0, 0])
            cylinder(d=PLUG_USB_D3, h=H);

            translate([PLUG_USB_CX, -PLUG_JACK_W/2, 0])
            cube([PLUG_JACK_W, PLUG_JACK_W, H]);

            translate([PLUG_JACK_X, -PLUG_JACK_W/4, 0])
            cube([PLUG_JACK_W, PLUG_JACK_W/2, H]);    
        }
    }
}

module bt_ap(bottom) {
    translate([BT_AP_X, 0, BT_AP_Z])
    resize([BT_AP_L, BT_AP_W, BT_AP_H + (bottom?WALL*2:0)])
    cylinder();
}

SCREW_D = 5.5;

module screw_holes() {
    for (x=[13, 110, 150, 190]) translate([x, 0, 0]) {
            fn = $preview ? 12: 30;
            cylinder(d=SCREW_D, h= WALL*3, center=true, $fn=fn);

            translate([0, 0, WALL])
            cylinder(d=SCREW_D*2, h=WALL*2, $fn=fn);
        
            if (!$preview)
            translate([0, 0, .4])
            for (d=[SCREW_D:1:SCREW_D*2.5]) {
                difference() {
                    cylinder(d=d, h= WALL-.4, $fn=fn);
                    cylinder(d=d-.2, h= WALL, $fn=fn);
                }//if(1)
            }
        }
}


module partitioner() {
    translate([0, 0,  WALL -WALL-ATOM]) {
        difference() {
            union() {
                translate([-L/2, -W, -H+WALL*2+BT_AP_H])
                cube([L*2, W*2, H]);

                translate([-L/2, -W, -H+WALL*2+BT_AP_H])
                cube([L*2, W*2, H]);

                translate([-L/2, -W, -H+WALL*2+BT_AP_H])
                cube([L*2, W*2, H]);

                translate([-L/2, -W/2+WALL/2, -H+WALL*2+BT_AP_H + WALL])
                cube([L*2, W-WALL, H]);
                
                // rails
                for(k=[-1, 1])
                    translate([0, k*(W/2-WALL/2), WALL*2+BT_AP_H + WALL*sqrt(2)/3])
                    scale([1, .67, 1])
                    rotate([45, 0, 0])
                    cube([L*4, WALL/4, WALL/4], center=true);
            }

            // rear end
            translate([L, -W, -H+WALL*2+BT_AP_H+H])
            cube([L, W*2, WALL]);
        }
    }
}

module case(bottom=false) {
    difference() {
        box();
        plugs_opening();
        screw_holes();

        bt_ap(bottom);
        //%bt_ap();
    }
}

PLAY = .13; //.2; // .07

module case_bottom() {
    intersection() {
        case(bottom=true);
        
        chamferer(PLAY, grow=false)
        partitioner();
    }
}

module case_top() {
    difference() {
        case();

        //chamferer(PLAY, shrink=false)
        partitioner();
    }    
}

/*
rotate([0, -90, 0])
intersection() {
    translate([-110, 0, 0])
    union() {
        case_bottom();
        case_top();
    }

    translate([.5, 0, 0])
    cube([1, 100, 100], center=true);
}

intersection() {
    case_bottom();
    cylinder(r=L*2, h=.25);
}

*/

/*
!difference() {
    case();

    rotate([0, 90, 0])
    cylinder(r=L*2, h=140);
}
*/


intersection() {
    union() {
if(1)
        case_bottom();

//if(1)
        //translate([0, W+10, H]) rotate([180, 0, 0])
        case_top();
    }

    if (0)
    translate([120, 0, 0])
    rotate([0, 90, 0])
    cylinder(d=1000, h=6);
}