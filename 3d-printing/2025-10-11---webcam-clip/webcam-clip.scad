use <../chamferer.scad>;

W = 36;
D = 6.5;
L = 25;
CH = 1;
TH = 4;

ATOM = .01;
$fn = 200;

difference() {
    chamferer($preview?0:CH, "cone") {
        // spring
        translate([0, 0, -W/2])
        linear_extrude(W)
        translate([-32, -287.5 +.07, 0])
        import("webcam-clip.dxf");

        // plate
        translate([-1.5, 0, -W/2])
        cube([L, TH, W]);
    }
    
    // screw passage
    hull() {
        translate([-1.5 + D*1.25, -.5, 0]) rotate([-90, 0, 0])
        cylinder(d=D, h=TH*5+1);

        translate([-1.5 + L - D*1.25, -.5, 0]) rotate([-90, 0, 0])
        cylinder(d=D, h=TH*5+1);
    }
    
    // screw head passage
    p = 15;
    h = 17;
    translate([-ATOM, -p, -h/2])
    cube([L*2, p, h]);
}

