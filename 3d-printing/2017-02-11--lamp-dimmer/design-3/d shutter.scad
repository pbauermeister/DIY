difference() {
    union() {
        linear_extrude(height=1.5)
        scale([10, 10, 1])
        import("d1 shutter.dxf");

        linear_extrude(height=1.5 +3.2)
        scale([10, 10, 1])
        import("d2 shutter.dxf");

        linear_extrude(height=2.5)
        scale([10, 10, 1])
        import("d3 shutter.dxf");
    }

    linear_extrude(height=20)
    scale([10, 10, 1])
    import("0 crops.dxf");
}
