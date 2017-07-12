/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 *
 * This gauge allows to determine the right size of vector tiles, for
 * your actual physical mosaic tiles.
 */

linear_extrude(height=1)
scale([10,10,1])
import("3-gauge-path.dxf");
