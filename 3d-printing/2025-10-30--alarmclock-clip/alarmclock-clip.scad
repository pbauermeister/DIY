use <../chamferer.scad>;

W =   36 + 6.6;
D =    1.5;
L =   25;
CH =   0.8;
TH =   4;
PX = -22;
PZ =  -3;

ATOM = .01;
$fn  = 200;

difference() {
    chamferer($preview?0:CH, "cone") {
        // spring
        translate([0, 0, -W/2])
        linear_extrude(W)
        translate([-32, -287.5 +.07, 0])
        import("clip.dxf");

        // plate
        translate([PX, PZ, -W/2])
        cube([L, TH, W]);
    }
    
    // screw passage
    translate([PX + L -5, PZ -.5, 0]) rotate([-90, 0, 0])
    cylinder(d=D, h=TH*5+1);
    
    // screw head passage
    p = 15;
    h = 17;
    translate([-ATOM, -p, -h/2])
    cube([L*2, p, h]);
}

