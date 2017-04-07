difference() {
    union() {
        linear_extrude(height=3)
        scale([10, 10, 1])
        import("b ring.dxf");
    }

    linear_extrude(height=20)
    scale([10, 10, 1])
    import("0 crops.dxf");
}