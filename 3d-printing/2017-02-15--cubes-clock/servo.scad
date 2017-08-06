SERVO_THICKNESS = 11.5;
SERVO_AXIS_RADIUS = 3;

module servo_hull(with_clearances=false) {
    rotate([0, 0, -90])
    translate([0, 0, -SERVO_THICKNESS/2])
    linear_extrude(height=SERVO_THICKNESS)
    //offset(delta=TOLERANCE/2) // <== Loosen a bit the cavity
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
    radius = 0.8;
    rotate([0, 0, -90])
    minkowski() {
        scale([10, 10, 1])
        linear_extrude(height=0.0001)
        import("servo-grips.dxf");
        sphere(r=radius, $fn=15);
    }
}

module servo_cover(thickness, shave_by=0 /*TOLERANCE*/) {
    rotate([0, 0, -90])
    difference() {
        linear_extrude(height=thickness)
        offset(delta=-shave_by)
        scale([10, 10, 1])
        import("servo-cover.dxf");
    }   
}

module servo_cover_clip(thickness, grow_by=0 /*TOLERANCE*/) {
    rotate([0, 0, -90])
    difference() {
        linear_extrude(height=thickness)
        offset(delta=grow_by)
        scale([10, 10, 1])
        import("servo-cover-clip.dxf");
    }   
}


//%servo_hull();
//servo_grips();
//servo_cut(20, 8);
