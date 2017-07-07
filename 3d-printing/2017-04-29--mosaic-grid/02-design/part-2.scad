
rotate([0,0,90])
union() {
    linear_extrude(height=.8) 
    scale([10, 10, 1])
    import("part-2a.dxf");
 
    linear_extrude(height=1)
    scale([10, 10, 1])
    import("part-2b.dxf");
}
 