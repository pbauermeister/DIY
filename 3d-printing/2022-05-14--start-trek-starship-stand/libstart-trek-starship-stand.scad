
$fn = 90;

THICKNESS = 6;

module rear_grip() {
    translate([1, 0, -1.5 -.5])
    cube([2, THICKNESS, 4], center=true);

    translate([0.2, 0, 0])
    difference() {
        resize([5/2, 4, 4]) sphere(d=5);

        translate([3, 0, 0]) cube(6, center=true);
        translate([0, 0, 3]) cube(6, center=true);

        translate([-.5, 0, -2]) cube([1, 1, 2], center=true);
    }
}

module front_grip() {
    dh = 1;

    translate([-.4, 0, -1+dh/2])
    cube([3.1, THICKNESS, 6+dh], center=true);
    
    translate([.2, 0, 2+dh])
    difference() {
        //rotate([0, -15, 0])
        resize([9/2, 9, 7])
        sphere(d=9);
        
        translate([0, 0, 5]) 
        cube(10, center=true);

        translate([2.2+.5, 0, 6]) 
        rotate([0, 45, 0])
        cube(10, center=true);
    }
}

module gripper() {
    translate([0, 0, 3.5]) {
        d = 1.25;
        front_grip();
        translate([35.25+d, 0, 0]) rear_grip();

        translate([0, -THICKNESS/2, -3.5 -.5])
        cube([35.25+1+d, THICKNESS, 1.5]);
    }
}

D = 4;
inner = 25;
outer = inner + 2* D-2;
BALL_D = D * 2.4;

module foot() {
    difference() {
        translate([0, 0, inner/2+1])
        rotate([90, 0, 0])
        intersection() {
            difference() {
                cylinder(d=outer, h=THICKNESS, center=true);
                cylinder(d=inner, h=THICKNESS+1, center=true);
            }
            translate([inner/2, 0, 0]) cube(inner, center=true);
        }

        translate([D*2, 0, D/2])
        rotate([0, 45, 0])
        translate([0, 0, -D*2])
        cube([D*4, D*4, D*4], center=true);
    }
    translate([D*2, 0, D/2])
    sphere(d=BALL_D);
}

module arm() {
    intersection() {
        union() {
            translate([0, 0, inner]) gripper();
            foot();
        }
        cube([1000, THICKNESS, 1000], center=true);
    }
}

module joint(hollow=true, recess=0){
    translate([D*2, 0, 0]) {
        play = .2;
        d = BALL_D;
        wall = 1.3+play;
        d2 = d+wall*2;
        diameter = 60 ;

        difference() {
            translate([0, 0, D/2]) sphere(d=d2-recess);
            
            if (hollow) {
                rotate([0, 45, 0])
                translate([-d/2, 0, d+d/2 * .9])
                cube(d*2, center=true);

                translate([0, 0, D/2]) sphere(d=d+play);
                hull() {
                    translate([0, 0, D/2])   scale([.8, 1.1, .8]) sphere(d=d+play);
                    translate([d, 0, D/2+d]) scale([.8, 1.1, .8]) sphere(d=d+play);
                }

                if(0)
                translate([0, 0, -d/2 -.5])
                cylinder(d=inner*3, h=2);
            }
        }
    }
}

module plate() {
    difference() {
        translate([D*2, 0, 0]) {
            diameter = 70 ;
            d = BALL_D;

            for (a=[0, 120, 240]) {
                rotate([0, 0, a+60])
                rotate([0, 5, 0]) {
                    translate([diameter/2, 0, -d/2+1+1 -.5])
                    rotate([90, 0, 0])
                    cylinder(r=1.5, h=d/2, center=true);
                    hull() {
                        translate([0, -d/2, -d/2+1+1 -.5])
                        cube([0.001, d, 3]);

                        translate([0, -d/4, -d/2+1+1 -.5])
                        cube([diameter/2, d/2, 1.5]);
                    }
                }
            }
        }
        joint(hollow=false);
    }
}

module plate() {
    difference() {
        translate([D*2, 0, -.75]) {
            diameter = 80 ;
            d = BALL_D;

            for (a=[0, 120, 240]) {
                rotate([0, 0, a+60]) {
                    k=.6;
                    scale([k, 1, 1])
                    translate([0, 0, -d/4 + 1]) {
                        rotate([90, 0, 0]) hull(){
                            intersection() {
                                cylinder(r=3, h=diameter/2);
                                translate([-3, -3*0, 0])
                                cube([6, 6, diameter/2]);
                            }
                            translate([-.2, -3, 0])
                            cube([.4, .1, diameter/2]);
                        }
                        translate([0, 0, -.5])
                        rotate([90, 0, 0])
                        translate([-.25 /k, -3, 0])
                        cube([.5 /k, .5, diameter/2]);

                        translate([0, -diameter/2+3, -3/2 -.25])
                        cube([6, 6, 3.5], center=true);
                    }
                }
            }
        }
        joint(hollow=false, recess=.5);
    }
}


//arm();

plate();
joint();