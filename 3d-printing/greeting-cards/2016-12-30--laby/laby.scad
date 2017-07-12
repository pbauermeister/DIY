/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 *
 * Greeting card.
 *
 * 2D vector files used as card base and bmp map.
 */

linear_extrude(height = 0.4) { 
    import("Laby-base.dxf"); 
}

linear_extrude(height = 0.8) { 
    import("Laby-top.dxf"); 
}
