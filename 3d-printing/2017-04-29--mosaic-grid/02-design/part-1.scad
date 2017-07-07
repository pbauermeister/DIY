
rotate([0,0,90])
union() {
    linear_extrude(height=.8) 
    scale([10, 10, 1])
    import("part-1a.dxf");
 
    linear_extrude(height=1.0)
    scale([10, 10, 1])
    import("part-1b.dxf");
}
 