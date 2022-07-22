
FONT_SIZE = 10;
FONT = "Arial:style=Bold";
FONT_THICKNESS = 0.4;
FONT_SPACING = 1.2;

module write(text, valign) {
    scale([0.8, 1, 2]) // make font narrow
    linear_extrude(height=FONT_THICKNESS)
    text(text, halign="center", valign=valign,
         size=FONT_SIZE, font=FONT, spacing=FONT_SPACING);
}


scale([.66, .66, .80])
//scale([.5, 1.5, 1.5])
difference() {
    import("BC-box.stl");
    translate([0, -45, 1-.2])
    rotate([0, 0, 180]) write("P.Bauermeister");
}
