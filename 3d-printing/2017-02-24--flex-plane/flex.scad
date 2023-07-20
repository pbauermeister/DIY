/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 *
 * Flex plane. Almost a fabric.
 *
 * 2D vector files used as base.
 */

module draw_path(path, i, wall) {
    hull() {
        translate([path[i][0], path[i][1], 0])     rotate([0, 0, 0]) cylinder(d=wall, h=1);
        translate([path[i+1][0], path[i+1][1], 0]) rotate([0, 0, 0]) cylinder(d=wall, h=1);
    }
    if (i < len(path)-2) {
        draw_path(path, i+1, wall);
    }
}
  
module tile(wall=.8, shave_x=true, shave_y=true) {
    paths = [
        [
            [0, 4], [0, 0], [4, 0], [4, 3], [2, 3], [2, 2], [3, 2], [3, 1], [1, 1],
            [1, 4], [4, 4]
        ],
        [   [4, 4], [8, 4], [8, 7], [6, 7], [6, 6], [7, 6], [7, 5], [5, 5], [5, 8],
            [shave_x?8:9, 8]
        ],
        [
            [0, shave_y?8:9], [0, 5], [3, 5], [3, 7], [2, 7], [2, 6], [1, 6], [1, 8], [4, 8],
            [4, 4]
        ],
        [   [5, 4], [5, 0], [8, 0], [8, 2], [7, 2], [7, 1], [6, 1], [6, 3],
            [shave_x?8:9, 3]
        ]
    ];

    for (path=paths) {
        draw_path(path, 0, wall);
    }
}

module tiles(size_x, size_y, n_x,  n_y, thickness, wall=.8) {
    kx = size_x / n_x / 9;
    ky = size_y / n_y / 9;
    max_i = n_x - 1;
    max_j = n_y - 1;
    for (i=[0:max_i]) {
        for (j=[0:max_j]) {
            translate([i*size_x/n_x, j*size_y/n_y, 0])
            scale([kx, ky, thickness])
            tile(wall=wall, shave_x=i==max_i, shave_y=j==max_j);
        }
    }
}

tiles(100, 100, 4, 4, thickness=5, wall=.55, $fn=4);
