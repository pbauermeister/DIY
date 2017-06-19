
module encoder() {
    translate([-30, -30, -2.5/2]) {
        linear_extrude(height=2.5)
        scale([10, 10, 1])
        import("1a2 encoder.dxf");
    }
}

encoder();