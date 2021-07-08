K = 2;

$fn = 60;
R = 10;
S = 6.5/K;
Z_STEPS = 12 *K;
Y_STEPS = 5 *K;

N = 1;

// animate: 1, 24, 24

module shape() {
	for (i = [0:Z_STEPS-1]) {
		z_angle = 360 / Z_STEPS * i;
		for (j0 = [1:Y_STEPS]) {
			y_angle = 90 / Y_STEPS * j0;
            j = pow(j0/Y_STEPS, 1.7) * Y_STEPS;
			y_angle_2 = 90 / Y_STEPS * j;
			size = sin(y_angle)*S;
            //size = (y_angle/90)*S;

            b = i / (Z_STEPS) * 360;
            a = j0 / (Y_STEPS) * 360;

			rotate([0, 0, z_angle+y_angle_2])
			rotate([0, y_angle_2, 0])
			translate([0, 0, R])

//            rotate([b/2 + (y_angle-z_angle), a + z_angle, y_angle+45])
//            rotate([0, -b/2, a])
//            rotate([0, 0, a])

            rotate([45, 45, 45])
            rotate([a, 0, 0])
            rotate([0, 0, b/2])
            cube(size, center=true);
            //cylinder(h=size, d=size*1.5, center=true);
            //scale([1.75,1.75,.75]) sphere(size);
        }
	}
}

rotate([0,0, $t*360])
difference() {
    shape();
    //translate([0, 0, -R]) cylinder(h=R, r=R+S);
    //sphere(r=R);
}