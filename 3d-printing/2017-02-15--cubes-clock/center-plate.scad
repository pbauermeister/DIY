// ============================================================================
// NOTES:
// Library file. To be imported via the use <> statement.
// You can render it for test, but do not export to STL.
//
// ============================================================================

include <definitions.scad>
use <gears.scad>
use <servo.scad>

ghost = !true;

module center_plate_base() {
    scale([1, 1, PLATE_HEIGHT])
    cylinder(r=PLATE_DIAMETER/2);
}

module center_plate_base_cavities(upside_down, with_cable_slot, with_servo_well) {
    center_plate_servo_cavity(upside_down=upside_down,
                      with_cable_slot=with_cable_slot,
                      with_servo_well=with_servo_well);
}

module center_plate_top() {
    translate([0, 0, PLATE_HEIGHT])
    cylinder(h=GEARS_THICKNESS + PLAY*2, r=PLATE_DIAMETER/2);
}

module center_plate_top_cavities() {
    translate([0, 0, PLATE_HEIGHT])
    {
        // pinion cavity
        cylinder(h=GEARS_THICKNESS*2, r=gears_pinion_radius()+PLAY);

        // wheel cavity
        translate([GEARS_DISTANCE, 0, 0])
        cylinder(h=GEARS_THICKNESS*2, r=gears_wheel_radius()+PLAY*2);

        // servo cavity ==> no hanging
        translate([0, 0, -PLATE_HEIGHT])
        center_plate_servo_cavity(false, true, false);
    }
}

module center_plate_servo_hull(with_clearance=false,
                       with_cable_slot=false,
                       with_screw_cavities=false,
                       is_clearance_hole=false) {
    translate([GEARS_DISTANCE, 0, PLATE_HEIGHT + PLAY]) {
        servo_hull(with_clearance, with_cable_slot);
        if (with_screw_cavities)
            servo_screw_cavity(is_clearance_hole=is_clearance_hole);
    }
}

module center_plate_servo_cavity(upside_down=false, with_cable_slot=true, with_servo_well=false) {
    for(i=[0:PLATE_HEIGHT])
        translate([0, 0, i])
        center_plate_servo_hull(
            with_clearance=i==0&&upside_down,
            with_cable_slot=i==0&&with_cable_slot,
            with_screw_cavities=i==0,
            is_clearance_hole=!upside_down);

    if (with_servo_well)
        translate([GEARS_DISTANCE, 0, -PLATE_HEIGHT+ATOM])
        cylinder(r=SERVO_THICKNESS/2, h=PLATE_HEIGHT);
}

module center_plate_body() {
    difference() {
        center_plate_base();        

        // remove overlap
        translate([0, 0, -ATOM])
        cylinder(h=PLATES_OVERLAP/2+ATOM, r=PLATE_DIAMETER*0.6);

        // pinion screw hole
        translate([0, 0, PLATE_HEIGHT-SCREW2_HEIGHT+ATOM])
        cylinder(h=SCREW2_HEIGHT,
                 r=SCREW2_DIAMETER/2 - TOLERANCE*2); // <== Adjust with tolerance

    }

    center_plate_top();

    if (ghost) %union() {
        // servo ghost
        center_plate_servo_hull();
        translate([GEARS_DISTANCE, 0, PLATE_HEIGHT + PLAY])
        gears_wheel();

        translate([0, 0, PLATE_HEIGHT + PLAY])
        gears_pinion();
    }
}

module center_plate_cavities(upside_down, with_cable_slot, with_servo_well) {
    center_plate_base_cavities(upside_down, with_cable_slot, with_servo_well);
    if(!upside_down)
        center_plate_top_cavities();
}

module center_plate_holder_cavity(has_holder_stop) {
    z = has_holder_stop ? PLATES_OVERLAP/2: 0;
    length = PLATE_DIAMETER/2-HOLDER_ARM_RADIUS_SHORTAGE;
    height = has_holder_stop ? HOLDER_ARM_HEIGHT+TOLERANCE : PLATE_HEIGHT*2;

    rotate([0, 0, 45]) {
        // hole for holder arm
        translate([-HOLDER_ARM_RADIUS_SHORTAGE, 0, z -ATOM]) {
            cylinder(h=height, r=HOLDER_ARM_RADIUS+TOLERANCE);
            translate([-length, -HOLDER_ARM_THICKNESS/2-TOLERANCE, 0])
            cube([length,
                  HOLDER_ARM_THICKNESS+TOLERANCE*2,
                  height+ATOM]);
        }

        // hole for screw to holder
        if (has_holder_stop)
            translate([-HOLDER_ARM_RADIUS_SHORTAGE, 0,
                       PLATES_OVERLAP/2+HOLDER_ARM_HEIGHT + WALL_THICKNESS*1.5])
            screw(head_extent=PLATE_HEIGHT, is_clearance_hole=true);
    }
}

//
// ALL
//

module  center_plate(is_short=false, has_holder_stop=true, has_servo_cavities=true) {
    translate([0, 0, -PLATES_OVERLAP/2])
    difference() {
        union() {
            // this plate
            center_plate_body();

            // opposite plate
            if (ghost)
                translate([0, 0, PLATES_OVERLAP])
                rotate([180, 0, 90])
                %plate();
        }

         center_plate_holder_cavity(has_holder_stop);

        if (has_servo_cavities) union() {
            // this cavity
            if (!is_short)
                 center_plate_cavities(upside_down=false, with_cable_slot=false, with_servo_well=false);

            // opposite cavity
            translate([0, 0, PLATES_OVERLAP])
            rotate([180, 0, 90])
            center_plate_cavities(upside_down=true, with_cable_slot=!is_short, with_servo_well=is_short);
        }
    }
}

difference() {
     center_plate();
//    translate([0,0,-50]) cube(100);
}

//translate([PLATE_DIAMETER + 20, 0, 0])
// center_plate(has_holder_stop=false);
