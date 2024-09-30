use <hexa-fidget-8x160.scad>


HEIGHT = get_height();
DIAMETER = get_diameter();

FOOT_HEIGHT = 30;
FOOT_WIDTH  = 30;
FOOT_THICKNESS = 2+1;
FOOT_TAB_THICKNESS = .7;

FOOT_HEIGHT_2 = 50;


TOLERANCE = .3;
$fn = 90;


module tab(foot_height) {
    for (a=[30, 150])
    rotate([0, 0, a]) {
        s = a<90?1:-1;
        h = HEIGHT/2;
        hull() {
            d = FOOT_THICKNESS;
            
            intersection() {
                translate([0, 0, foot_height])
                rotate([0, 22.5 * s, 0])
                translate([-FOOT_TAB_THICKNESS/2 -   FOOT_TAB_THICKNESS*.72*s, -d, -FOOT_TAB_THICKNESS/2])
                cube([FOOT_TAB_THICKNESS, FOOT_WIDTH/2 + d, HEIGHT]);

                rotate([0, 0, s==1 ? -30 : 180-150])
                translate([-FOOT_WIDTH/2, 0, foot_height])
                cube([FOOT_WIDTH, FOOT_WIDTH, h]);
            }
        }
    }
}

module _foot(foot_height) {
    for (a=[30, 150])
    rotate([0, 0, a]) {
        k = .1;
        s = a<90?1:-1;
        hull() {
            h = max(foot_height*k, 1);
            translate([s*.5, FOOT_WIDTH/2, foot_height-h])
            cylinder(d=FOOT_THICKNESS, h=h);

            translate([s*.5, 0, 0])
            cylinder(d=FOOT_THICKNESS, h=foot_height);
        }
    }
    tab(foot_height);

    translate([0, 0, foot_height*2+HEIGHT]) {
        difference() {
            scale([1, 1, -1])
            tab(foot_height);
            
            shave = 2.667;
            translate([0, 0, -foot_height - shave])
            cylinder(r=FOOT_WIDTH, h=HEIGHT/2);
        }
    }
}

module foot(foot_height) {
    difference() {
        _foot(foot_height);

    }
}

module blocker() {
    intersection() {
        foot(1.5);
        d = FOOT_WIDTH/3;
        cube([d, d, d*3], center=true);
    }
}

for (x=[0:2]) {
    translate([x*10, 0, 0]) rotate([0, 0, 60]){
        rotate([90, 0, 0])
        blocker();

        translate([0, 1, 0])
        rotate([90, 0, 0])
        scale([1, 1, -1])
        blocker();
    }
}