
ATOM =  0.01;

module hinge4(
    thickness,
    angle=180,
    arm_length=0,
    nb_layers=0,
    layer_height=0,
    total_height=0,
    fn=$preview ? 20 : 100,
    tolerance=0.2,
    with_plate=true,
    extra_angle=0,
    extra_angle_tolerance=.2,
    only_alt=-1,
) {
    assert(thickness, "You must specify thickness")
    if (nb_layers==0 && total_height && layer_height) {
        _nb_layers = floor(total_height / layer_height);
        _layer_height = total_height / _nb_layers;
        hinge4_0(thickness, angle, arm_length,
                 _nb_layers, _layer_height, total_height,
                 fn, tolerance, with_plate,
                 extra_angle, extra_angle_tolerance,
                 only_alt);
    }
    else if (nb_layers && total_height==0 && layer_height) {
        _total_height = nb_layers * layer_height;
        hinge4_0(thickness, angle, arm_length,
                 nb_layers, layer_height, _total_height,
                 fn, tolerance, with_plate,
                 extra_angle, extra_angle_tolerance,
                 only_alt);
    }
    else if (nb_layers && total_height && layer_height==0) {
        _layer_height = total_height / nb_layers;
        hinge4_0(thickness, angle, arm_length,
                 nb_layers, _layer_height, total_height,
                 fn, tolerance, with_plate,
                 extra_angle, extra_angle_tolerance,
                 only_alt);
    }
    else assert(false, "You must specify exactly 2 of (nb_layers, total_height, layer_height)");
}

module hinge4_0(
    thickness,
    angle,
    arm_length,
    nb_layers,
    layer_height,
    total_height,
    fn,
    tolerance,
    with_plate,
    extra_angle,
    extra_angle_tolerance,
    only_alt,
) {
    echo("**** only-alt", only_alt)
    echo("**** only-alt!=1", only_alt!=1)
    echo("**** only-alt!=0", only_alt!=0)
    if (only_alt!=1)
    hinge4_1(0, thickness, angle, arm_length, nb_layers, layer_height, total_height,
             fn, tolerance, with_plate, extra_angle, extra_angle_tolerance);

    if (only_alt!=0)
    hinge4_1(1, thickness, angle, arm_length, nb_layers, layer_height, total_height,
             fn, tolerance, with_plate, extra_angle, extra_angle_tolerance);
}

module hinge4_1(
    alt,
    thickness,
    angle,
    arm_length,
    nb_layers,
    layer_height,
    total_height,
    fn,
    tolerance,
    with_plate,
    extra_angle,
    extra_angle_tolerance
) {
    echo("*** thickness, nb_layers, total_height, layer_height, $fn",
         thickness, nb_layers, total_height, layer_height, fn);
    // ghost envelope
    //%cylinder(d=thickness, h=total_height, $fn=20);

    min_wall = 0.3;

    difference() {
        for (i=[alt:2:nb_layers-1]) {
            shave_top = (nb_layers <=1 ? 0 : i < nb_layers-1 ? tolerance : 0);
            shave_bottom = (nb_layers <=1 ? 0 : i > 0 ? tolerance : 0);
            h = layer_height - shave_top - shave_bottom;

            translate([0, 0, i*layer_height + shave_bottom]) {
                difference() {
                    // arm
                    union() {
                        cylinder(d=thickness, h=h, $fn=fn);

                        if (arm_length) {
                            rotate([0, 0, i%2 == 0 ? 0 : angle])
                            translate([0, -thickness/2, 0])
                            cube([arm_length, thickness, layer_height - shave_top - shave_bottom]);
                        }
                    }

                    // cavity
                    if (i < nb_layers-1)
                        translate([0, 0, h-thickness/2+ATOM])
                        cylinder(d1=min_wall*3, d2=thickness-min_wall*2, h=thickness/2, $fn=fn);
                }

                // pillar
                if (i > 0) {
                    translate([0, 0, -thickness/2])
                    cylinder(d1=min_wall*2, d2=thickness-min_wall*2, h=thickness/2, $fn=fn);

                    translate([0, 0, -tolerance*2])
                    cylinder(d1=thickness-min_wall*3, d2=thickness, h=tolerance*2, $fn=fn);


                    translate([0, 0, -thickness/2 - tolerance*2])
                    cylinder(d1=min_wall, d2=min_wall*2, h=tolerance*2, $fn=fn);
                }
            }
        }
    }

    if (with_plate && arm_length) {
        if (alt) {
            difference() {
                rotate([0, 0, 180+angle])
                translate([-arm_length, -thickness/2, 0])
                cube([arm_length-thickness/2 - tolerance*3, thickness, total_height]);

                if (extra_angle) for(i=[1,-1])
                    rotate([0, 0, angle + (90 + extra_angle)*i])
                    translate([-arm_length, -thickness/2 -extra_angle_tolerance, -ATOM])
                    cube([arm_length, thickness +extra_angle_tolerance*2, total_height+ATOM*2]);
            }
        }
        else {
            difference() {
                rotate([0, 0, 180])
                translate([-arm_length, -thickness/2, 0])
                cube([arm_length-thickness/2 - tolerance*3, thickness, total_height]);

                if (extra_angle) for(i=[1,-1])
                    rotate([0, 0, (90 + extra_angle)*i])
                    translate([-arm_length, -thickness/2, -ATOM])
                    cube([arm_length, thickness, total_height+ATOM*2]);
            }
        }
    }
}


// examples
k = 35/50;

translate([0, 65*k, 0])
hinge4(thickness=10*k, arm_length=18*k, total_height=50*k, nb_layers=5, angle=180, extra_angle=0);

translate([0, 40*k, 0])
hinge4(thickness=10*k, arm_length=18*k, total_height=50*k, nb_layers=5, angle=180, extra_angle=50);

l = 15*k;
for(a=[0: 90: 3*90])
    rotate([0, 0, a])
    translate([-l, -l, 0])
    hinge4(thickness=10*k, arm_length=l, total_height=50*k, nb_layers=5, angle=90, extra_angle=50);
