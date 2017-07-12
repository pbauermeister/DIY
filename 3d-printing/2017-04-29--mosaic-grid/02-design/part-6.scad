/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */
 
rotate([0,0,90])
union() {
    linear_extrude(height=.8) 
    scale([10, 10, 1])
    import("part-6a.dxf");
 
    linear_extrude(height=1)
    scale([10, 10, 1])
    import("part-6b.dxf");
}
 