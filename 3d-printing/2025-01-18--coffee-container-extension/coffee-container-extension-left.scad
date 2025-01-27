use <coffee-container-extension.scad>

rotate([0, 0, -45])
intersection() {
    container();
    rotate([0, -90, 0]) cylinder(r=10000, h=10000);
}