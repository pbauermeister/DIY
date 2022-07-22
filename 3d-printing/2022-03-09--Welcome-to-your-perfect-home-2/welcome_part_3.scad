// https://www.thingiverse.com/thing:3317484/files

$fn=30;

LAYER_H0 = .17;
LAYER_V0 = .10;
LAYER_H = LAYER_H0 *3;
LAYER_V = LAYER_H0 *3;

D = 200;

PLAY = .17;
ATOM = 0.001;

////////////////////////////////////////////////////////////////////////////////

module _plateau_1() {
   import("orig/Plateau_1.stl");
}

module plateau_2() {
   import("orig/Plateau_2.stl");
}

////////////////////////////////////////////////////////////////////////////////

module plateau_1a() {
    difference() {
        _plateau_1();
        translate([-D/2, 0, -D/2])
        cube([D, D, D]);
   }
   tabs();
}

module plateau_1b() {
    difference() {
        _plateau_1();
        translate([-D/2, -D, -D/2]) cube([D, D, D]);
        tabs(extra_h=.5, extra_d= .17*2);
   }
}

module stand_up() {
    translate([0, 0, 96])
    rotate([0, 90, 0])
    children();
}

module plateau_2r() {
    stand_up()
    plateau_2();
}

module plateau_1ar() {
    stand_up()
    plateau_1a();
}

module plateau_1br() {
    stand_up()
    plateau_1b();
}

////////////////////////////////////////////////////////////////////////////////

module tabs(extra_h=0, extra_d=0) {
    for(i=[0:2]) {
        D = 8;
        S = 3.5;
        translate([i*63.1-80 -S, D*.45 *.9, 0])
        tab(extra_h, extra_d);

        translate([i*63.1 - 80 +33.65 +S, D*.45 *.9, 0])
        tab(extra_h, extra_d);
    }
}

module tab(extra_h=0, extra_d=0) {
    D = 8;
    DD = D + extra_d;

    cylinder(d=DD, h=DD+extra_h);

    if(0)
    translate([-4, 1, 0]) {
        hull() {
            translate([0, 2, 0])
            cylinder(d=DD, h=DD+extra_h);

            translate([DD-2, -DD/2-1, 0])
            cube([.1, .1, DD+extra_h]);
            
            translate([DD+3, -DD/2-1, 0])
            cube([.1, .1, DD+extra_h]);
        }
    }
}

////////////////////////////////////////////////////////////////////////////////

LAYER = .1;
SUPPORT_SIZE = 8;
SUPPORT_WIDTH = 42;
SUPPORT_TEETH = 4;

module cubelet() {
    cube([LAYER_H, LAYER_H, LAYER_V]);
}

module cubelet2() {
    cube([LAYER_H, ATOM, LAYER_V]);
}

module cubelet3() {
    cube([ATOM, LAYER_H, LAYER_V]);
}

module support1_pillar_full(hh, recess) {
    translate([7+SUPPORT_SIZE, 0, 0]) 
    intersection() {
        scale([recess?.5*.985:.5, 1, 1])
        //scale([.5, 1, 1])
        cylinder(r=SUPPORT_WIDTH - recess + LAYER_H*2, h=hh);
        translate([recess, -SUPPORT_WIDTH*2, 0]) cube([50, SUPPORT_WIDTH*4, hh]);
    }

    if (recess) {
        rr = SUPPORT_WIDTH*.58;
        translate([0, 0, rr+2])
        rotate([0, 90, 0])
        cylinder(r=rr, h=hh);
    }
}

module support1(support_extra, h, recess, is_bottom) {
    hh = h - LAYER_V*2 *1;
    step = SUPPORT_WIDTH / SUPPORT_TEETH;
    translate([7 + LAYER_H - support_extra + recess, -LAYER_H/2, hh + recess])
    for (y=[-SUPPORT_WIDTH:step:SUPPORT_WIDTH-step]) {
        translate([0, y, 0])
        hull() {
            //translate([0, step/2, 0]) cube([LAYER_H, LAYER_H, LAYER_V]);
            translate([0, step/2, 0]) cube([ATOM, ATOM, LAYER_V]);
            translate([SUPPORT_SIZE + support_extra, 0, 0]) cubelet();
            translate([SUPPORT_SIZE + support_extra, step, 0]) cubelet();
            translate([SUPPORT_SIZE + support_extra, step/2, -SUPPORT_SIZE*.7 - support_extra - 1]) cubelet();
        }
    }
    
    translate([0, 0, is_bottom?LAYER_V0*2:-recess]) 
    support1_pillar_full((recess?hh*2:hh)+LAYER_V, recess);
}

module support1_one(support_extra, h, z, is_bottom=false) {
    translate([0, 0, z])
    difference() {
        support1(support_extra, h, 0);
        support1(support_extra, h, LAYER_H, is_bottom=is_bottom);
    }
}

module supports_1(extra1, extra2, extra3) {
    color("red")
    support1_one(extra1, 62.95 +.4, 0, is_bottom=true);

    color("green")
    support1_one(extra2, 62.95 + .7, 62.9-.2);

    color("blue")
    support1_one(extra3, 62.95 + .7, 125.7);
}

////////////////////////////////////////////////////////////////////////////////

module support_2_one() {
    difference() {
        color("grey") union() {
            translate([-3, -ATOM, 0])
            hull() {
                translate([0, -48, 45.1])
                cubelet2();
                translate([0, -48 +9, 45.1])
                cubelet2();
                translate([0, -48, 45.1-9])
                cubelet2();
            }
            translate([2.4, -ATOM, 0])
            hull() {
                translate([0, -48, 45.1])
                cubelet2();
                translate([0, -48 +9, 45.1])
                cubelet2();
                translate([0, -48, 45.1-9])
                cubelet2();
            }
          
            translate([ATOM*2, ATOM*10, -1.2])
            hull() {
                translate([-3.1, -48, 45.1 +1])
                cubelet3();
                translate([15.2, -48, 45.1 +1])
                cubelet3();
                translate([-3.1, -48, 45.1 -9 -3.1+3+2])
                cubelet3();
                translate([15.2, -48, 45.1 -9-15.2-3.1+3+1])
                cubelet3();
            }
            
            
            
            
            
            hull() {
                x = 15.08;
                translate([x, -48, 45.1 -.1])
                cubelet2();
                translate([x, -48+6, 45.1 -.1])
                cubelet2();
                translate([x, -48+6, 45.1 -33 -.3])
                cubelet2();
                translate([x, -48, 45.1 -33+9-.3])
                cubelet2();
            }


        }

        translate([-11, -48 +.05, 0])
        {
            translate([LAYER_H, -LAYER_H0/2, -LAYER_V0*2])
            plateau_1br();        

        }
    }
}

module supports_2() {
    support_2_one();
    translate([0, 0, 63]) support_2_one();
    translate([0, 0, 63*2]) support_2_one();
}

module supports(extra1, extra2, extra3) {
    translate([0, -2, 0])
    supports_1(extra1, extra2, extra3);
    supports_2();
}

////////////////////////////////////////////////////////////////////////////////

module part_2() {
    intersection() {
        union() {
            translate([-11, -48 +.05, 0]) plateau_1br();
            //supports(4.1, 4.1, 4.1);
        }
        if (0) translate([0, 0, 0]) cube(500);
    }
    
    if(0)
    translate([0, 51, 0]) {
        cube([8, LAYER_H, 180]);

        translate([-4, -2, 0])
        cube([8*2, 8*2, LAYER_V0*2]);
    }
}

part_2();
