use <hook-only.scad>;

rotate([0, 90, 0])
intersection() {
    difference() {
        rotate([0, 0, 45])
        hook();

        cube([10, 10, 300], center=true);
    }
    cube([20, 20, 300], center=true);
}
