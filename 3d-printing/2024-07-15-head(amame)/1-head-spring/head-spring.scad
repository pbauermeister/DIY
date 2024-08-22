
SCALE_X = .95;

module head_spring_0() {
    translate([-125, -105, 0])
    import("headbandSpringAndClamps_Cura.stl");

    if(0)
    translate([0, 0, 10])
    %cube([201+.1, 204, 20], center=true);

    reinforcement_plate();
    
    scale([-1, ,1 , 1])
    reinforcement_plate();

}

module reinforcement_plate() {
    translate([82.5 +1.75 , 45, 0]) {
        rotate([0, 0, 13.5]) {
            hull() {
                translate([0, 6, 0])
                cylinder(d=7, h=20, $fn=20);

                translate([.2, -8, 0])
                cylinder(d=7, h=20, $fn=20);
            }

            hull() {
                translate([.2, -8, 0])
                cylinder(d=7, h=20, $fn=20);

                translate([4.97, -33, 0])
                cylinder(d=2, h=20, $fn=20);
            }

            hull() {
                translate([0, 6, 0])
                cylinder(d=7, h=20, $fn=20);

                translate([-7.1, 25, 0])
                cylinder(d=1, h=20, $fn=20);
            }

        }
        
        //cylinder(d=1, h=50, center=true, $fn=12);
    }
    
}

module screw_holes_0(d, shift_inner, round, ball=false) {
    translate([83.13, 42.5, 0]) {
        for (xy=[[1.3,0], [0,5.1]]) {
            x = xy[0];
            y = xy[1];
            for (z=[4, 16]) {
                translate([0, y, z])
                rotate([0, 0, 11])
                translate([x+6.9 -shift_inner, 0, 0])
                if(ball) {
                    translate([0, .2, 0])
                    sphere(d=d, $fn=20.);
                } else if (round) {
                    translate([0, .2, 0])
                    rotate([0, 90, 0])
                    cylinder(d=d, h=20, center=true, $fn=20.);
                }
                else hull() {
                    rotate([0, 90, 0])
                    cylinder(d=d, h=20, center=true, $fn=20.);

                    translate([0, .4, 0])
                    rotate([0, 90, 0])
                    cylinder(d=d, h=20, center=true, $fn=20.);
                }
            }
        }
    }
}

module screw_holes_1(d=1.8, shift_inner=5, round=false, ball=false) {
    screw_holes_0(d, shift_inner, round, ball);
    scale([-1, ,1 , 1])
    screw_holes_0(d, shift_inner, round, ball);
}


module screw_holes(d=1.8, shift_inner=5, round=false, ball=false) {
    scale([SCALE_X, 1, 1])
    screw_holes_1(d, shift_inner, round, ball);
}


module partitioner() {
    cube([130, 300, 50], center= true);
    
    for (k=[1, -1]) scale([k, 1, 1]) {
        translate([81-10-1, 100, 0])
        rotate([0, 0, 13.5 + 30])
        cube([50, 100, 50], center=true);

        translate([50, 92+13/2, 0])
        rotate([0, 0, 13.5])
        cube([50, 100, 50], center=true);

        difference() {
            translate([96-.25, 90+1, 0])
            rotate([0, 0, 13.5 + 4])
            cube([50, 100, 50], center=true);

            translate([62.5, 50, 0])
            rotate([0, 0, 30])
            cube([30, 100, 51], center=true);
        }
    }
}

module head_spring_1(with_holes=true) {
    difference() {
        head_spring_0();
        if (with_holes) {
           screw_holes_1();
           %screw_holes_1();
        }
    }
}

module head_spring(with_holes=true) {
    scale([SCALE_X, 1, 1])
    head_spring_1(with_holes);
}

module center_part() {
    scale([SCALE_X, 1, 1])
    intersection() {
        head_spring_1();
        partitioner();
    }
}

module left_part() {
    scale([SCALE_X, 1, 1])
    difference() {
        head_spring_1();
        partitioner();
        
        translate([100, 0, 0])
        cube([200, 500, 50], center=true);
    }
}

module right_part() {
    scale([SCALE_X, 1, 1])
    difference() {
        head_spring_1();
        partitioner();

        translate([-100, 0, 0])
        cube([200, 500, 50], center=true);
    }
}


if (0) {
    head_spring();
//    scale([SCALE_X, 1, 1]) %partitioner();
} else {
    center_part();

    translate([25, 115, 0])
    rotate([0, 0, -90])
    right_part();

    translate([-25, 90, 0])
    rotate([0, 0, 90])
    left_part();
}