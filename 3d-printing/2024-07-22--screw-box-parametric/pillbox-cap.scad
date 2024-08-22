use <pillbox-body.scad>

ATOM = 0.01;

TEXT_RECESS = .5;

rotate([0, 0, 45])
difference() {
    pillbox_cap();

    translate([0, 0, TEXT_RECESS -4 +.07 - ATOM])
    rotate([0, 180, 0])
    linear_extrude(height=1)
    text("TOP", halign="center", valign="center",
         font="FreeSerif:style=Italic",
         spacing=1.1,
         size=16, $fn=50);
}