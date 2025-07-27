use <../hinge4.scad>

L = 80;
W = 45;
R = 10;

X1 = 30;
X2 = 20;
X3 = 30;
TH1 = 2.3;
TH2 = 1;

step = 3*1.5;
ATOM = 0.01;

module chain_mail(l) {
    w = X1;
    for (y=[0:step*2:w])
        translate([step, -y, TH1/2])
        scale([1, (y/step/4) == floor(y/step/4) ? -1 : 1, 1])
        rotate([90, 0, 0])
        rotate([0, 90, 0])
        hinge4(thickness=TH1, arm_length=step, total_height=l-step*2, layer_height=4, angle=180, extra_angle=0);
}

module long_chain() {
    chain_mail(L);
}

module short_chain() {
    chain_mail(W);
}

module flap(l, w, th2=TH2) {
    dl = l * .3;
    translate([step, 0, 0]) hull() {    
        translate([0, TH1/2 + .5, 0])
        cube([l-step*2, ATOM, TH1]);

        translate([dl/2, w-step, 0])
        cube([l-step*2-dl, ATOM, th2]);
    }
}

module long_flap(th2=TH2) {
    flap(L, X3, th2);
}

module short_flap() {
    flap(W, X3*.67);
}

module body() {
    translate([step, step, TH1-TH2])
    cube([L-step*2, W-step*2, TH2]);

    w = W - step*2;
    for (y=[0: w/12: w])
        translate([step, y-step/4+step, 0])
        cube([L-step*2, step/2, TH1]);

    // long chainmails
    for (dy_ky=[[0, 1], [W, -1]])
        translate([0, dy_ky[0], 0])
        scale([1, dy_ky[1], 1])
        long_chain();

    // short chainmails
    for (dx_kx=[[0, -1], [L, 1]])
        translate([dx_kx[0], 0, 0])
        scale([dx_kx[1], 1, 1])
        rotate([0, 0, 90])
        short_chain();

    // long flaps
    for (dy_ky_th=[[X1, -1, (TH1+TH2)/2], [W+X1, 1, (TH1+TH2)/2]])
        scale([1, dy_ky_th[1], 1])
        translate([0, dy_ky_th[0], 0])
        long_flap(dy_ky_th[2]);

    // short flaps
    for (dx_kx=[[-X1, 1], [L+X1, -1]])
        translate([dx_kx[0], 0, 0])
        scale([dx_kx[1], 1, 1])
        rotate([0, 0, 90])
        short_flap();
}

difference() {
    body();

    d = 1;
    dz = d/2 + .3;
    th = (TH1+TH2)/2;
    hull() {
        translate([L/2, -X3-step/2, TH1-dz])
        scale([1.5, 1, .8])
        rotate([90, 0, 0])
        cylinder(d=d, h=ATOM, $fn=50);

        translate([L/2, -X3-step-X2-2, th-dz])
        scale([1.5, 1, .8])
        rotate([90, 0, 0])
        cylinder(d=d, h=ATOM, $fn=50);

    }
    
    w = 5;
    translate([L/2, W+X1+X3/2, TH1/2+.4])
    rotate([0, 0, 45])
    cube([w, w, TH1], center=true);
}