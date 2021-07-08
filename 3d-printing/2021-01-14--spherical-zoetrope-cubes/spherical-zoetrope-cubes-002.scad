KK = 3;
K = 2;
D_HOLE = 7.14375 + .5;

PRINTING = true;
PRINTING_CROSS_CUT = false;

$fn = 60;
R = 10;
S = 7.5/K;
Z_STEPS = 12 *K;
Y_STEPS = 8 *K;

N = 1;

// animate: 1, 24, 24

module shape() {
	for (i = [0:Z_STEPS-1]) {
		z_angle = 360 / Z_STEPS * i;
        //if(i==0)
		for (j0 = [1:Y_STEPS]) {
            j1 = j0 + i/Z_STEPS;
			y_angle = 90 / Y_STEPS * j1;
            j = pow(j1/Y_STEPS, 4) * Y_STEPS;
			y_angle_2 = 90 / Y_STEPS * j;
			size = sin(y_angle_2)*S + S/20;

            b = i / (Z_STEPS) * 360 / 4;
            a = j / (Y_STEPS) * 360 / 4;

			rotate([0, 0, z_angle + y_angle_2])
			rotate([0, y_angle_2, 0])
			translate([0, 0, R])

            rotate([45, 45, 45])
            rotate([a, a, a])
            rotate([0, 0, b])
            cube(size, center=true);
            //cylinder(h=size, d=size*1.5, center=true);
            //sphere(size/.75);
        }
	}
}

module all() {
    scale([KK, KK, KK])
    difference() {
        union() {
            shape();
            sphere(r=R);
        }
        // cut off base
        translate([0, 0, -R]) cylinder(h=R, r=R+S);

        // central hole
        cylinder(h=R*1.5, d=D_HOLE/KK, center=true);
        
        // base  hollowing
        w = 0.5/KK;
        l = R*2.5;
        difference() {
            cylinder(h=0.5, r=R+2.5/KK, center=true);
            union() {
                rotate([0, 0,   0]) cube([w, l, 2], center=true);
                rotate([0, 0,  30]) cube([w, l, 2], center=true);
                rotate([0, 0,  60]) cube([w, l, 2], center=true);
                rotate([0, 0,  90]) cube([w, l, 2], center=true);
                rotate([0, 0, 120]) cube([w, l, 2], center=true);
                rotate([0, 0, 150]) cube([w, l, 2], center=true);
                cylinder(h=R*1.5, d=(D_HOLE+2) / KK, center=true);
            }
        }        
    }

    if(0) difference() {
        cylinder(h=.5, r=R*KK+1);
        cylinder(h=2, d=D_HOLE, center=true);
    }    
}

module anim() {
    rotate([0,0, -$t*360])
    scale([KK, KK, KK])
    shape();
}

module printing() {
    difference() {
        all();
        if (PRINTING_CROSS_CUT) translate([0, 0, -.1]) cube(R*KK*2);
    }
}

if (PRINTING)
    printing();
else
    anim();
