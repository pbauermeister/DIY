$fn = 36*2;

LENGTH    = 156;
WIDTH     =  40;
HEIGHT    =  54;
THICKNESS =   1.5 +.5;

LID_HEIGHT    = 18;
LID_THICKNESS = 3;

PLAY = .2;

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
    }
}

module case(play=0) {
    difference() {
        minkowski() {
            body(outer=true);
            sphere(r=THICKNESS+play, $fn=6);
        }

        body(play=play);

        if(0)
        translate([0, 0, HEIGHT + THICKNESS/2])
        cube([LENGTH*2, WIDTH*2, THICKNESS*2], center=true);
    }
}

module lid() {
    difference() {
        d = THICKNESS * 2;
        minkowski() {
            linear_extrude(height=LID_HEIGHT)
            resize([LENGTH + d*2, WIDTH + d*2, 1])
            import(file="projection-top.dxf");
            
            sphere(d=d, $fn=6);
        }
        
        minkowski() {
            translate([0, 0, -HEIGHT+LID_HEIGHT-LID_THICKNESS])
            case();
            cylinder(r=PLAY, $fn=6, h=.1);
        }

        translate([0, 0, -HEIGHT+LID_HEIGHT-LID_THICKNESS*2])
        body();

        translate([0, 0, -HEIGHT+LID_HEIGHT-LID_THICKNESS - THICKNESS/2])
        resize([LENGTH - 8, WIDTH - 6, HEIGHT])
        body(outer=true);

    }
}


difference() {
    union() {
        case();
        //translate([0, 0, HEIGHT -LID_HEIGHT+LID_THICKNESS +.5]) lid();
    }
    
    //translate([-LENGTH/2, WIDTH/2-2, 0])
    cube(LENGTH);
}