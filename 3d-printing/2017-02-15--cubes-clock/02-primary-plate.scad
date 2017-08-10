// TODO: Screw holes to tighten two together
// TODO: Clip caviti to clip to spine

include <definitions.scad>
use <gears.scad>
use <servo.scad>

//
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 10%
//

module make_plate_base() {
    scale([1, 1, PLATE_THICKNESS])
    cylinder(r=PLATE_DIAMETER/2);
}

module make_plate_base_cavities() {
    make_servo_cavity(with_clearance=true);
}

module make_plate_top() {
    translate([0, 0, PLATE_THICKNESS])
    cylinder(h=GEARS_THICKNESS + PLAY*2, r=PLATE_DIAMETER/2);
}

module make_plate_top_cavities() {
    translate([0, 0, PLATE_THICKNESS])
    {
        // pinion cavity
        cylinder(h=GEARS_THICKNESS*2, r=gears_pinion_radius()+PLAY);

        // wheel cavity
        translate([GEARS_DISTANCE, 0, 0])
        cylinder(h=GEARS_THICKNESS*2, r=gears_wheel_radius()+PLAY);

        // servo cavity ==> no hanging
        translate([0, 0, -PLATE_THICKNESS])
        make_servo_cavity();
    }
}

module make_servo_hull(with_clearance=false) {
    translate([GEARS_DISTANCE, 0, PLATE_THICKNESS + PLAY])
    servo_hull(with_clearance=true);
}

module make_servo_cavity(with_clearance=false) {
    for(i=[0:PLATE_THICKNESS])
        translate([0, 0, i])
        make_servo_hull(with_clearance);
}

module plate() {
    difference() {
        make_plate_base();        
        // remove overlap
        cylinder(h=PLATES_OVERLAP/2, r=PLATE_DIAMETER*0.6);
        // screw hole
        cylinder(h=PLATE_THICKNESS, r=SCREW2_DIAMETER/2);
    }
    make_plate_top();

    if (1) {
        // servo ghost
        %make_servo_hull();
        translate([GEARS_DISTANCE, 0, PLATE_THICKNESS + PLAY])
        %gears_wheel();

        translate([0, 0, PLATE_THICKNESS + PLAY])
        %gears_pinion();
    }
}

module plate_cavities() {
    make_plate_base_cavities();
    make_plate_top_cavities();
}

//
// ALL
//

module plate_all() {
    difference() {
        union() {
            // this plate
            plate();

            // opposite plate
            translate([0, 0, PLATES_OVERLAP])
            rotate([180, 0, 90])
            %plate();
        }

        union() {
            // this cavity
            plate_cavities();

            // opposite cavity
            translate([0, 0, PLATES_OVERLAP])
            rotate([180, 0, 90])
            plate_cavities();
        }
    }
}

difference() {
    plate_all();
//    translate([0,0,-50]) cube(100);
}