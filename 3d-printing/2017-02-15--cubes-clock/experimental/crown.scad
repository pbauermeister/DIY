include <definitions.scad>

module crown_chamfer(outer_radius, inner_radius, height, thickness) {
    angle = 35;
    width = outer_radius - inner_radius;
    
    translate([inner_radius, -thickness/2, 0])
    intersection() {
        // segment
        cube([width, thickness, height*2]);

        // top+bottom chamfers
        translate([width, 0, 0])
        rotate([0, angle, 0])
        translate([-outer_radius, -ATOM, 0])
        cube([outer_radius*2, thickness+ATOM*2, height*cos(angle)]);

        // top is flat
        h = height+sin(angle)*width -TOLERANCE;
        translate([width, 0, 0])
        translate([-outer_radius, -ATOM, 0])
        cube([outer_radius*2, thickness+ATOM*2, h]);
    }
}

module crown_inner(outer_radius, inner_radius, height, amplitude, is_top=false) {
    narrowness = 80;
    steps = 360 * 10;
//    steps = 360 / 2; // no STL error at this resolution

    delta_angle = 360 / steps;
    delta_cord = outer_radius * sin(delta_angle/2) *2;
    echo(outer_radius-inner_radius, height);

    if (outer_radius-inner_radius > height/2)
        echo("### crown_inner(): ATTENTION height is too small for chamfer!");
    
    for (i=[0:steps-1])
//    i=1;
    {
        a = i * delta_angle;
        z0 = pow(sin(a*2), narrowness);
        z = z0 * amplitude -1;
        rotate([0, 0, a])
        translate([0, 0, z])
        crown_chamfer(outer_radius, inner_radius, height, delta_cord);
    }
}

module crown(radius=BOX_SIDE/2, thickness=6, outer_height=7.5,
             amplitude=1, z_shift=2) {
    outer_radius = radius;
    med_radius = outer_radius - thickness*0.5;
    inner_radius = outer_radius - thickness;
    play = PLAY;

    // outer ring
    barrel(outer_radius, med_radius+play-TOLERANCE, outer_height);

    difference() {
        // crown
        translate([0, 0, z_shift])
        crown_inner(med_radius+play, inner_radius, outer_height-TOLERANCE, amplitude, true);

        // give some play
        translate([0, 0, outer_height+ATOM])
        barrel(outer_radius, med_radius-play-TOLERANCE, outer_height+z_shift);
    }
}

if (0)
    intersection() {
        union() {
            crown();

//            translate([0, 0, 7.5 + TOLERANCE])
//            crown();
        }
        cube(80, 1, 80);
    }
else
//    crown(outer_height=4.5);
    crown(outer_height=3);

