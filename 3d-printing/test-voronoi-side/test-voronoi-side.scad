/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */


minkowski() {
    linear_extrude(height=0.1)
    import("test-voronoi-side.dxf");

    //sphere(0.1);
}
