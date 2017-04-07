$fn = 180;

SIZE = 80;

module base(thickness) {
    difference() {
        cube([SIZE, SIZE, thickness]);
        translate([73, 73, 0]) cylinder( 20, 2.4, 2.4,true);
    }
}

scale([6.5/8, 6.5/8, 1]) {
    difference() {
        base(0.4);
        
        translate([0, 0, -0.5])
        linear_extrude(h=1) 
        scale([10, 10, 1])
        import("Roger.dxf");
    }
}
