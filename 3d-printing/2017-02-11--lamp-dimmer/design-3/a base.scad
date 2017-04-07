
difference() {
    union() {
        linear_extrude(height=1.5)
        scale([10, 10, 1])
        import("a1 base.dxf");

        linear_extrude(height=4)
        scale([10, 10, 1])
        import("a2 base.dxf");

        linear_extrude(height=1.5+5.2 +2+0.6)
        scale([10, 10, 1])
        import("a3 base.dxf");
    }

    linear_extrude(height=20)
    scale([10, 10, 1])
    import("0 crops.dxf");
}