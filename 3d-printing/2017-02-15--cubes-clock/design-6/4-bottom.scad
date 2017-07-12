/*
 * (C) 2017 by Pascal Bauermeister.
 * License: Creative Commons Attribution-NonCommercial-ShareAlike 2.5.
 */

include <definitions.scad>
use <Getriebe.scad>
use <2-servo-holder.scad>
use <5-body.scad>


MODULE = 0.9;

dist = -BODY_RADIUS + TRANSMISSION_RADIUS_OUTER - TRANSMISSION_RADIAL_SHIFT;

module bottom_servo_wheel() {
    translate([0, SERVO2_DISPLACEMENT, PLAY])
    pfeilrad(modul=MODULE, zahnzahl=30, hoehe=BOTTOM_WHEELS_THICKNESS - PLAY*2,
              bohrung=SERVO2_AXIS_RADIUS*2, eingriffswinkel=20, schraegungswinkel=30);
}

module bottom_transmission_wheel() {
    color("red")
    translate([0, dist, 0])
    rotate([0, 0, -15])
    {
        difference() {
            union() {
                // wheel
                pfeilrad(modul=MODULE, zahnzahl=7, hoehe=BOTTOM_WHEELS_THICKNESS,
                         bohrung=0, eingriffswinkel=20, schraegungswinkel=-30);
                
                // ring
                translate([0, 0, BOTTOM_WHEELS_THICKNESS])
                scale([1, 1, TRANSMISSION_WHEEL_OVERLAP])
                cylinder(r=TRANSMISSION_WHEEL_RADIUS, h=1, true);
            }
            
            // hole in ring
            translate([0, 0, BOTTOM_WHEELS_THICKNESS])
            scale([1, 1, TRANSMISSION_WHEEL_OVERLAP])
            translate([0, 0, TOLERANCE])
            cylinder(r=TRANSMISSION_RADIUS_INNER+TOLERANCE, h=1, true);

            // hole in wheel
            scale([1, 1, BOTTOM_WHEELS_THICKNESS*1.5])
            translate([0, 0, -.125])
            cylinder(r=TRANSMISSION_AXIAL_HOLE_RADIUS+TOLERANCE*2, h=1, true);
        }
    }
}

module bottom_plate() {
//    %
    union() {

        difference() {
            union() {
                translate([0, 0, -BOTTOM_PLATE_THICKNESS])
                scale([1, 1, BOTTOM_WHEELS_THICKNESS+BOTTOM_PLATE_THICKNESS])
                cylinder(r=BODY_RADIUS, true);

                translate([0, 0, BOTTOM_WHEELS_THICKNESS])
                intersection() {
                    servo2_cavity();
                    scale([1, 1, BOTTOM_SERVO_SNAP_THICKNESS])
                    cylinder(r=BODY_RADIUS, true);
                }
            }
            
            // transmission wheel
            translate([0, dist, -PLAY])
            scale([1, 1, BOTTOM_WHEELS_THICKNESS + BOTTOM_SERVO_SNAP_THICKNESS + ATOM])
            cylinder(r=TRANSMISSION_RADIUS_OUTER+PLAY, h=1, true);

            // servo wheel
            translate([0, SERVO2_DISPLACEMENT, 0])
            scale([1, 1, BOTTOM_WHEELS_THICKNESS + BOTTOM_SERVO_SNAP_THICKNESS + ATOM])
            cylinder(r=BOTTOM_SERVO_WHEELS_MAX_RADIUS+PLAY, h=1, true);
            
            // for the screws
            translate([0, 0, BOTTOM_WHEELS_THICKNESS])
            body_screws_cavity();
        }
    }
    
    // contact for servo wheel
    translate([0, SERVO2_DISPLACEMENT, 0])
    scale([1, 1, PLAY])
    cylinder(r=SERVO2_AXIS_RADIUS + 0.25, true);

    // contact for transmission wheel
    translate([0, dist, -PLAY])
    scale([1, 1, PLAY])
    cylinder(r=TRANSMISSION_RADIUS_INNER, true);

    // pin for wheel
    translate([0, dist, 0])
    scale([1, 1, BOTTOM_WHEELS_THICKNESS-PLAY])
    cylinder(r=TRANSMISSION_AXIAL_HOLE_RADIUS, h=1, true);
}

bottom_servo_wheel();
bottom_transmission_wheel();
bottom_plate();
