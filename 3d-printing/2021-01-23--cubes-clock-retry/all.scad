include <definitions.scad>
use <support-bottom-1.scad>

// center-right

support_bottom_1();

%translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);
%translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, CUBE_HEIGHT+1])
cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

// right

translate([SPACING_SMALL, 0, 0])
support_bottom_1();

translate([SPACING_SMALL, 0, 0])
//rotate([0, 0, 45])
%translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

translate([SPACING_SMALL, 0, 0])
//rotate([0, 0, 45])
%translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, CUBE_HEIGHT+1])
cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

// center-left

translate([-SPACING_SMALL -SPACING_CENTRAL, 0, 0])
support_bottom_1();

translate([-SPACING_SMALL -SPACING_CENTRAL, 0, 0])
%translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);
translate([-SPACING_SMALL -SPACING_CENTRAL, 0, 0])
%translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, CUBE_HEIGHT+1])
cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

// left

translate([-SPACING_SMALL*2 -SPACING_CENTRAL, 0, 0])
support_bottom_1();

translate([-SPACING_SMALL*2 -SPACING_CENTRAL, 0, 0])
%translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, 0])
cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);
translate([-SPACING_SMALL*2 -SPACING_CENTRAL, 0, 0])
%translate([-CUBE_WIDTH/2, -CUBE_WIDTH/2, CUBE_HEIGHT+1])
cube([CUBE_WIDTH, CUBE_WIDTH, CUBE_HEIGHT]);

translate([-BASE_LENGTH+SPACING_SMALL+CUBE_WIDTH/2,
           -CUBE_WIDTH/2,
           -20-CUBE_RAISE])
%cube([BASE_LENGTH, CUBE_WIDTH, 20]);
echo(BASE_LENGTH);