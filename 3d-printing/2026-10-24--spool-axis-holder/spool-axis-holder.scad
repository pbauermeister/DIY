use <../chamferer.scad>

D_OUT   = 52 -.4    +1.5    -.25;
D_IN    = 43        -2;
H       = 50;
TOOTH   =  3;
K_TOOTH = 1.5;
PLAY    = .2        +.15    -.025   -.025;

END_TH  = 7;
D_TH    = (D_OUT-D_IN) / 2;
R_MID   = D_IN/2 + D_TH/2;
R_T     = R_MID - TOOTH *sqrt(2) * .25;

PITCH   = TOOTH / K_TOOTH / sqrt(2) * 4;
TURNS   = H/PITCH;

STEP    =  $preview ? 20 : 4;

ATOM = 0.01;
$fn = 100;

module screw(extra) {
    for (a=[0:STEP:(TURNS+2)*360]) {
        hull() for (aa=[a, a+STEP])
            translate([0, 0, aa*PITCH/360 - PITCH])
            rotate([0, 0, aa])
            for (r=[0, R_T]) hull()
            translate([r, 0, 0])
            scale([1, 1, K_TOOTH])
            rotate([0, 45, 0])
            cube([TOOTH+extra, ATOM, TOOTH+extra], center=true);
    }
}

module tube(h=H) {
    difference() {
        cylinder(d=D_OUT, h=h);
        cylinder(d=D_IN, h=h*3, center=true);
    }
}

COLLAR = 3;

module end() {
    r = 30;
    chamferer($preview ? 0 : 1)
    difference() {
        hull() for (k=[-1, 1])
            translate([k*(D_OUT/2-r/2+COLLAR), 0, 0])
            for (i=[-1, 1])
                translate([0, D_OUT/2*i, 0])
                cylinder(d=r, h=END_TH);
        
        cylinder(d=D_IN, h=H, center=true);
    }
}

module collar(ring=false) {
    col = COLLAR;
    translate([0, 0, -1]) // fill chamfer of end piece
    difference() {
        cylinder(d2=D_OUT, d1=D_OUT+col*2, h=col);
        cylinder(d=D_IN, h=col*3, center=true);
    }
    if(ring)
        tube(COLLAR + END_TH);
}

module lower() {
    difference() {
        tube();
        screw(PLAY);
        
        translate([0, 0, H-D_OUT/2 + D_TH*.33])
        cylinder(d2=D_OUT*2, d1=0, h=D_OUT);
    }
    end();

    translate([0, 0, END_TH])
    collar();
}


module upper() {
    intersection() {
        tube();
        screw(-PLAY);

        h = H + D_OUT/2;
        translate([0, 0, H-h + D_TH*.66])
        cylinder(d2=h*2, d1=0, h=h);

    }

    translate([0, 0, H - END_TH])
    end();

    translate([0, 0, H-END_TH])
    scale([1, 1, -1])
    collar(true);
}

module all() {
    translate([D_OUT +10, 0, 0])
    lower();

    translate([0, 0, H])
    rotate([180, 0, 0])
    upper();
}

difference() {
    all();
    //cylinder(d=D_OUT*10, h=H-10);
}

//screw(0);