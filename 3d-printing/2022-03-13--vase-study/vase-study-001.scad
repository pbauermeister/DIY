$fn= 90;

D = 10;
H = 20;
T = 1.2;

ATOM = 0.01;

module body1(recess=0) {
    cylinder(d=D-recess*2, h=H);
}

RR = 4;
K = 3;
R = RR/K;
function fx(i, recess) = (RR+R-recess)*cos(i) -((R-recess)*cos((RR+R)/(R-recess)*i));
function fy(i, recess) = (RR+R-recess)*sin(i) -((R-recess)*sin((RR+R)/(R-recess)*i));
function f(i, recess) = [fx(i, recess), fy(i, recess)];

module body2(recess=0) {
    p = [ for(i=[0:10:360]) f(i, recess) ];
    linear_extrude(H)
    polygon(points=p);
}

module body3(recess=0) {
    d = D - recess*2;
    rotate([0, 0, 16])
    translate([-d/2, -d/2, 0])
    cube([d, d, H]);
}

module body4(recess=0) {
    rotate([0, 0, 16])
    cylinder(d=D-recess*2, h=H, $fn=3);
}

module body5(recess=0) {
    d2 = D *1.25;
    intersection() {
        translate([0, 0, H-D])
        scale([1, 1, H/D])
        sphere(d=d2-recess*2);

        cylinder(d=D*10, h=H);
    }
}

module body(recess=0) {
//    body2(recess);
//    body3(recess);
//    body4(recess);

//    body1(recess);
    body5(recess);
}

module cuts(a) {
    translate([0, -D, D/2*0])
    for (i=[-30:3:30]) {
        translate([0, 0, i])
        rotate([a, 0, 0])
        translate([-D*2, -H, -T/2])
        cube([D*4, H*3, T]);
    }
}

module thing() {
    color("white")
    difference() {
        body();
        cuts(45);
        //rotate([0, 0, 0]) cuts(60);
    }
    if(1)
    color("gray")
    translate([0, 0, ATOM])
    scale([1, 1, (H-ATOM*2)/H])
    body(.001);
}

module vase() {
    th = 0.25;
    difference() {
        union() {
            thing();
            color("white")
            body(th*2);
        }
        translate([0, 0, th])
        color("white")
        body(th*2.5);
    }
}

vase();
