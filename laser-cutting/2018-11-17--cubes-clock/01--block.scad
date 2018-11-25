include <definitions.scad>
use <servo.scad>
use <plate.scad>
use <gears.scad>
use <rods.scad>
use <servo-holder.scad>
use <box.scad>

////////////////////////////////////////////////////////////////////////////////

SERVO_H_ANGLE = 90+180;

module _block(thickness, thickness2, height, no_cuts, extra_holders) {
	t = abs(($t-.5)*2) * 270 ; echo($t);
	
	// holder
	translate([-GEARS_DISTANCE, 0, 0])
	rotate([0, 0, 270]) {
		dz = thickness + TOLERANCE/4*0;

		// lower holders
		for (i=[0:1+extra_holders]) {
			even = i%2==0;
			color(even ? "lightblue" : "skyblue")
			translate([0, 0, -dz*i])
			holder(thickness, cable_lock=even);
		}
	
		// upper holders
		color("skyblue")
		translate([0, 0, dz])
		holder(thickness, is_upper=true, cable_lock=false);
	
		translate([0, 0, dz*2])
		color("lightblue")
		holder(thickness, is_upper=true);
	}
	
	// Servo
	translate([-GEARS_DISTANCE, 0, 0])
	translate([0, 0, -PLAY])
	color([.20,.20,.20])
	servo(rotation=SERVO_H_ANGLE);
	
	// Gears
	translate([-GEARS_DISTANCE, 0, 0])
	rotate([0,0,-t/2]) {
		color("blue")
		gears_wheel(thickness=thickness);
		translate([5, 0, 0])
		color("lightblue")
		cylinder(r=0.5, h=thickness+TOLERANCE);
	}
	
	translate([0, 0, PLAY])
	color("yellow")
	rotate([0,0,t])
	gears_pinion(thickness=thickness);
	
	// Plate
	if(1)
	translate([0, 0, PLAY+thickness])
	rotate([0,0,t]) {
		plate(thickness, thickness2, no_cuts);

		// Box
		%translate([0, 0, thickness])
		box(height, thickness2);
	}
}

module block(thickness, thickness2, height, no_cuts=false, extra_holders=0) {
	translate([0, 0, -thickness*2 - PLAY])
	_block(thickness, thickness2, height, no_cuts, extra_holders);
}

//projection(cut=true)
block(4, 3, 10);