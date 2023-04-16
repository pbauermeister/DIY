/* Charging base for LED lamps.
 */

HAS_HEEL          = false;

CONTACT_WIDTH     =   2.5;
CONTACT_THICKNESS =   0.2;
CONTACT_LENGTH    =  15.0;

DIAMETER          =  85.5;
THICKNESS         =   8.2 - CONTACT_THICKNESS*2;
SPACING           =   5.0;
BORDER            =   8.0;
TOLERANCE         =   0.2  +.1;
PLAY              =   0.5;

BAR_LENGTH        =  DIAMETER+BORDER*2+SPACING;
BAR_WIDTH         =  DIAMETER*.75;
BAR_DIST          =  16.0  + 8;

LAMP_DIAMETER     = 102.5;
LAMP_THICKNESS    =   8.2;
LAMP_HEIGHT       = 150.0;
LAMP_SCREW_POS    =  37.0  -.5;
LAMP_SCREW_D1     =   3.5  -.5;
LAMP_SCREW_D2     =   6.0  -.5;

LAMP_HEEL_HEIGHT  = THICKNESS -TOLERANCE + CONTACT_THICKNESS*2;
LAMP_HEEL_INNER_R = 30;

HANDLE_LENGTH     =  DIAMETER/2 + BORDER + LAMP_THICKNESS/2 + 10;

HUB_L = 65.0 +1;
HUB_W = 30.0 +1;
HUB_H =  9.0 +1;

CONTACTS_ROT = [90-30-15, 0, -90+30+15];

SPAR_DIAMETER = 4.3;
CABLE_CANAL_THICKNESS = 4;

ATOM      = 0.01;
$fn = 90;


use <base-carver.scad>

module hub_cutout(plug=false) {
    rotate([0, 0, -90])
    translate([-HUB_L/2, -10, -16*0]) {
        cube([HUB_L, HUB_W, HUB_H]);


        if (plug) {
            // space for nut
            d = 10;
            translate([HUB_L/2 -d/2, -3+ATOM, 0])
            cube([d, 3, HUB_H]);

            // plug
            w = 15;
            l = (DIAMETER-HUB_L)/2 +2;
            difference() {
                translate([-l+1, -w/2 + HUB_W/2, 0])
                cube([l, w, HUB_H]);

                // de-brim
                t = .15;
                translate([-t, -w/2 + HUB_W/2, -HUB_H+.3])
                cube([t, w, HUB_H]);

            }
        }
    }
}

module disc(shave=false) {
    cylinder(d=DIAMETER, h=shave ? LAMP_HEEL_HEIGHT : THICKNESS);
}

module half_disc(rot=false, shave=false) {
    difference() {
        disc(shave);

        rotate([0, 0, -90 + (rot?180:0)])
        translate([-DIAMETER/2, (shave ? -PLAY : 0) + 20*(shave?-1:1), -THICKNESS])
        cube([DIAMETER, DIAMETER, THICKNESS*3]);
    }
}

module lamp_contact(rot) {
    % color("orange")
    rotate([0, 0, -45*0-90 + rot]) {
        translate([-CONTACT_WIDTH/2, DIAMETER/2-CONTACT_LENGTH, THICKNESS*2+CONTACT_THICKNESS]) 
        cube([CONTACT_WIDTH, CONTACT_LENGTH, CONTACT_THICKNESS]);
        
        translate([-0.5 -CONTACT_WIDTH/2, CONTACT_LENGTH/2 - CONTACT_WIDTH/2, -CONTACT_THICKNESS])
        translate([-CONTACT_WIDTH/2, DIAMETER/2-CONTACT_LENGTH, THICKNESS*2+CONTACT_THICKNESS]) 
        cube([6, CONTACT_WIDTH, CONTACT_THICKNESS]);
    }
}

module bar(extra_shave=0, shave_base=false) {
    difference() {
        // bar
        shorten = extra_shave ? .5 : 0;
        translate([0, -BAR_WIDTH/2, -ATOM])
        cube([BAR_LENGTH-BAR_DIST - shorten, BAR_WIDTH, THICKNESS - 2*0]);

        // joinery
        th = 6+2.5;
        intersection() {
            // mortises
            union()
            for (y=[-DIAMETER/4-th:th*2:DIAMETER/4+th]) {
                hull() {
                    translate([-ATOM, y+.25 - th/4, THICKNESS])
                    cube([BAR_LENGTH, th*1.5, .1]);


                    translate([-ATOM, y+.25 + th/4, -.5])
                    cube([BAR_LENGTH, th/2, .1]);
                }

                if (shave_base) {
                    translate([-ATOM, y+.25 + th/4 -1, -.5])
                    cube([BAR_LENGTH, th/2+2, THICKNESS]);
                }

            }
            // limit mortises into cylinder
            translate([DIAMETER + BORDER*2 + SPACING, 0, -1])
            scale([1, 1, 2])
            disc();
        }
        translate([DIAMETER + BORDER*2 + SPACING, 0, THICKNESS-1-extra_shave])
        disc();

    }
}

module handle(has_switch=false) {
    difference() {
        r = THICKNESS;
        l = HANDLE_LENGTH -r;
        hull() {
            translate([0, -BAR_WIDTH/2, -ATOM])
            cube([l, BAR_WIDTH, THICKNESS - 2*0]);

            translate([l, -BAR_WIDTH/2 + r, 0])
            cylinder(r=r, h=THICKNESS);

            translate([l, BAR_WIDTH/2 - r, 0])
            cylinder(r=r, h=THICKNESS);
        }

        hull() {
            translate([HANDLE_LENGTH, BAR_WIDTH/3.5, 0])
            sphere(d=THICKNESS);

            translate([HANDLE_LENGTH, -BAR_WIDTH/3.5, 0])
            sphere(d=THICKNESS);
        }
    }
}

module switch_cutout() {
    r = THICKNESS;
    d = 10;
    d2 = 4;
    translate([HANDLE_LENGTH-d/2 - r/2, BAR_WIDTH/2-d/2-r/2, -2]) {
        cylinder(d=d, h=THICKNESS);
        cylinder(d=d2, h=THICKNESS*2);
    }

    translate([0, 0, -.5])
    hull() {
        translate([HANDLE_LENGTH-d/2 - r/2, BAR_WIDTH/2-d/2-r/2, 0])
        cylinder(d=d2, h=THICKNESS/2);

        cylinder(d=d2, h=THICKNESS/2);
    }

}

module base(first=false, last=false) {
    difference() {
        // body
        union() {
            disc();
            translate([0, 0, THICKNESS]) half_disc(true);

            if (!first) {
                bar(extra_shave=TOLERANCE*2, shave_base=true);
            }
            
            if (first)
                handle(true);

            if (last)
                rotate([0, 0, 180])
                handle();

        }
        if (first)
            switch_cutout();

        // cutout for joinery
        if (!last) {
            translate([-BAR_LENGTH, 0, 0])
            minkowski() {
                bar();
                cube(TOLERANCE*2, center=true);
            }
        }

        // cutouts for contacts
        for (a1=CONTACTS_ROT) {
            rotate([0, 0, a1]) {
                for (a2=[-1,1]) {
                    translate([DIAMETER/2-CONTACT_LENGTH/2, 3*a2, 0])
                    cube([CONTACT_WIDTH+.5, 1, THICKNESS*5], center=true);
                }
                translate([DIAMETER/2-CONTACT_LENGTH/2, 0, 0])
                cylinder(d=10, h=HUB_H*2 +3, center=true);

                if(a1 == 0)
                translate([0, 0, HUB_H*.75])
                hull() {
                    translate([DIAMETER/2-CONTACT_LENGTH/2, 0, 0])
                    cylinder(d=3, h=HUB_H/2, center=true);
                    cylinder(d=3, h=HUB_H/2, center=true);
                }
            }
        }

        d = last||first? (DIAMETER/2+4) *(first?-1:1) : 0 ;

        // Cutout for all cables
        translate([d, 0, 5])
        cube([DIAMETER*2, 2, 4], center=true);

        // Cutout for spar
        translate([d, 0, 4-.5])
        rotate([0, 90, 0])
        cylinder(d=SPAR_DIAMETER, h=DIAMETER*2, center=true);

        // hub
        translate([0, 0, -ATOM*2])
        hub_cutout(plug=first);
    }
    
    // de-brim
    th = .1;
    if(!last)
        translate([-BAR_DIST+th, -3, 0])
        cube([th, 6, .25]);

    if(!first)
        translate([BAR_LENGTH-DIAMETER/2, -3, 0])
        cube([th, 6, .25]);
}

module lamp() {
    difference() {
        cylinder(d=LAMP_DIAMETER, h=LAMP_HEIGHT);
        translate([0, 0, -LAMP_HEIGHT+LAMP_THICKNESS])
        cylinder(d=LAMP_DIAMETER-LAMP_THICKNESS*2, h=LAMP_HEIGHT);
    }
}


module lamp_heel() {
    h_head = .5;
    h_th = 1.5;
    difference() {
        half_disc(shave=true);

        angle = 30;
        angle_offset = 15*1.5; //17 + .9;

        translate([0, 0, .7])
        for (a=[0:angle*2:360])
            rotate([0, 0, a+angle_offset])
            rotate_extrude(angle=angle/2) {
            translate([LAMP_SCREW_POS, -h_th, 0]) rotate([0, 0, 90]){
                translate([-h_head, -LAMP_SCREW_D2/2, 0])
                square([LAMP_HEEL_HEIGHT, LAMP_SCREW_D2]);

                translate([0, -LAMP_SCREW_D1/2, 0])
                square([LAMP_HEEL_HEIGHT+h_th+ATOM, LAMP_SCREW_D1]);
                
                hull() {
                    translate([LAMP_HEEL_HEIGHT, -LAMP_SCREW_D1/2, 0])
                    square([.01, LAMP_SCREW_D1]);

                    translate([LAMP_HEEL_HEIGHT-h_head, -LAMP_SCREW_D2/2, 0])
                    square([.01, LAMP_SCREW_D2]);
                }
            }
        }

        // cutout for button
        cube([LAMP_HEEL_INNER_R*2, LAMP_HEEL_INNER_R/2, LAMP_HEEL_HEIGHT*4], center=true);
    }
}

module move_for_printing() {
    translate([DIAMETER*.67*0, -DIAMETER*.25 -3, LAMP_HEEL_HEIGHT])
    rotate([0, 180, -90])
    children();
}


module all() {
    union() {
        base(first=true);
        for (rot=CONTACTS_ROT) {
            lamp_contact(rot);
        }
    }

    translate([-DIAMETER-BORDER*2-SPACING, 0, 0]) { //translate([DIAMETER + BORDER*2 + SPACING, 0, 0]) {
        base();
        %translate([0, 0, THICKNESS]) lamp();
    }

    //translate([0, 0, THICKNESS+TOLERANCE]) 
    move_for_printing()
    lamp_heel();
}

module first() {
    union() {
        carve_base()
        base(first=true);

        %translate([0, 0, THICKNESS]) lamp();

        for (rot=CONTACTS_ROT) {
            lamp_contact(rot);
        }
    }

    if (HAS_HEEL)
        move_for_printing()
        lamp_heel();
}

module second() {
    x = -DIAMETER-BORDER*2-SPACING;
    translate([x, 0, 0]) {
        carve_base()
        base();

        %translate([0, 0, THICKNESS]) lamp();
    }

    if (HAS_HEEL)
        translate([x, 0, 0]) 
        move_for_printing()
        lamp_heel();
}

module fourth() {
    x = -DIAMETER-BORDER*2-SPACING;
    translate([x*3, 0, 0]) {
        carve_base()
        base(last=true);

        %translate([0, 0, THICKNESS]) lamp();
    }

    if (HAS_HEEL)
        translate([x*3, 0, 0]) 
        move_for_printing()
        lamp_heel();
}


intersection() {
    translate([43+15, 0, 0]) union() {
        first();
        translate([-20, 0, 0])
        second();
    }
    //if(0) translate([-10, 0, 0])
    cube([80, 100, 17], true);
}
