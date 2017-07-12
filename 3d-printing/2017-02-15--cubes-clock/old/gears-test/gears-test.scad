
difference() {
    // bottom layer
    linear_extrude(height=3) scale([10, 10, 1])
    import("gears-test-layer1.dxf");

    // cavity    
    translate([0, 0, 1])
    linear_extrude(height=3) scale([10, 10, 1])
    import("gears-test-layer3-dig.dxf");
}

// axis
linear_extrude(height=6) scale([10, 10, 1]) import("gears-test-layer2.dxf");

