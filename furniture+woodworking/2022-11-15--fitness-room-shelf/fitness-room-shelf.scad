/*
 * Shelf in fitness basement
 */

/*
Shelf        : 1660(TBC) x 250 x 28
Back plate   : 1660(TBC) x 980 x 10

Supports     : 2x : 1910 x 20 x 20
Steel tube

Wood screws      : 5 pc @ 28cm
Concrete screws  : 4 pc
Wood screws thin : 5 pc
Wood screws thin : 6 pc
*/


ROOM_HEIGHT  = 2300;
WALL_WIDTH   = 1660;
PILLAR_DEPTH =  190;
PILLAR_WIDTH =  250;
DEPTH        = 3000;

module pillar() {
    translate([-PILLAR_WIDTH, -PILLAR_DEPTH, 0])
    cube([PILLAR_WIDTH, PILLAR_DEPTH, ROOM_HEIGHT]);
}

module back_wall() {
    difference() {
        cube([WALL_WIDTH, .1, ROOM_HEIGHT]);

        r = 2000;
        translate([WALL_WIDTH+r -1400, 0, -r+90 + 800])
        rotate([90, 0, 0]) 
        cylinder(r=r, h=30, center=true, $fn=60);
    }
}

module side_wall() {
    translate([WALL_WIDTH, -DEPTH, 0])
    cube([.1, DEPTH, ROOM_HEIGHT]);
}

module ceiling() {
    translate([-PILLAR_WIDTH, -DEPTH, ROOM_HEIGHT])
    cube([PILLAR_WIDTH+WALL_WIDTH, DEPTH, .1]);
}

module floor() {
    translate([-PILLAR_WIDTH, -DEPTH, 0])
    cube([PILLAR_WIDTH+WALL_WIDTH, DEPTH, .1]);
}

module room() {
    color("#ddd") {
        pillar();
        back_wall();
        side_wall();
        ceiling();
    }
    color("#444")
    floor();
}

module computer() {
    translate([-560/2, -60, 0])
    color("black") {
        translate([560/2-100/2, 60-30, 0]) cube([100, 30, 130]);
        translate([0, 0, 130]) cube([560, 60, 390]);
        translate([560/2-300/2, -250 +60, 0])
        cube([300, 250, 20]);
    }
}


SHELF_LENGTH     = 1660;
SHELF_WIDTH      =  250;
SHELF_THICKNESS  =   28;
SHELF_ALTITUDE   = 1000;

SHELF_THICKNESS2 =   18;
SHELF_WIDTH2     =  150;

SHELF_BACK_THICKNESS = 10;
SHELF_SUPPORT_THICKNESS = 20;

module shelf_top() {
    echo(str("Shelf: ", SHELF_LENGTH, "(TBC) x ", SHELF_WIDTH, " x ", SHELF_THICKNESS));

    color("orange")
    cube([SHELF_LENGTH, SHELF_WIDTH, SHELF_THICKNESS]);
}

module shelf_base() {
    color("orange")
    cube([SHELF_LENGTH, SHELF_WIDTH2, SHELF_THICKNESS2]);
}

module shelf_center() {
    color("orange")
    cube([SHELF_THICKNESS2,
          SHELF_WIDTH2,
          SHELF_ALTITUDE-SHELF_THICKNESS2]);
}

BACK_COLOR = "white";

module shelf_back_narrow() {
    width  = WALL_WIDTH/2;
    height = SHELF_ALTITUDE;
    thickness = SHELF_BACK_THICKNESS;
    echo(str("Back plate: ", width, " x ", height, " x ", thickness));
    color(BACK_COLOR)
    cube([width-2, thickness, height]);
}

module shelf_back() {
    width  = WALL_WIDTH;
    height = SHELF_ALTITUDE - SHELF_SUPPORT_THICKNESS;
    thickness = SHELF_BACK_THICKNESS;
    echo(str("Back plate: ", width, "(TBC) x ", height, " x ", thickness));

    color(BACK_COLOR)
    cube([width, thickness, height]);
}

module shelf_supports() {
    echo(str("Supports: 2x : ", WALL_WIDTH+SHELF_WIDTH, " x ",
                                SHELF_SUPPORT_THICKNESS, " x ", SHELF_SUPPORT_THICKNESS));
    echo(    "Steel tube");
    echo(str("Wood screws      : 5 pc @ ", ceil(WALL_WIDTH/(6)/10), "cm"));
    echo(    "Concrete screws  : 4 pc");
    echo(    "Wood screws thin : 5 pc");
    echo(str("Wood screws thin : 6 pc"));
    
    color("orange") {
        cube([WALL_WIDTH, SHELF_SUPPORT_THICKNESS, SHELF_SUPPORT_THICKNESS]);

        translate([WALL_WIDTH-SHELF_SUPPORT_THICKNESS, -SHELF_WIDTH + SHELF_SUPPORT_THICKNESS, 0])
        cube([SHELF_SUPPORT_THICKNESS, SHELF_WIDTH, SHELF_SUPPORT_THICKNESS]);

        translate([0, -SHELF_WIDTH + SHELF_SUPPORT_THICKNESS, 0])
        cube([WALL_WIDTH, SHELF_SUPPORT_THICKNESS, SHELF_SUPPORT_THICKNESS]);

        translate([0, -SHELF_WIDTH + SHELF_SUPPORT_THICKNESS, 0])
        cube([SHELF_SUPPORT_THICKNESS, SHELF_WIDTH, SHELF_SUPPORT_THICKNESS]);

    }
}
////////////////////////////////////////////////////////////////////////////////

room();

translate([WALL_WIDTH*.25, 0, SHELF_ALTITUDE + SHELF_THICKNESS]) computer();

translate([0, -SHELF_WIDTH, SHELF_ALTITUDE]) shelf_top();

if (0) {
    translate([0, -SHELF_BACK_THICKNESS, 0]) shelf_back_narrow();
    translate([WALL_WIDTH/2+1, -SHELF_BACK_THICKNESS, 0]) shelf_back_narrow();
} else {
    translate([0, -SHELF_BACK_THICKNESS, 0]) shelf_back();
}

translate([0, -SHELF_SUPPORT_THICKNESS, SHELF_ALTITUDE-SHELF_SUPPORT_THICKNESS])
shelf_supports();
