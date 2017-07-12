# MOSAIC STENCILE

Copyright: (C) by Pascal Bauermeister, 2017-04-29.

License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5 Generic (CC BY-NC-SA 2.5) https://creativecommons.org/licenses/by-nc-sa/2.5/legalcode

Summary: A 3D-printed stencile to place mosaic tiles precisely.

| 1-design.svg | Basic circles design (*) |
| 1-design-c.svg .. 1-design-c6.svg | Intermediate steps of the design |
| 1-design-c7.svg | Final design |
| 1-design-c8.svg .. 1-design-c10.svg | Slicing for 3D printer |
| design.odg | Slicing for printing on paper, to check design for proper size and serve as reference |
| n = 1..6 | For each slice n: |
| part-na.dxf | - Vector file (DXF export from svg): top part of stencile |
| part-nb.dxf | - Vector file: bottom part of stencile (spacing feet) |
| part-n.scad | - OpenSCAD project, using the DXF files |
| part-n.stl  | - 3D-printable file |


(*) Tile frames are strings of the Unicode character "square", with
font size adapted to real tiles (see sibling subdirectory
01-gauge). Strings are attached to the circle paths, with a spacing
such that they are equally spaced all around each circle.
