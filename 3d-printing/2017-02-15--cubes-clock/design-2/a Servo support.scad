
intersection() {
    union() {
        linear_extrude(height=2)
        scale([10, 10, 1])
        import("a Servo support.dxf");

        linear_extrude(height=4)
        scale([10, 10, 1])
        import("a2 Servo support.dxf");

        linear_extrude(height=16)
        scale([10, 10, 1])
        import("a3 Servo support.dxf");
    }
    translate([8, 9, -5])
    cube([40, 40, 30]);
}