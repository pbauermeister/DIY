use <../chamferer.scad>

PIPE_DIAMETER_INNER = 102;
PIPE_HEIGHT         = 120; //135 - 4.5;

// phone
PHONE_TH            =  60;
PHONE_L             = 200;
PHONE_W             = 120;


MORE_SLANT          = true; 

// cut position
ANGLE               =  70 -8;
Z                   =  40    -10; //PIPE_DIAMETER_INNER*.5;

dy = MORE_SLANT ? -12 : 0;
Y                   = -5; //PIPE_DIAMETER_INNER*.05;

// wALL THICKNESS
TH                  =   0.5*2 * 2       *.75;

// cable channel
CHANNEL_W           =  15 + TH + 3;
CHANNEL_W2          = CHANNEL_W * .75;
CHANNEL_W0          =  10;
echo(CHANNEL_W2);

PLUG_L              =  25;

DY                  = -14;
FOOT_TH             =   6;

ATOM                = 0.01;
$fn = $preview ? $fn : 200;

module channels() {
    dy = MORE_SLANT ? -12.5 +.2 : 0;
    disp = -TH*.25;

    rotate([ANGLE -90, 0, 0])
    chamferer($preview ? 0: 2.5 + 2.5, "cylinder-z", fn=32)
    rotate([-ANGLE +90, 0, 0])
    {
        // vertical channel
        translate([0, Y+dy + (CHANNEL_W-CHANNEL_W2) + disp, -5])
        translate([-CHANNEL_W/2, -CHANNEL_W*1.2, -ATOM])
        cube([CHANNEL_W, CHANNEL_W2, PIPE_HEIGHT*0+Z +5]);

        // plug chamber
        translate([0, Y, Z])
        rotate([ANGLE -90, 0, 0])
        translate([-CHANNEL_W/2, DY -CHANNEL_W2 + disp, -PLUG_L+TH/2])
        cube([CHANNEL_W, CHANNEL_W2, PLUG_L + TH*2]);

        hull() {
            for (z=[Z, Z*.7]) 
            translate([0, Y + disp, z])
            rotate([ANGLE -90, 0, 0])
            translate([-CHANNEL_W0/2, DY -CHANNEL_W2, -PLUG_L+TH])
            cube([CHANNEL_W0, CHANNEL_W2, ATOM]);

            translate([0, Y+dy + (CHANNEL_W-CHANNEL_W2), Z*.3])
            translate([-CHANNEL_W0/2, -CHANNEL_W + disp, -ATOM])
            cube([CHANNEL_W0, CHANNEL_W0, ATOM+10]);
        }
    }

    // bottom channel
    translate([-CHANNEL_W0/2, Y+dy - CHANNEL_W2, -ATOM])
    cube([CHANNEL_W0, PIPE_DIAMETER_INNER, CHANNEL_W0+ATOM]);
}

module phone_cut(dispy=0, dispz=0) {
        translate([0, Y+dispy, Z+dispz])
        rotate([ANGLE -90, 0, 0])
        translate([-60, DY-100, 0])
        cube([120, 100, 200]);
}

module stand(dispy=0, dispz=0, channels=true) {
    difference() {
        cylinder(d=PIPE_DIAMETER_INNER, h=PIPE_HEIGHT);
        
        // phone rest
        phone_cut(dispy, dispz);
            //translate([0, -10, 0]) cube([.5, PIPE_DIAMETER_INNER/2+10, CHANNEL_W-TH]);

        if (channels) channels();
    }
}

module shape(channels=true, hollow=true) {
    intersection() {
        difference() {
            chamferer(TH * 1.5, shrink=false)
            stand(dispy=-.304, dispz=0, channels=channels); //.125);

            if (hollow)
                translate([0, 0, -TH*.25*0])
                stand(dispy=1, channels=channels);
        }

        // containment
        translate([0, 0, $preview ? ATOM:0])
        cylinder(d=PIPE_DIAMETER_INNER - ($preview?1:0), h=PIPE_HEIGHT+TH);
    }

    // pillar
    //if (!hollow)
    difference() {
        for (k=[-1, 1])
            rotate([0, 0, k*60])
            translate([0, PIPE_DIAMETER_INNER*.3, 0])
            cylinder(d=5, h=PIPE_HEIGHT);
        phone_cut();
        channels();
    }
}

module support(standing=false) {
    xtra = 5;
    th = 5;
    z = Z + 8;
    
    scale([1, 1, standing?-1:1])
    translate([0, 0, standing?-TH-PIPE_HEIGHT-th:0])
    chamferer(.1, grow=false)
    intersection() {
        difference() {
            union() {
                // cross
                for (a=[0, 90]) rotate([0, 0, a]) {
                    translate([-th/2, -PIPE_DIAMETER_INNER/2 - (a==0?th:0), z+TH])
                    cube([th, PIPE_DIAMETER_INNER, PIPE_HEIGHT-z+xtra]);
                }

                // center disc
                translate([0, 0, PIPE_HEIGHT - 3.5 + xtra])
                cylinder(d=PIPE_DIAMETER_INNER/2 -2, h=5);
                
                // ring
                translate([0, 0, PIPE_HEIGHT - 3.5 + xtra])
                difference() {
                    chamferer(th/2, "cone-down", fn=16)
                    cylinder(d=PIPE_DIAMETER_INNER, h=th);
                    cylinder(d=PIPE_DIAMETER_INNER-th*2, h=th*3, center=true);
                }
            }
            shape(channels=true, hollow=false);
        }

        // containment
        //if (!$preview)
            translate([0, 0, -0.02])
            cylinder(d=PIPE_DIAMETER_INNER - ($preview?1:0),
                     h=PIPE_HEIGHT+TH+xtra);
    }
}

//%support();

module foot() {
    difference() {
        cylinder(d=PIPE_DIAMETER_INNER, h=FOOT_TH);

        channels();
        
        // feet marks
        for (a=[0:90:360-90])
            rotate([0, 0, a+45])
            translate([PIPE_DIAMETER_INNER*.5-11, 0, -ATOM])
            cylinder(d=9, h=1);

        // spherical bend
        translate([0, 0, FOOT_TH+2.5])
        resize([PIPE_DIAMETER_INNER, PIPE_DIAMETER_INNER, FOOT_TH*2.4])
        sphere($fn=200);
        
        // flow holes
        flow_positioner() cylinder(d=25, h=10);
    }
}

module flow_positioner() {
    d = 25;
    for (a=[0, 180])
        rotate([0, 0, a])
        translate([CHANNEL_W0/2+d/2+0, 0, -ATOM])
        children();
}

module flow_funnels_0(dr1, dr2, dz) {
    // flow holes
    d = 25;

    flow_positioner()
    hull() {
        translate([0, 0, -dz])
        cylinder(d=d + dr1*2, h=ATOM);

        hull() flow_positioner() 
        translate([0, 0, -d*1.5 + dz])
        cylinder(d=d*2 + dr2*2, h=ATOM);
    }
}

module flow_funnels() {
    h = 40;
    d = 25 - .15;
    th = 1;
    
    difference() {
        union() {
            // pipes
            // - inner
            flow_positioner()
            translate([0, 0, -h])
            cylinder(d=d-.1, h=h+2);

            // - outer
            flow_positioner()
            translate([0, 0, -h])
            cylinder(d=d+th*2, h=h);
 
            // junction
            translate([-d/2, -th, 1-h-.5])
            cube([d, th*2, h-1]);

            // funnel
            translate([0, 0, -h])
            difference() {
                flow_funnels_0(th, th, 0);
                flow_funnels_0(-th*2, -th, -1);
            }
        }

        // pipes holes
        flow_positioner()
        cylinder(d=d-th*2, h=h*3, center=true);
    
        //translate([-500, 0, -500]) cube(1000);
    }
}

//%flow_funnels();

module foot_chamfer() {
    translate([0, 0, -1])
    difference() {
        cylinder(d=PIPE_DIAMETER_INNER*2, h=FOOT_TH);
        cylinder(d2=PIPE_DIAMETER_INNER, d1=PIPE_DIAMETER_INNER-FOOT_TH*1.5, h=FOOT_TH);
    }
}


module all() {
    difference() {
        union() {

            difference() {
                union() {
                    shape();
                }
                
                chamferer(TH, grow=false)
                channels();
            }
            foot();
        }
        foot_chamfer();
    }
    
    %stand();
}

//rotate([0, 0, 90]) 
all();