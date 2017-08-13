// ============================================================================
// NOTES:
//
// Printing resolution: Fine
// Fill: default (40%)
//
// ============================================================================

include <definitions.scad>
use <gears.scad>

gears_wheel();
echo("Wheele hole diameter = ", WHEEL_HOLE_DIAMETER);

module wheel_plate() {
    difference() {
        cylinder(r=gears_wheel_radius(inner=true)-TOLERANCE);

        translate([0, 0, -ATOM])
        scale([1, 1, WHEEL_PLATE_THICKNESS+ATOM*2])
        cylinder(r=SERVO_SCREW_THREAD_DIAMETER/2 + TOLERANCE);
    }
}

wheel_plate();

// TODO: Screw stuff