use <all.scad>

CUBE_WIDTH                   = 57;
CUBE_HEIGHT                  = 45;

THICKNESS                    =  1.2;

ATOM = 0.01;
dy = CUBE_HEIGHT / CUBE_WIDTH * sqrt(2)/2;

T = [
      [
        [ [02, 02], [02, 05], [09, 12], [11, 12] ],
        [ [02, 05-dy], [09, 12-dy] ],
        [ [13, 10], [13, 02] ]
      ],
      [
        [ [04, 12], [11, 12] ],
        [ [13, 10], [13, 03], [03+1, 01] ]
      ],
      [ [ [11, 12], [04, 12] ],
        [ [02, 10], [02, 03] ],
        [ [04, 01], [11, 01] ]
      ],
      [ [ [11, 12], [04,12] ],
        [ [02, 10], [02, 03] ],
        [ [04, 01], [11, 01] ],
        [ [13, 03], [13, 10] ]
      ]
    ];

B = [
      [
        [ [13, -01], [13, -10] ]
      ],
      [
        [ [02, -01], [02, -08] ],
        [ [04, -10], [11, -10] ],
        [ [13, -08], [13, -03] ]
      ],
      [
        [ [04, -10], [11, -10] ],
        [ [13, -08], [13, -01] ]
      ],
      [
        [ [04-1, -01], [11, -01] ],
        [ [13, -03], [13, -10] ]
      ]
];

D = [
      [0, 1], // 0
      [0, 0], // 1
      [1, 1], // 2
      [1, 2], // 3
      [0, 3], // 4
      [2, 2], // 5
      [2, 1], // 6
      [1, 0], // 7
      [3, 1], // 8
      [3, 2], // 9

      [],
      [0, 2],
      [1, 3],
      [2, 0],
      [2, 3],
      [3, 0],
      [3, 3],

];

module vertex(th=THICKNESS, grow=0) {
    d = sqrt(2);
    rotate([0, 0, 45]) {
        if (grow==0) {
            translate([-d/2, -d/2, 0])
            cube([d, d, th]);
        }
        else {
            cube([d, d, ATOM], center=true);

            translate([0, 0, th-ATOM])
            cube([d+grow/2, d+grow/2, ATOM], center=true);
        }
    }
}

module draw_segs(segs, th=THICKNESS, grow=0) {
    k = CUBE_HEIGHT / 15;
    scale([k, k, 1])
    for (i=[1:len(segs)-1]) {
        from = segs[i-1];
        to = segs[i];
        echo(from, to);

        hull() {
            kx = CUBE_WIDTH / CUBE_HEIGHT;
            x0 = from[0] * kx;
            y0 = from[1];
            translate([x0, y0, 0])
            vertex(th, grow);

            x1 = to[0] * kx;
            y1 = to[1];
            translate([x1, y1, 0])
            vertex(th, grow);
        }
    }
}

module frame() {
    border = 1.75;
    margin = .2;
    th = .8;
    c = CUBE_HEIGHT / 8;
    
    wext = CUBE_WIDTH  + border*2 + margin*2;
    hext = CUBE_HEIGHT + border*2 + margin*2;
    wint = CUBE_WIDTH  + margin*2;
    hint = CUBE_HEIGHT + margin*2;

    // frame
    difference() {
        translate([-border-margin, -border-margin, 0])
        cube([wext, hext, th]);

        translate([-margin, -margin, -th/2])
        cube([wint, hint, th*2]);

        translate([-margin+c, -margin-.5, -th/2])
        cube([wint-c*2, hint+.5*2, th*2]);
    }
    
    // bars
    g = .7;
    dy = CUBE_HEIGHT/3;
    for (y=[dy, dy*2])
        translate([-border, y - g/2, .4])
        cube([CUBE_WIDTH+border*2, g, .3]);

    dx = CUBE_WIDTH/3;
    for (x=[dx, dx*2])
        translate([x - g/2, -border, .4])
        cube([g, CUBE_HEIGHT+border*2, .3]);
}

module upper(index, th=THICKNESS, grow=0) {
    for (segs=T[index]) {
        draw_segs(segs, th, grow);
    }
}

module lower(index, th=THICKNESS, grow=0) {
    for (segs=B[index]) {
        draw_segs(segs, th, grow);
    }
}

module all_parts() {
    for (i=[0:3])
        translate([CUBE_WIDTH*i, 3, 0])
        upper(i);

    for (i=[0:3])
        translate([CUBE_WIDTH*i, -3, 0])
        lower(i);
}

module stencile(upper) {
    tol_x = .15 *4;
    tol_y = .15 *2;
    th = .5*2;
    border = 5 + (tol_x + tol_y)/2;

    rotate([0, 180, 0])
    for (i=[0:3]) {
        x = (i%2) * (CUBE_WIDTH + border);
        y = floor(i/2) * (CUBE_HEIGHT + border);
        translate([x, y , 0])
        scale([1, 1, 1])
        difference() {
            union() {
                difference() {
                    translate([-border, -border, -1])
                    cube([CUBE_WIDTH+border*2, CUBE_HEIGHT+border*2, 2]);
                    
                    translate([0, 0, -th -ATOM-2])
                    translate([-tol_x/2, -tol_y/2, 0])
                    cube([CUBE_WIDTH+tol_x, CUBE_HEIGHT+tol_y, 3]);
                }                
            }

            //%translate([0,0,-5]) cube([CUBE_WIDTH, CUBE_HEIGHT, 20]);
            translate([0, 0, 1-th -ATOM])
            if (upper)
                upper(i, th + ATOM*2, th);
            else
               translate([0, CUBE_HEIGHT, 0])
               lower(i, th + ATOM*2, th);
        }
    }
}

module all_faces_upper() {
    stencile(true);
}

module all_faces_lower() {
    stencile(false);
}

module digit(i) {
    d = D[i];
    if (len(d)) {
        upper(d[0]);
        
        //translate([0, -1, 0])
        lower(d[1]);
    }
}

module all_digits() {
    for (i=[0:len(D)-1]) {
        dx = (sqrt(2)-1) * CUBE_WIDTH / 2;
        translate([(CUBE_WIDTH + dx)*i, CUBE_WIDTH, 0])
        digit(i);
    }
}

////////////////////////////////////////////////////////////////////////////////////////

//!all_parts();
!all_faces_upper();
//!all_faces_lower();
//!all_digits();
