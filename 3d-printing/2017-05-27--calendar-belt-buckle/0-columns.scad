/*
PENTOMINO BLOCKS GENERATOR
==========================
(C) 2017 by Pascal Bauermeister.

(This is a part of the project "Pentomino Belt Buckle", focused on the
Pentomino pieces. It can however be used standalone. The other parts, not in this
file, include: frame, belt clip.)

This OpenSCAD script generates Pentomino blocks, with tabs and cavities to
allow them to hold together.

Being completely parametric allows individual control such as:
- size and thickness,
- tolerances (important for 3D printing), and also
- creating any kind of pieces, including 2D Polyminos of N cells for any N.

This is freeware. Enjoy and modify freely. You may kindly mention this project.
*/

// BLOCK
BLOCK_SIDE = 4.9;
BLOCK_HEIGHT = 3;
CHAMFER = 0.75 / sqrt(2);

// AXIS
AXIS_DIAMETER = BLOCK_SIDE*1.2;
AXIS_HEIGHT = 3;
MARK_DEPTH = 0.4;

// GRIP
GRIP_DIAMETER = BLOCK_SIDE / 2.5;

// PLATE
PLATE_THICKNESS = 0.6;
PLATE_MARGIN_V = 0.4;
PLATE_MARGIN_H = 0.6;

// COLUMNS
SPACING = 4;
BPB = 9;

ATOM = 0.001;

echo(BLOCK_SIDE*11);
echo(BLOCK_HEIGHT*7 + AXIS_HEIGHT*2);

_ = 0;

SPACER = [
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
    [_, _, _, _, _, _, _, _, _],
];

NUMBER_1 = [
    [2, 1, 1, 1, 1, 1, 1, 1, 2],
    [2, _, _, _, _, _, _, _, 2],
    [2, 1, 1, 1, _, _, _, 1, 2],
    [2, _, _, _, 1, 1, 1, _, 2],
];
NUMBER_2 = [
    [2, 1, _, _, _, _, _, 1, 2],
    [2, _, _, _, 1, _, _, _, 2],
    [2, 1, _, _, 1, _, _, 1, 2],
    [2, _, _, _, 1, _, _, 1, 2],
];
NUMBER_3 = [
    [2, 1, 1, 1, 1, 1, 1, 1, 2],
    [2, 1, _, _, 1, 1, 1, 1, 2],
    [2, 1, 1, 1, 1, _, _, _, 2],
    [2, _, _, _, 1, 1, 1, 1, 2],
];

COLUMNS = [
    NUMBER_1,
//    NUMBER_2,
//    NUMBER_3,
//    SPACER,
//    NUMBER_1, NUMBER_2, NUMBER_3,
//    SPACER,
//
//    [
//        [2, _, 1, _, _, _, _, 1, 2],
//        [2, 1, 1, 1, 1, 1, 1, 1, 2],
//        [2, _, 1, _, _, 1, 1, _, 2],
//        [2, _, _, _, _, _, _, _, 2],
//    ], [
//        [2, 1, _, _, _, _, _, 1, 2],
//        [2, _, _, _, 1, _, _, 1, 2],
//        [2, _, _, 1, 1, 1, 1, _, 2],
//        [2, 1, _, _, 1, _, _, 1, 2],
//    ], [
//        [2, 1, 1, 1, 1, 1, 1, 1, 2],
//        [2, _, _, _, _, _, _, 1, 2],
//        [2, _, 1, 1, _, _, 1, _, 2],
//        [2, 1, 1, 1, 1, 1, 1, _, 2],
//    ]
];


module plate(type, rotation) {
    if (type==1) {
        color("orange")
        rotate([0, 0, rotation])
        translate([0, -BLOCK_SIDE/2 + PLATE_THICKNESS/2 - ATOM, 0])
        cube([BLOCK_SIDE-PLATE_MARGIN_H*2, PLATE_THICKNESS, BLOCK_HEIGHT-PLATE_MARGIN_V*2], true);
    }

    if (type==2) {
        color("green")
        rotate([0, 0, rotation]) {
//            translate([-BLOCK_SIDE*.25 +CHAMFER/2, -BLOCK_SIDE/2 + PLATE_THICKNESS/2 - ATOM, 0])
//            sphere($fn=24, d=GRIP_DIAMETER, true);
//            translate([+BLOCK_SIDE*.25 -CHAMFER/2, -BLOCK_SIDE/2 + PLATE_THICKNESS/2 - ATOM, 0])
//            sphere($fn=24, d=GRIP_DIAMETER, true);
            translate([0, -BLOCK_SIDE/2 + PLATE_THICKNESS/2 - ATOM, 0])
            sphere($fn=24, d=GRIP_DIAMETER, true);
        }
    }
}

module make_cube(height) {
    intersection() {
        cube([BLOCK_SIDE, BLOCK_SIDE, height], true);

        d = BLOCK_SIDE * sqrt(2) -CHAMFER;
        rotate([0, 0, 45])
        cube([d, d, height], true);
    }
}


module make_block(column_nr, index) {
    translate([0, 0, BLOCK_HEIGHT*index]) {
        difference() {
            make_cube(BLOCK_HEIGHT);
            plate(COLUMNS[column_nr][0][index], 0);
            plate(COLUMNS[column_nr][1][index], 90);
            plate(COLUMNS[column_nr][2][index], 180);
            plate(COLUMNS[column_nr][3][index], 270);
        }
    }
}

module make_axis() {
    n = 4;
    
    intersection() {
        rotate([0, 0, 360/n/1])
        scale([1, 1, AXIS_HEIGHT])
        cylinder($fn=n, d=AXIS_DIAMETER*1, true);

        cube([BLOCK_SIDE, BLOCK_SIDE, AXIS_HEIGHT*2], true);

//        make_cube(AXIS_HEIGHT);
    }
}

module make_column(column_nr) {
    // pillar
    for (index=[0:BPB-1]) {
        make_block(column_nr, index);
    }

    // top axis and marking
    translate([0, 0, BLOCK_HEIGHT*(BPB-.5)]) {
        translate([0, 0, PLATE_MARGIN_V/2])
        make_cube(PLATE_MARGIN_V);

        difference() {
            make_axis();

            K = BLOCK_SIDE/6;
            color("yellow")  
            translate([-BLOCK_SIDE/3.0*K, -BLOCK_SIDE/3.4*K, AXIS_HEIGHT-MARK_DEPTH]) {
                scale([.36*K, .36*K, 1.5])
                linear_extrude(height=AXIS_HEIGHT)
                text(chr(65+column_nr), font = "Liberation Sans:style=Bold");
            }
        }
    }

    // bottom axis
    translate([0, 0, -AXIS_HEIGHT - BLOCK_HEIGHT/2])
    make_axis();

    translate([0, 0, -PLATE_MARGIN_V/2 - BLOCK_HEIGHT/2]) {
        make_cube(PLATE_MARGIN_V);
    }
}

module make_all() {
    for (column_nr=[0:len(COLUMNS)-1]) {
        pos_x = (BLOCK_SIDE+SPACING)*column_nr;
        translate([pos_x, 0, 0]) {
            make_column(column_nr);
        }
    }
}

rotate([-90, 0, 0])
make_all();


// End