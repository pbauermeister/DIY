
intersection() {
    union() {
        linear_extrude(height=0.25)
        scale([10, 10, 1])
        import("e1 cog.dxf");

        linear_extrude(height=2.7)
        scale([10, 10, 1])
        import("e2 cog.dxf");

        linear_extrude(height=3)
        scale([10, 10, 1])
        import("e3 cog.dxf");
    }

    translate([40, 30, -1])
    cube([50, 40, 10]);
}