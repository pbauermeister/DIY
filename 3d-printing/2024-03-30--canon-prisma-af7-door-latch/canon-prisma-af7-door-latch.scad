
WIDTH          = 10;
LENGTH         = 10 -2;
THICKNESS      =  0.5;

TAB_LENGTH     = 3;
TAB_WIDTH      = 8;
TAB_THICKNESS  = 1 +.5;

KNOB_LENGTH    = 3;
KNOB_WIDTH     = 9;
KNOB_THICKNESS = 1.5;
KNOB_XPOS      = .5;

ATOM           = 0.01;

module latch() {
    cube([LENGTH, WIDTH, THICKNESS]);

    intersection() {
        translate([0, (WIDTH-TAB_WIDTH)/2, THICKNESS])
        cube([TAB_LENGTH, TAB_WIDTH, TAB_THICKNESS]);

        translate([sqrt(TAB_WIDTH)*1.3, (WIDTH-TAB_WIDTH)/2 + TAB_WIDTH/2, 0])
        translate([0, 0, THICKNESS+TAB_THICKNESS/2])
        rotate([0, 0, 45])
        cube([TAB_WIDTH, TAB_WIDTH, TAB_THICKNESS+ATOM], center=true);
        
    }

    translate([KNOB_XPOS, (WIDTH-KNOB_WIDTH)/2, -KNOB_THICKNESS])
    cube([KNOB_LENGTH, KNOB_WIDTH, KNOB_THICKNESS]);
}

rotate([90, 0, 0])
latch();

// supports
translate([-1, .7, 0]) cube([5, 1, .4]);
translate([-1, -2, 0]) cube([5, 1, .4+.5]);