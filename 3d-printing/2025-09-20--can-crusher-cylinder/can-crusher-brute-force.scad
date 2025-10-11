use <../chamferer.scad>

INNER_DIAMETER   =  73;
INNER_DIAMETER_2 =  57;
INNER_HEIGHT     = 180;

WALL_THICKNESS  =   10 *2;
BASE_THICKNESS  =   20;
TOLERANCE       =    4;

CAN_HEIGHT       = 170;
CAN_HEIGHT_2     = 116;
CAN_DIAMETER     =  67;
EXTRA_HEIGHT     =  20;

CH = 5;

ATOM = 0.01;

$fn = $preview?15:100;

D_EXT = INNER_DIAMETER + TOLERANCE*2 + WALL_THICKNESS*2;
D_INT = D_EXT - WALL_THICKNESS*2;;

module can() {
//    cylinder(d=CAN_DIAMETER, h=CAN_HEIGHT);
    %cylinder(d=CAN_DIAMETER, h=CAN_HEIGHT_2);
}

module pillar() {
    d = 170; //D_EXT*2;
    cylinder(d=d,h=BASE_THICKNESS);

    translate([0, 0, BASE_THICKNESS])
    cylinder(d1=d, d2=D_EXT, h=CAN_HEIGHT/2);
}


module pillars() {
    for (i=[0:2]) rotate([0, 0, i*120])
    intersection() {
        pillar();

        hull() {
            cylinder(d=D_EXT, h=CAN_HEIGHT*2);
            translate([D_EXT*2, 0, 0])
            cylinder(d=D_EXT, h=CAN_HEIGHT*2);
        }
    }
}

module centerer() {
    h = 7*sqrt(2);
    l = D_EXT * 3;
    th = .07;

    for (i=[0:2]) rotate([0, 0, i*120]) {
        translate([0, 0, BASE_THICKNESS*4])
        rotate([0, -45, 0])
        translate([-l, -th/2, 0])
        cube([l, th, h]);
    }
}

module chamber() {
    d_ext = D_EXT;
    d_int = D_INT;

    h_ext = CAN_HEIGHT + BASE_THICKNESS + EXTRA_HEIGHT;
    translate([0, 0, BASE_THICKNESS]) intersection() {
        echo(d_int);
        cylinder(d=d_int, h=h_ext-BASE_THICKNESS+ATOM*10);

        d = INNER_DIAMETER*4;
        translate([0, 0, d/2])
        sphere(d=d);

        translate([0, 0, -BASE_THICKNESS*2.2])
        cylinder(d1=0, d2=h_ext*1.5*2, h=h_ext*2);
    }
}


module crusher_lower() {
    d_ext = D_EXT;
    h_ext = CAN_HEIGHT + BASE_THICKNESS + EXTRA_HEIGHT;
    difference() {
        chamferer($preview ? 0: CH, "cone")
        union() {
            cylinder(d=d_ext, h=h_ext);
            pillars();
        }
        
        chamber();
        centerer();
    }
}

module centerer2(z) {
    h = 7*sqrt(2);
    l = (INNER_DIAMETER/2+h)*sqrt(2);
    th = .07*2;

    for (i=[0:2]) rotate([0, 0, i*120]) {
        intersection() {
            translate([h, 0, z])
            rotate([0, -45, 0])
            translate([-l, -th/2, 0])
            cube([l, th, h]);
            
            ma = .1;
            translate([-INNER_DIAMETER/2 + ma, -th, 0])
            cube([INNER_DIAMETER/2 - ma*2, th*2, CAN_HEIGHT*2]);
        }
    }
}

module crusher_upper() {
    h = CAN_HEIGHT + EXTRA_HEIGHT + BASE_THICKNESS*0.5;
    difference() {
        chamferer($preview ? 0: CH, "cone", fn=8*5)
        cylinder(d=INNER_DIAMETER, h=h, $fn=200);
 
        //centerer2(h - INNER_DIAMETER/3);

        // base grooves
        for (r=[1:3:INNER_DIAMETER/2 - CH*1.5])
            scale([1, 1, .67])
            rotate_extrude(convexity = 10)
                translate([r, 0, 0])
                    circle(r=1, $fn=4);
                }
}

%translate([0, 0, BASE_THICKNESS]) can();

module all() {
    difference() {
        union() {
            crusher_lower();

            //translate([0, 0, CAN_HEIGHT_2])
            translate([0, 0, BASE_THICKNESS])
            %crusher_upper();
        }

        translate([-500, -1000, -500])
        cube(1000);
    }
}

//crusher_lower();
//crusher_upper();
all();

//%cylinder(d=75, h=100);