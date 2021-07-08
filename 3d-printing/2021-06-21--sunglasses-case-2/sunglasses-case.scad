$fn = 36*2;

LENGTH    = 156;
WIDTH     =  41;
HEIGHT    =  54;
THICKNESS =   2.5;

LID_HEIGHT    = 16   /2;
LID_THICKNESS =  1;

EYELET_DIAMETER      = 6;
EYELET_HOLE_DIAMETER = 2.5;
   

PLAY = .3  +.15;

module body(outer=false, play=0) {
    intersection() {
        translate([0, HEIGHT, 0])
        rotate([90, 0, 0])
        linear_extrude(height=HEIGHT*2)
        resize([LENGTH, HEIGHT, 1])
        import(file="projection-front.dxf");

        linear_extrude(height=HEIGHT*2)
        resize([LENGTH -play*2, WIDTH -play*2, 1])
        import(file=outer?"projection-top.dxf":"projection-top-thick.dxf");
        
        rotate([30-2, 0, 0])
        translate([-LENGTH, 0, -LENGTH])
        cube([LENGTH*2, LENGTH, LENGTH*2]);
    }
}

module pattern() {
        linear_extrude(height=1)
        resize([LENGTH, WIDTH, 1])
        import("projection-top-pattern.dxf");
}

module case(play=0, for_carving=false) {
    difference() {
        union() {
            minkowski() {
                body(outer=true);
                sphere(r=THICKNESS+play, $fn=6);
            }
            if (!for_carving) {
                eyelet(lid=false);
            }
        }

        if (!for_carving) {
            eyelet(lid=false, outer=false);
            grip(carve=true);
        }

        body(play=play);

        translate([0, 0, HEIGHT + THICKNESS/2])
        cube([LENGTH*2, WIDTH*2, THICKNESS*2], center=true);
    }
}

module lid() {
    grip();
    difference() {
        d = THICKNESS * 2;
        union() {
            minkowski() {
                linear_extrude(height=LID_HEIGHT)
                resize([LENGTH + d*2, WIDTH + d*2, 1])
                import(file="projection-top.dxf");
                
                sphere(d=d, $fn=6);
            }
            eyelet();
        }

        translate([0, 0, LID_HEIGHT + LID_THICKNESS + .5])
        pattern();

        eyelet(outer=false);

        for (x=[-PLAY * 1.5, PLAY * 1.5]) {
            for (y=[-PLAY, PLAY]) {
                hull()
                translate([x, y, -HEIGHT+LID_HEIGHT-LID_THICKNESS - THICKNESS])
                case(for_carving=true, play=0);

                translate([x, y, -HEIGHT+LID_HEIGHT-LID_THICKNESS])
                case(for_carving=true, play=0);
            }
        }
    }
}

module eyelet(outer=true, lid=true) {
    k = 2.4;
    xpos = lid ? EYELET_DIAMETER*1.125 -.8 + .5 + EYELET_HOLE_DIAMETER/2: EYELET_DIAMETER*.2 -.1 +.2;
    zpos = lid ? -EYELET_DIAMETER*k / 2 + LID_HEIGHT + THICKNESS + .7: HEIGHT/2 + EYELET_DIAMETER/2;
    a    = lid ? 30 + 90: -30;
    translate([LENGTH/2 + xpos, 0, zpos])
    if (outer) {
        scale([1.2, 1.2, k]) hull() {
            translate([0,  EYELET_DIAMETER*.99, 0]) scale([1, .5, 1]) rotate([0, a, 0]) sphere(d=EYELET_DIAMETER, $fn=6);
            translate([0, -EYELET_DIAMETER*.99, 0]) scale([1, .5, 1]) rotate([0, a, 0]) sphere(d=EYELET_DIAMETER, $fn=6);
        }
    }
    else {
        rotate([90, 0, 0])
        cylinder(d=EYELET_HOLE_DIAMETER, h=WIDTH*.2, center=true);

       hull() {
           translate([10,  EYELET_DIAMETER*1.95, 0]) sphere(d=EYELET_HOLE_DIAMETER);
           translate([ 0,  EYELET_DIAMETER*1.95, 0]) sphere(d=EYELET_HOLE_DIAMETER);
       }
       hull() {
           translate([10, -EYELET_DIAMETER*1.95, 0]) sphere(d=EYELET_HOLE_DIAMETER);
           translate([ 0, -EYELET_DIAMETER*1.95, 0]) sphere(d=EYELET_HOLE_DIAMETER);
       }
       hull() {
            translate([0,  EYELET_DIAMETER*1.95, 0]) sphere(d=EYELET_HOLE_DIAMETER);
            translate([0, -EYELET_DIAMETER*1.95, 0]) sphere(d=EYELET_HOLE_DIAMETER);
        }
    }
}

module grip(carve) {
    extra_y = carve ? -.45 : -.2;
    extra_x = carve ? 0 : -1;
    z       = carve ? HEIGHT - LID_HEIGHT + LID_THICKNESS : -.25;
    for (y=[-1, 1]) {
        translate([0, y*(WIDTH/2 + .2 + THICKNESS + extra_y), z])
        for (i=[0:4])
            translate([0, 0, i])
            rotate([45, 0, 0])
            cube([10+extra_x, 1, 1], center=true);
    }
}

module all() {
    difference() {
        union() {
            case();
            translate([0, 0, HEIGHT -LID_HEIGHT+LID_THICKNESS + PLAY +15*0]) lid();
        }
        
        if (1)
        //translate([-LENGTH/2, WIDTH/2-2, 0])
        cube(LENGTH);
    }
}

SWITCH_ALL  = 1;
SWITCH_CASE = 2;
SWITCH_LID  = 3;
SWITCH_ALL2 = 4;
SWITCH_ALL3 = 5;

WHAT = SWITCH_LID;


if (WHAT==SWITCH_ALL)
    all();
else if (WHAT==SWITCH_CASE)
    case();
else if(WHAT==SWITCH_LID)
    intersection() {
        rotate([180, 0, 0]) lid();
        //cube([30, 50, 50], center=true);
    }
else if(WHAT==SWITCH_ALL2) {
    case();
    translate([0, -WIDTH + 3, LID_HEIGHT])
    rotate([180, 0, 0]) lid();
}
else if(WHAT==SWITCH_ALL3) {
    difference() {
        union() {
            case();
            translate([0, WIDTH*1.25, LID_HEIGHT])
            rotate([180, 0, 0]) lid();
        }
        translate([-LENGTH - LENGTH/4, -LENGTH/2, -LENGTH/4])
        cube(LENGTH);
    }
}
