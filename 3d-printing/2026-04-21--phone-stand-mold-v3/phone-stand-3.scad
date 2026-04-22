use <../chamferer.scad>

PIPE_DIAMETER_INNER = 102;
PIPE_HEIGHT         = 120; //135 - 4.5;

// phone
PHONE_TH            =  60;
PHONE_L             = 200;
PHONE_W             = 120;

// cut position
ANGLE               = 70;
Z                   = 40; //PIPE_DIAMETER_INNER*.5;
Y                   = -5; //PIPE_DIAMETER_INNER*.05;

// wALL THICKNESS
TH = .5*2;

// cable channel
CHANNEL_W           = 15 + TH;


ATOM                = 0.01;
$fn = $preview ? $fn : 200;

module phone_ghost_v() {
    th = PHONE_TH;
    l = PHONE_L;
    w = PHONE_W;
    translate([0, Y, Z])
    rotate([ANGLE-90, 0, 0])
    translate([-w/2, -th, 0])
    cube([w, th, l]);
}

module phone_ghost_h() {
    th = PHONE_TH;
    w = PHONE_L;
    l = PHONE_W;

    translate([0, Y, Z])
    rotate([ANGLE-90, 0, 0])
    translate([-w/2, -th, 0])
    cube([w, th, l]);
}

module channels() {
    // vertical channel
    translate([0, Y, 0])
    translate([-CHANNEL_W/2, -CHANNEL_W, -ATOM])
    cube([CHANNEL_W, CHANNEL_W, PIPE_HEIGHT]);

    // bottom channel
    translate([-CHANNEL_W/2, Y, -ATOM])
    cube([CHANNEL_W, PIPE_DIAMETER_INNER, CHANNEL_W+ATOM]);
}

module stand(dispy=0, dispz=0, channels=true) {
    difference() {
        cylinder(d=PIPE_DIAMETER_INNER, h=PIPE_HEIGHT);
        
        // phone rest
        translate([0, Y+dispy, Z+dispz])
        rotate([ANGLE-90, 0, 0])
        translate([-60, -100, 0])
        cube([120, 100, 200]);

        if (channels) channels();
    }
}


//%phone_ghost_v();
//%phone_ghost_h();

//%stand();

module ribs() {
    th = TH; //*1.25;
    marg = 5;
    step = 14.3;

    intersection() {
        union() {
            difference() {
                union() {
                    for (i=[-3:3])
                        translate([i*step -th/2, -PIPE_DIAMETER_INNER/2, 0])
                        cube([th, PIPE_DIAMETER_INNER, PIPE_HEIGHT]);

                    for (i=[-3.5:3.5])
                        translate([i*step -th/2, -PIPE_DIAMETER_INNER/2, 0])
                        cube([th, PIPE_DIAMETER_INNER/2, Z + cos(ANGLE)*PIPE_DIAMETER_INNER/2]);

                }
                
                // holes
                translate([0, PIPE_DIAMETER_INNER/2*.45, Z*1.5])
                scale([1, 1.25, 6])
                rotate([0, 90, 0])
                cylinder(d=15, h= PIPE_DIAMETER_INNER*.7, center=true, $fn=6);

                translate([0, -PIPE_DIAMETER_INNER/2*.5, Z/2+3])
                resize([PIPE_DIAMETER_INNER*.66, 15, Z])
                rotate([0, 90, 0])
                cylinder(d=1, h= PIPE_DIAMETER_INNER, center=true, $fn=6);

                translate([0, PIPE_DIAMETER_INNER/2*.06125, Z/2+3])
                resize([PIPE_DIAMETER_INNER, 15, Z])
                rotate([0, 90, 0])
                cylinder(d=1, h= PIPE_DIAMETER_INNER, center=true, $fn=6);



            }

            // perp ribs
            for (i=[-1,1])
                translate([-PIPE_DIAMETER_INNER/2, i*step -th/2, marg*2])
                cube([PIPE_DIAMETER_INNER, th, 20]);

        }

        stand();

        //translate([0, 0, marg])
        cylinder(d=PIPE_DIAMETER_INNER - marg*2, h=PIPE_HEIGHT);
    }
}

module ribs2() {
    intersection() {
        marg = 5;
        step = 6;
        w = 3;

        for (dz=[0:step:PIPE_HEIGHT-Z-step*0])
            translate([0, w/2 +Y +dz*cos(ANGLE) + TH*1.33, Z+dz])
            cube([PIPE_DIAMETER_INNER, w, .1], center=true);

        cylinder(d=PIPE_DIAMETER_INNER - marg*2, h=PIPE_HEIGHT);
    }
}

module bottom_cone() {
    difference() {
        intersection() {
            hull() {
                intersection() {
                    shape(channels=false);

                    translate([0, 0, Z-PIPE_DIAMETER_INNER/2])
                    translate([-PIPE_DIAMETER_INNER/2, Y-PIPE_DIAMETER_INNER, 0])
                    cube(PIPE_DIAMETER_INNER);
                }
                translate([0, -Z/2*sin(ANGLE), Z/2])
                cylinder();
            }
            stand(channels=false);
        }

        // shave bottom as steps to ensure supports
        for (y=[0:3:PIPE_DIAMETER_INNER/2])
        translate([0, -y*sin(ANGLE), Z + cos(ANGLE)*y -3])
        translate([-PIPE_DIAMETER_INNER/2, Y-PIPE_DIAMETER_INNER, -PIPE_DIAMETER_INNER])
        cube(PIPE_DIAMETER_INNER);

    }
}

module top_cone() {
    intersection() {
        h = 15;
        translate([0, 0, PIPE_HEIGHT-h*2])
        cylinder(d1=0, d2=PIPE_DIAMETER_INNER, h=h*2);
        stand();

        translate([0, 0, PIPE_HEIGHT-3])
        cylinder(d=PIPE_DIAMETER_INNER, h=20);
    }
}

module shape(channels=true) {
    intersection() {
        difference() {
            chamferer(TH, shrink=false)
            
            stand(dispy=-.304, dispz=0, channels=channels); //.125);

            translate([0, 0, -TH*.25])
            stand(channels=channels);
        }

        // containment
        translate([0, 0, $preview ? ATOM:0])
        cylinder(d=PIPE_DIAMETER_INNER - ($preview?1:0), h=PIPE_HEIGHT+TH);
    }
}

difference() {
    union() {
        shape();
        //translate([0, .1, 0]) ribs();
        ribs2();
        top_cone();
        bottom_cone();
    }
    
    chamferer(TH, grow=false)
    channels();
}