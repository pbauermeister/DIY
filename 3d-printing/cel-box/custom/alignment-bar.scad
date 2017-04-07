// Bar to stick into lid inner side, to align to box when closed.

$fn=180;

L = 60.9;
W = 5;
H = 1;

difference() {
    // rounded bar, double height
    translate([H, H, H*0])
    minkowski() {
        cube([L-H*2, W-H*2, 0.00001]);
        sphere(H);
    }

    // cut away bottom half
    translate([0,0,-1]) cube([L, W, H]);
}