// servo frame
translate([90, 0, 0])
difference()
{
    union() {
        linear_extrude(height=4)
        scale([10, 10, 1]) import("02-frame-layer1.dxf");

        linear_extrude(height=8)
        scale([10, 10, 1]) import("02-frame-layer2.dxf");
    }

    translate([0, 0, 1])
    linear_extrude(height=2)
    scale([10, 10, 1]) import("02-frame-cavity.dxf");
}

// ratchet
BAR_THICKNESS = 2.5;
translate([0, 0, 0]) {
    linear_extrude(height=BAR_THICKNESS)
    scale([10, 10, 1]) import("02-ratchet-layer1.dxf");

    linear_extrude(height=BAR_THICKNESS + 2.7)
    scale([10, 10, 1]) import("02-ratchet-layer2.dxf");
}
