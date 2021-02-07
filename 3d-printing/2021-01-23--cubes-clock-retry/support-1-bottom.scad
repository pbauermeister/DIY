include <definitions.scad>
use <supports.scad>

difference() {
    support_bottom();

    translate([0, 0, -CUBE_RAISE]) 
    adhesion();
}
