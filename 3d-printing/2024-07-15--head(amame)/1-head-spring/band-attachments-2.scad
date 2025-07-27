SCREW_DIST_1 = 11.5;
SCREW_DIST_2 =  5.0;

WIDTH        = 20;
D            = 16;
SCREW_D      =  1;
K            =  0.85;
ATOM         =  0.01;

module piece() {
    difference() {
        intersection() {
            scale([1, 1, K])
            rotate([0, 90, 0])
            cylinder(d=D, h=WIDTH, center=true, $fn=100);
            
            cylinder(r=WIDTH*2, h=D);
        }
        
        for(x=[-SCREW_DIST_1/2, SCREW_DIST_1/2]) {
            for(y=[-SCREW_DIST_2/2, SCREW_DIST_2/2]) {
                translate([x, y, -ATOM]) {
                    h = D/2*K *.7;
                    w = SCREW_D*3;
                    th = .25;
                    
                    cylinder(d=SCREW_D, h=h, $fn=20);

                    for (a=[0, 45, 90, 135])
                        rotate([0, 0, a])
                        translate([-w/2, -th/2, 0])
                        cube([w, th, h]);
                }
            }
        }
    }
}

piece();

translate([0, D*1.5, 0]) piece();
