
// wheel
{
    linear_extrude(height=1)
    scale([10, 10, 1]) import("01-base-disc-layer1.dxf");

    linear_extrude(height=4)
    scale([10, 10, 1]) import("01-base-disc-layer2.dxf");
}

// servo frame
translate([85, 0, 0]) {
    linear_extrude(height=4)
    scale([10, 10, 1]) import("01-base-servo-layer1.dxf");

    linear_extrude(height=4)
    scale([10, 10, 1]) import("01-base-servo-layer2.dxf");

    linear_extrude(height=10)
    scale([10, 10, 1]) import("01-base-servo-layer4.dxf");

    linear_extrude(height=2.2)
    scale([10, 10, 1]) import("01-base-servo-layer3.dxf");

    linear_extrude(height=9.5)
    scale([10, 10, 1]) import("01-base-servo-layer5.dxf");
}

// bar
BAR_THICKNESS = 2.5;
translate([0, 85, 0]) {
    linear_extrude(height=BAR_THICKNESS)
    scale([10, 10, 1]) import("02-ratchet-layer1.dxf");

    linear_extrude(height=BAR_THICKNESS + 2.7)
    scale([10, 10, 1]) import("02-ratchet-layer2.dxf");
}
