SERVO_THICKNESS = 11.5;
SERVO_AXIS_RADIUS = 3;

module servo_hull(with_clearances=false) {
    rotate([0, 0, -90])
    translate([0, 0, -SERVO_THICKNESS/2])
    linear_extrude(height=SERVO_THICKNESS)
    scale([10, 10, 1]) {
        import("servo.dxf");
        if (with_clearances)
            import("servo-clearances.dxf");
    }
}


module servo_cut(thickness, shave_by=SERVO_AXIS_RADIUS) {
    rotate([0, 0, -90])
    translate([0, 0, -thickness/2])
    linear_extrude(height=thickness)
    offset(r=-shave_by)
    scale([10, 10, 1])
    import("servo.dxf");
   
}

module servo_grips() {
    radius = 0.45;
    translate([0, 0, radius])
    rotate([0, 0, -90])
    minkowski() {
        scale([10, 10, 1])
        linear_extrude(height=0.0001)
        import("servo-grips.dxf");
        sphere(r=radius, $fn=15);
    }
}


//%servo_hull();
//servo_grips();
//servo_cut(20, 8);
