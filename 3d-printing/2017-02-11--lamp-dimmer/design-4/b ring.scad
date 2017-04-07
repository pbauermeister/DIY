$fn = 180;
r = 30 +.3;

intersection() {
    union() {
        linear_extrude(height=3)
        scale([10, 10, 1])
        import("b1 ring.dxf");

        linear_extrude(height=6)
        scale([10, 10, 1])
        import("b2 ring.dxf");
    }
    
    translate([30, 30, -.25])
    scale([1, 1, 0.5])
    sphere(r=r);
}