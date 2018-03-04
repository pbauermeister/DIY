// Density: 40%
// Quality: Fine

include <definitions.scad>
use <parts.scad>

PLATE_THICKNESS = 0.8;
PLATE_WIDTH = 44;
PLATE_HEIGHT = 17;
FONT_SIZE = 6;
FONT = "Arial:style=Bold";
FONT_THICKNESS = 0.4;
FONT_SPACING = 1.2;

module write(text, valign) {
    scale([0.8, 1, 1]) // make font narrow
    linear_extrude(height=FONT_THICKNESS)
    text(text, halign="center", valign=valign,
         size=FONT_SIZE, font=FONT, spacing=FONT_SPACING);
}

// Tenons
for (i=[-1, 1])
    translate([i*LOGO_TENONS_DISTANCE/2, 0, PLATE_THICKNESS])
    cylinder(d=LOGO_TENONS_DIAMETER - TOLERANCE*8.1, h=LOGO_TENONS_HEIGHT);

K = 1.2;
scale([K, K, 1])
difference() {
    // Plate
    translate([0, 0, PLATE_THICKNESS/2 + ATOM])
    cube([PLATE_WIDTH, PLATE_HEIGHT, PLATE_THICKNESS], true);

    // Engraved texts
    translate([0.5, +1, 0]) write("FABLAB", valign="bottom");
    translate([0.5, -1, 0]) write("FRIBOURG", valign="top");
 }
 
translate([0, 12, 0])
 cylinder(d=1.5, h=0.4);
