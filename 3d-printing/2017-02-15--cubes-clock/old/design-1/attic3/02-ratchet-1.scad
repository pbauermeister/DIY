
rotate([0, 0, -90]) {
    // wheel
    translate([0, 0, 0]) {
        linear_extrude(height=2)
        scale([10, 10, 1]) import("02-wheel-layer1.dxf");

        linear_extrude(height=6)
        scale([10, 10, 1]) import("02-wheel-layer2.dxf");
    }

    // cogs
    translate([0, 120, 0]) {
        linear_extrude(height=3)
        scale([10, 10, 1]) import("02-cogs-layer1.dxf");

        linear_extrude(height=7)
        scale([10, 10, 1]) import("02-cogs-layer2.dxf");
    }
}