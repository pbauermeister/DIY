use <../chamferer.scad>

W  = 22.25  +.35        *2;
TH =  2.3;
L1 = 33.5;
L  = 70.0  + 30;
MA =  1.0               +.5;


difference() {
    union() {
        difference() {
            cube([L, W+MA*2, 1]);
            translate([L-W*.75, MA+W/2, -.1])
            cylinder(d=W*.7, h=TH*2+2);
        }

        chamferer(.5) difference() {
            translate([2, MA, 0])
            cube([L-2, W, TH]);

            translate([L-W*.75, MA+W/2, -.1])
            cylinder(d=W*.7, h=TH*2+2);
        }
    }
    
    d = MA * 4;
    translate([0, MA*1.5, -.1])
    rotate([0, 0, -30])
    translate([0, -d, 0])
    cube([L, d, TH+1]);

    translate([0, W+MA/2, -.1])
    rotate([0, 0, 30])
    cube([L, d, TH+1]);
}    
