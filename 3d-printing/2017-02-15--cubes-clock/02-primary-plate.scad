// ============================================================================
// NOTES:
//
// Printing resolution: Normal (not draft, not fine)
// Fill: 15%
//
// ============================================================================

include <definitions.scad>
use <gears.scad>
use <servo.scad>

ghost = !true;

module make_plate_base() {
    scale([1, 1, PLATE_THICKNESS])
    cylinder(r=PLATE_DIAMETER/2);
}

module make_plate_base_cavities(upside_down, with_cable_slot, with_servo_well) {
    make_servo_cavity(upside_down=upside_down,
                      with_cable_slot=with_cable_slot,
                      with_servo_well=with_servo_well);
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
        cylinder(h=GEARS_THICKNESS*2, r=gears_wheel_radius()+PLAY*2);

        // servo cavity ==> no hanging
        translate([0, 0, -PLATE_THICKNESS])
        make_servo_cavity(false, true, false);
    }
}

module make_servo_hull(with_clearance=false,
                       with_cable_slot=false,
                       with_screw_cavities=false,
                       is_clearance_hole=false) {
    translate([GEARS_DISTANCE, 0, PLATE_THICKNESS + PLAY]) {
        servo_hull(with_clearance, with_cable_slot);
        if (with_screw_cavities)
            servo_screw_cavity(is_clearance_hole=is_clearance_hole);
    }
}

module make_servo_cavity(upside_down=false, with_cable_slot=true, with_servo_well=false) {
    for(i=[0:PLATE_THICKNESS])
        translate([0, 0, i])
        make_servo_hull(
            with_clearance=i==0&&upside_down,
            with_cable_slot=i==0&&with_cable_slot,
            with_screw_cavities=i==0,
            is_clearance_hole=!upside_down);

    if (with_servo_well)
        translate([GEARS_DISTANCE, 0, -PLATE_THICKNESS+ATOM])
        cylinder(r=SERVO_THICKNESS/2, h=PLATE_THICKNESS);
}

module plate() {
    difference() {
        make_plate_base();        

        // remove overlap
        translate([0, 0, -ATOM])
        cylinder(h=PLATES_OVERLAP/2+ATOM, r=PLATE_DIAMETER*0.6);

        // pinion screw hole
        translate([0, 0, PLATE_THICKNESS-SCREW2_HEIGHT+ATOM])
        cylinder(h=SCREW2_HEIGHT,
                 r=SCREW2_DIAMETER/2 - TOLERANCE*2); // <== Adjust with tolerance

    }

    make_plate_top();

    if (ghost) %union() {
        // servo ghost
        make_servo_hull();
        translate([GEARS_DISTANCE, 0, PLATE_THICKNESS + PLAY])
        gears_wheel();

        translate([0, 0, PLATE_THICKNESS + PLAY])
        gears_pinion();
    }
}

module plate_cavities(upside_down, with_cable_slot, with_servo_well) {
    make_plate_base_cavities(upside_down, with_cable_slot, with_servo_well);
    if(!upside_down)
        make_plate_top_cavities();
}

module holder_cavity(has_holder_stop) {
    z = has_holder_stop ? PLATES_OVERLAP/2: 0;
    length = PLATE_DIAMETER/2-HOLDER_ARM_RADIUS_SHORTAGE;
    height = has_holder_stop ? HOLDER_ARM_HEIGHT+TOLERANCE : PLATE_THICKNESS*2;

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
            screw(head_extent=PLATE_THICKNESS, is_clearance_hole=true);
    }
}

//
// ALL
//

module primary_plate(is_short=false, has_holder_stop=true) {
    translate([0, 0, -PLATES_OVERLAP/2])
    difference() {
        union() {
            // this plate
            plate();

            // opposite plate
            if (ghost)
                translate([0, 0, PLATES_OVERLAP])
                rotate([180, 0, 90])
                %plate();
        }

        holder_cavity(has_holder_stop);

        union() {
            // this cavity
            if (!is_short)
                plate_cavities(upside_down=false, with_cable_slot=false, with_servo_well=false);

            // opposite cavity
            translate([0, 0, PLATES_OVERLAP])
            rotate([180, 0, 90])
            plate_cavities(upside_down=true, with_cable_slot=!is_short, with_servo_well=is_short);
        }
    }
}

difference() {
    primary_plate();
//    translate([0,0,-50]) cube(100);
}

translate([PLATE_DIAMETER + 20, 0, 0])
primary_plate(has_holder_stop=false);
