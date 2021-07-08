module barrel(outer_radius, inner_radius, height) {
    scale([1, 1, height])
    difference() {
        cylinder(r=outer_radius);
        translate([0, 0, -0.5]) scale([1, 1, 2])
        cylinder(r=inner_radius);
    }
}

$fn = 90;

barrel(38/2, 36.5/2, 20);

linear_extrude(height=1.5)
scale(0.35, 0.35, 1)
import("bottom.dxf");